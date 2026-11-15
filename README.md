fakegit(1) -- Emulating some "git" commands
=================

## SYNOPSIS

`fakegit <command> [<arguments>]`

### ls-files

`fakegit ls-files [-z] [<directory>]`

`fakegit ls-files [-z] -- [<path>...]`

By default, filenames are separated by newlines. With `-z`, filenames are
separated by NUL bytes, preserving whitespace, newlines and backslashes.
The optional directory keeps the original directory-relative listing behavior.
After `--`, paths and quoted glob patterns select files relative to the current
directory, for example `fakegit ls-files -z -- 'lib/*.rb'`. An unmatched pattern
produces no output. This lists filesystem contents, not a Git index.

Run `make check` to check filename separators and path selection.

### clone

`fakegit clone [-b <branch_name>] <GitHub Repository URL> [<directory>]`

## DESCRIPTION

The `fakegit` command provides some psuedo "git" commands. The clone is allowing applying for GitHub repository only, which downloads files with svn, curl, or wget. This is useful for environments which is difficult to installing git command.

The `ls-files` just ls all files within current, and the underneath folders.

It can be installed as real fake `git` instead of real one into _%_bindir_ folder, as follows

    $ make install

To install fakegit, type as follows:

    $ mkdir -p $HOME/bin
    $ export PATH=$HOME/bin:$PATH
    $ curl -L https://raw.github.com/majioa/fakegit/master/bin/fakegit > $HOME/bin/git
    $ chmod a+x $HOME/bin/git
    $ hash -r

If necessary, enable fakegit in your shell by adding `$HOME/bin`
to your `PATH` and restart your shell.
