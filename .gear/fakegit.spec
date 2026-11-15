%define        _unpackaged_files_terminate_build 1

Name:          fakegit
Version:       1.1.0
Release:       alt2
Summary:       Emulating some "git" commands
License:       MIT
Group:         Development/Other
Url:           https://github.com/majioa/fakegit
Vcs:           https://github.com/majioa/fakegit.git
BuildArch:     noarch

Source:        %name-%version.tar
Patch:         %name-%version-%release.patch

BuildRequires: diffutils

%description
The `fakegit` command provides some psuedo "git" commands. The clone is
allowing applying for GitHub repository only, which downloads files with svn,
curl, or wget. This is useful for environments which is difficult to installing
git command.

The `ls-files` just ls all files within current, and the underneath folders.


%prep
%setup
%autopatch -p1

%install
%makeinstall_std BINDIR=%_gamesbindir

%check
%make check

%files
%doc *.md
%_gamesbindir/git
%_gamesbindir/%name


%changelog
* Sun Nov 15 2026 Pavel Skrylev <majioa@altlinux.org> 1.1.0-alt2
- ! fixed NUL-separated ls-files output and path selection in gemspecs
- + added filename and path selection checks

* Fri Mar 01 2024 Pavel Skrylev <majioa@altlinux.org> 1.1.0-alt1.1
- ! fixed install path to games, which is also default one in PATH

* Wed Feb 21 2024 Pavel Skrylev <majioa@altlinux.org> 1.1.0-alt1
- Initial build v1.1.0 for Sisyphus.
