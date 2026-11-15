#!/usr/bin/env bash
set -euo pipefail

fakegit_source_dir=$(cd -- "$(dirname -- "$0")/.." && pwd)
fakegit_under_test=${FAKEGIT_UNDER_TEST:-$fakegit_source_dir/bin/fakegit}
fakegit_test_root=$(mktemp -d)
trap 'rm -rf -- "$fakegit_test_root"' EXIT
mkdir "$fakegit_test_root/tree"
cd "$fakegit_test_root/tree"

check_output() {
  local mode=$1 label=$2
  shift 2
  "$fakegit_under_test" ls-files "$@" >"$fakegit_test_root/output"
  if [[ $mode == nul ]]; then
    LC_ALL=C sort -z "$fakegit_test_root/output" >"$fakegit_test_root/actual"
    printf '%s\0' "${fakegit_expected[@]}" | LC_ALL=C sort -z >"$fakegit_test_root/expected"
  else
    LC_ALL=C sort "$fakegit_test_root/output" >"$fakegit_test_root/actual"
    printf '%s\n' "${fakegit_expected[@]}" | LC_ALL=C sort >"$fakegit_test_root/expected"
  fi
  cmp "$fakegit_test_root/expected" "$fakegit_test_root/actual"
  printf 'PASS: %s\n' "$label"
}

mkdir dir
touch alpha.txt 'space name.rb' dir/nested.rb
fakegit_expected=(alpha.txt 'space name.rb' dir/nested.rb)
check_output lines 'ordinary listing'
fakegit_expected=(nested.rb)
check_output lines 'legacy directory listing' dir

touch $'tab\tname.rb' $'line\nbreak.rb' 'back\slash.rb' ./-z
fakegit_expected=(alpha.txt 'space name.rb' dir/nested.rb $'tab\tname.rb' $'line\nbreak.rb' 'back\slash.rb' -z)
check_output nul 'NUL-separated filenames' -z
check_output nul 'explicit current-directory path' -z -- .
fakegit_expected=(nested.rb)
check_output nul 'NUL directory listing' -z dir
fakegit_expected=(dir/nested.rb)
check_output nul 'pathspec glob' -z -- 'dir/*.rb'
check_output nul 'pathspec directory' -z -- dir/
fakegit_expected=(-z)
check_output nul 'literal option-like filename' -z -- -z

"$fakegit_under_test" ls-files -- 'bin/*' >"$fakegit_test_root/output"
test ! -s "$fakegit_test_root/output"
printf 'PASS: unmatched executable glob\n'
mkdir bin
touch bin/tool 'bin/helper name'
fakegit_expected=(bin/tool 'bin/helper name')
check_output lines 'executable glob' -- 'bin/*'
check_output nul 'NUL executable glob' -z -- 'bin/*'

printf '# existing ignore patterns\n*/skip.rb\n' >.gitignore
touch dir/skip.rb
fakegit_expected=(dir/nested.rb)
check_output nul 'existing ignore pattern' -z -- dir

if "$fakegit_under_test" ls-files --unknown >"$fakegit_test_root/output" 2>"$fakegit_test_root/error"; then
  printf 'Unsupported option unexpectedly succeeded\n' >&2
  exit 1
fi
if "$fakegit_under_test" ls-files missing-directory >"$fakegit_test_root/output" 2>"$fakegit_test_root/error"; then
  printf 'Missing directory unexpectedly succeeded\n' >&2
  exit 1
fi
printf 'PASS: invalid requests fail\n'
