# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

asdf plugin test lisette https://github.com/eratio08/asdf-lisette.git "lis --help"

# Test the checked out repo directly
asdf plugin test lisette "$PWD" "lis --help"
```

The plugin currently exercises a source build.
Local testing therefore requires the same Lisette upstream dependencies as installation: Rust/Cargo and Go.

Tests are automatically run in GitHub Actions on push and PR.
