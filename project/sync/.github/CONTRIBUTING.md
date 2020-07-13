<!-- managed by 'eankeen/globe'; don't edit! -->

# contributing

👋 hey! thanks for thinking about contributing! make sure you read the following three sections before contributing.

## pull requests

before you make a pr

1. *create an issue of what you plan to add*
2. *do **not** commit to `dev` or `master` branch* directly

of course, if you're change is relatively small, this may not be needed.

## commit naming

* keep commits short and meaningful
* use the imperative, present tense ('change' rather than 'changed' or 'changes')
* do not capitalize the first letter
* do not add a period

here are some high-quality examples. note that you don't need to match the formatting, just the guidelines stated above :ok_hand:

```md
feat(ts): convert util/addtheme.js to ts
fix(renderer): inject css styles
```

### some handy keywords

`(feat|fix|polish|docs|style|refactor|perf|test|workflow|ci|chore|types)`

## branch naming

be sure to create a new branch when contributing. *do **not** commit to the `dev` or `master` branch* directly. use tokens to categorize branches. add blurb about branch, separated by token with forward slash. see [this](https://stackoverflow.com/a/6065944) for more information.

### tokens

```sh
fix  # bug fixes, hotfixes
misc # miscellaneous
wip  # new feature with unclear completion time
feat # new feature with clear completion time
```

### examples

```sh
fix/webpack-fail-start
misc/org-assets # organize assets directory
wip/offline-editing
feat/util-tests
```
