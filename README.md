# presidium-styling-base

TLDR; This is the System Level styling for Presidium.

This repo makes up the `styling` portion of the Presidium System Level Theme, and contains the officially support theme features.
For more info on Hugo Themes see the official Hugo documentation [here](https://gohugo.io/hugo-modules/theme-components/)

# Getting Started

### Method 1 - Just using the Presidium Themes in your Hugo site (Default)

Update the `config.yml`:

```
module:
  imports:
  - path: github.com/spandigital/presidium-styling-base
  - path: github.com/spandigital/presidium-layouts-base
```

### Method 2 - Working on contributing to this repo in local development.

1. Clone the theme
2. Clone the [presidium-test-validation](https://github.com/SPANDigital/presidium-test-validation) repo. We use the `presidium-test-validation` repo as the styling and functionality test bed, where we throw all the officially supported features in with the kitchen sink, so that we can validate every theme change has no unintended effects.
3. Open the `go.mod` file in your `presidium-test-validation` clone.
4. Add the following to the bottom of your `go.mod` file, and update the path after the arrow to the correct path where you cloned the theme layout:

```
replace github.com/spandigital/presidium-styling-base => /{path-on-your-machine}/presidium-styling-base
```

5. Run a refresh and then build the docset with Hugo:

```
make refresh
```

If you don't have the Makefile in your docset, then you can copy it from [here](https://github.com/SPANDigital/presidium/blob/develop/templates/default/Makefile)
Then run

```
make serve
```

Your served site should be available on `localhost:1313`.

---

## Conventional Commits

At SPAN we use [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) to make our commit messages more useful.

## Semantic Releases

This repository uses [Semantic Release](https://semantic-release.gitbook.io/semantic-release/) tool to automate version management and package publishing.

Upon merging into to the main or develop branch, Semantic Release tool will:

- Calculate the new release version based on the commits
- Create a git commit and a git tag for the release
- Create a Release with release notes from the commit messages
- Create and publish the container images

---

## Branching

This repo uses trunk-based development (TBD).
If you are not familiar with TBD, then please read this [article](https://www.optimizely.com/optimization-glossary/trunk-based-development/).

Other TBD articles:

- [Trunk based development - pros and cons](https://medium.com/@sabri.mutlucag/trunk-based-development-pros-cons-and-why-you-should-consider-adopting-it-81cd7c24626c)
- [Why I love TBD](https://medium.com/@mattia.battiston/why-i-love-trunk-based-development-641fcf0b94a0)
- [A complete guide to TBD](https://medium.com/@SplitSoftware/a-complete-guide-to-trunk-based-development-2b335f57d286)

In summary:

- `main` ⇾ release versions created from main.
- `develop` ⇾ the develop branch should NOT exist in this repo.
- `branch` ⇾ branch directly off main.  
  **Branch prefixes** : prefix your branch with the type of work done in the branch, eg.:
  - `feat/` : feature.
  - `fix/` : fixing a bug.
  - `chore/` : mundane update chore.
  - `refactor/` : restructuring or cleaning-up code but no functional additions.

Make sure to include:

- Any necessary feature flags, and set the default behaviour as DISABLED until the team agrees to change that.
- Code unit tests as far as possible.

---

## Linting and Pre-Commit Hook Setup

This project uses `Stylelint`, `Prettier`, and `Husky` to ensure consistent SCSS formatting and linting. A pre-commit hook is configured to automatically run linting tasks before commits.

### Prerequisites

- Ensure **Node.js** and **Yarn** are installed.
- Clone the repository to your local machine.

### Installation

1. Install dependencies:

````bash
yarn install
2. Set up Husky:
```bash
yarn prepare

### Commands
#### Linting
1. Check for linting issues:
```bash
yarn lint

2. Fix linting and formatting issues:
```bash
yarn lint:fix
#### Pre-Commit Hook
The pre-commit hook runs automatically when committing changes to .scss files. It performs the following steps:

- Formats staged .scss files using Prettier.
- Lints and fixes issues using Stylelint.

If linting issues cannot be fixed automatically, the commit will fail. You’ll need to resolve the issues manually before committing again.

##### Skipping the Pre-Commit Hook
To skip the pre-commit hook (not recommended):
```bash
git commit --no-verify -m "Your commit message"
````
