[//]: # "managed by eankeen/globe; don't edit!"

# Commit Vonventions

## Commit Naming

* Keep commits short and meaningful
* Use the imperative, present tense ('change' rather than 'changed' or 'changes')
* Do not capitalize the first letter
* Do not add a period

Here are some high-quality examples. note that you don't need to match the formatting, just the guidelines stated above :ok_hand:

```md
feat(ts): convert util/addtheme.js to ts
fix(renderer): inject css styles
```

### Some handy keywords

`(feat|fix|polish|docs|style|refactor|perf|test|workflow|ci|chore|types)`

## Branch naming

be sure to create a new branch when contributing. *do **not** commit to the `dev` or `master` branch*. use tokens to categorize branches. add blurb about branch, separated by token with forward slash. see [this](https://stackoverflow.com/a/6065944) for more information.

### Tokens

```bash
fix  # bug fixes, hotfixes
misc # miscellaneous
wip  # new feature with unclear completion time
feat # new feature with clear completion time
```

### Examples

```bash
fix/webpack-fail-start
misc/org-assets # organize assets directory
wip/offline-editing
feat/util-tests
```