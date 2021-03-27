[//]: # "managed by eankeen/globe; don't edit!"

# Contributing

👋 Hey! Thankies for contributing! I would recommend reading the following as general guidelines :)

## Pull Requests

Before you make a PR

1. _create an issue of what you plan to add_
2. _do **not** commit to `dev` or `master`/`main` branch_ directly

Of course, if you're change is relatively small, this may not be needed.

## Commit Naming

-  Keep commits short and meaningful
-  Use the imperative, present tense
-  Do not capitalize the first letter
-  Do not add a period

Commits are generally based on the [AngularJS](https://github.com/angular/angular/blob/master/CONTRIBUTING.md) conventions, an extension of [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)

### Examples

```md
refactor: use FactoryInjector in `util/addtheme.ts`
fix(renderer): inject css styles
```

## Branch naming

be sure to create a new branch when contributing. _do **not** commit to the `dev` or `master` branch_ directly. use tokens to categorize branches. add blurb about branch, separated by token with forward slash. see [this](https://stackoverflow.com/a/6065944) for more information.

### Tokens

```sh
fix  # bug fixes, hotfixes
misc # miscellaneous
wip  # new feature with unclear completion time
feat # new feature with clear completion time
```

<!-- markdownlint-disable MD024 -->

### Examples

<!-- markdownlint-enable MD024 -->

```sh
fix/webpack-fail-start
misc/org-assets # organize assets directory
wip/offline-editing
feat/util-tests
```
