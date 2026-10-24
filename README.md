# dotfiles

Install the check tools and Node dependencies, then install this repository's Git hooks:

```sh
mise install
pnpm install
mise exec -- hk install --mise --legacy
```

Run all checks or apply available fixes:

```sh
mise exec -- hk check --all
mise exec -- hk fix --all
```

`hk.pkl` shares the checks between these commands and the pre-commit hook. Fixes stay
unstaged when running `hk fix`. The commit-message hook checks for surrounding whitespace.
Spell checking uses the personal dictionaries declared in `.cspell.yaml`.

My dotfiles!
