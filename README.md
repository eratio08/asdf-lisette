<div align="center">

# asdf-lisette [![Build](https://github.com/eratio08/asdf-lisette/actions/workflows/build.yml/badge.svg)](https://github.com/eratio08/asdf-lisette/actions/workflows/build.yml) [![Lint](https://github.com/eratio08/asdf-lisette/actions/workflows/lint.yml/badge.svg)](https://github.com/eratio08/asdf-lisette/actions/workflows/lint.yml)

[Lisette](https://lisette.run) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Help](#help)
- [Binary Releases](#binary-releases)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, `git`, and standard POSIX utilities.
- [Rust and Cargo](https://rustup.rs/).
Lisette currently builds from source, and upstream requires Rust 1.94 at the time of writing.
- [Go](https://go.dev/dl/) 1.25 or newer.
This matches Lisette's upstream requirements.
- Optional: `GITHUB_API_TOKEN` to avoid GitHub API rate limits when listing or resolving versions in CI.

# Install

Plugin:

```shell
asdf plugin add lisette
# or
asdf plugin add lisette https://github.com/eratio08/asdf-lisette.git
```

lisette:

```shell
# Show all installable versions
asdf list-all lisette

# Install specific version
asdf install lisette latest

# Set a version globally (on your ~/.tool-versions file)
asdf global lisette latest

# Now lisette commands are available
lis --help
```

This plugin currently installs Lisette from tagged source releases.
Upstream GitHub releases do not yet publish prebuilt CLI assets.

# Help

```shell
asdf help lisette
```

# Binary Releases

When Lisette starts publishing OS and architecture specific release assets, this plugin should switch `bin/download` to fetch those binaries directly.

The intended future flow is:

- `bin/download` selects an asset for the current platform.
- `bin/install` unpacks or copies `lis` into `$ASDF_INSTALL_PATH/bin`.
- Source builds remain as a fallback until binary coverage is complete.

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/eratio08/asdf-lisette/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Eike Lurz](https://github.com/eratio08/)
