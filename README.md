# Homebrew tap of runtree

[runtree](https://github.com/nagylzs/runtree) runs a tree of commands, each in its own terminal that you can step
into.

```bash
brew install nagylzs/runtree/runtree
```

On macOS it installs all the programs: `runtree` (the GUI, with GTK 4, VTE and socat), `runtree-headless`,
`rtrunner` and `runtree-lsp`. On Linux it installs them without the GUI; for the GUI, see
[Getting started](https://github.com/nagylzs/runtree/blob/main/docs/getting-started.md).

The formula builds the source tarball of the release with `scripts/build.py`. A new release gets a pull request from
the autobump workflow; its tests build the bottles, and the `brew pr-pull` workflow publishes them.
