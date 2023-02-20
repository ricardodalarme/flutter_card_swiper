# Contributing to this package

## Table of Contents

- [Contributing to this package](#contributing-to-this-package)
  - [Table of Contents](#table-of-contents)
  - [Version and CHANGELOG updates](#version-and-changelog-updates)
    - [Version](#version)
    - [CHANGELOG](#changelog)
      - [Style](#style)
      - [Example](#example)
      - [Updating a CHANGELOG that has a NEXT](#updating-a-changelog-that-has-a-next)

## Version and CHANGELOG updates

### Version

Any change that needs to be published in order to take effect must update the version in pubspec.yaml. There are very few exceptions:

- PRs that only affect tests.
- PRs that only affect example apps.
- PRs that only affect local development (e.g., changes to ignored lints).
- PRs that only make symbolic changes to the docs (e.g. typo).

And the new version must follow the [pub versioning philosophy].

### CHANGELOG

All version changes must have an accompanying CHANGELOG update. Even version-exempt changes should usually update CHANGELOG by adding a special `NEXT` entry at the top of `CHANGELOG.md` (unless they only affect development of the package, such as test-only changes):

```md
## NEXT

* Description of the change.

## 1.0.2
...
```

This policy exists because some changes (e.g., updates to examples) that do not need to be published may still be of interest to clients of a package.

#### Style

For consistency, all CHANGELOG entries should follow a common style:

- Use `##` for the version line. A version line should have a blank line before and after it.
- Use `-` for individual items.
- Entries should use present tense indicative for verbs, with "this version" as an implied subject. For example, "Adds cool new feature.", not "Add" or "Added".
- Entries should end with a `.`.
- Breaking changes should be introduced with **BREAKING CHANGE**:, or **BREAKING CHANGES**: if there is a sub-list of changes.

#### Example

```md
## 2.0.0

- Adds the ability to fetch data from the future.
- **BREAKING CHANGES**:
  - Removes the deprecated `neverCallThis` method.
  - URLs parameters are now `Uri`s rather than `String`s.

## 1.0.3

- Fixes a crash when the device teleports during a network operation.
```

#### Updating a CHANGELOG that has a NEXT

If you are adding a version change to a CHANGELOG that starts with `NEXT`, and your change also doesn't require a version update, just add a description to the existing `NEXT` list:

```md
## NEXT

* Description of your new change.
* Existing entry.

## 1.0.2
...
```

If your change does require a version change, do the same, but then replace `NEXT` with the new version. For example:

```md
## 1.0.3

* Description of your new change.
* Existing entry.

## 1.0.2
...
```

<!-- Links -->
[pub versioning philosophy]: https://dart.dev/tools/pub/versioning
