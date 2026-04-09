<div align="center">

# asdf-lisette [![Build](https://github.com/eratio08/asdf-lisette/actions/workflows/build.yml/badge.svg)](https://github.com/eratio08/asdf-lisette/actions/workflows/build.yml) [![Lint](https://github.com/eratio08/asdf-lisette/actions/workflows/lint.yml/badge.svg)](https://github.com/eratio08/asdf-lisette/actions/workflows/lint.yml)

[lisette](lisette.run) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

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

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/eratio08/asdf-lisette/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Eike Lurz](https://github.com/eratio08/)
