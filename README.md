# Presidium Styling Base

This is the system level styling for Presidium and is manage by the Presidium Team.
If you are looking to make changes to the styling available on your organization's deployment of Presidium Enterprise, you are probably looking for `your/github/path/org/{client-name}-styling-base` which would only apply to your organization and wouldn't impact all Presidium clients.

This repo makes up the `styling` portion of the Presidium "System Level Theme", and contains the officially support theme features.
See the official Hugo [theme documentation](https://gohugo.io/hugo-modules/theme-components/) for more information.

## Getting Started

### Method 1 - Just using the Presidium Themes in your Hugo site (Default)

Update the `config.yml`:

```yaml
module:
  imports:
    - path: github.com/spandigital/presidium-styling-base
    - path: github.com/spandigital/presidium-layouts-base
```

### Method 2 - Contributing to this repo

1. Clone the theme
2. Clone the [presidium-test-validation](https://github.com/SPANDigital/presidium-test-validation) repo. We use the `presidium-test-validation` repo as the styling and functionality test bed, where we throw all the officially supported features in with the kitchen sink, so that we can validate every theme change has no unintended side effects on any downstream themes that import this repo.
3. Open the `go.mod` file in your `presidium-test-validation` clone.
4. Add the following to the bottom of your `go.mod` file, and update the path after the arrow to the correct path where you cloned the theme layout:

```gotemplate
replace github.com/spandigital/presidium-styling-base => /{path-on-your-machine}/presidium-styling-base
```

5. Run a refresh and then build the docset with Hugo:

```shell
make refresh
```

If you are working in your own enterprise repo and not in the `presidium-test-validation`, then you can copy the latest version from [presidium-test-validation develop branch](https://github.com/SPANDigital/presidium-test-validation/blob/develop/Makefile)
Then run

```shell
make serve
```

Your served site should be available at `localhost:1313`.

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

```shell
yarn install
```

2. Set up Husky:

```shell
yarn prepare
```

### Commands

#### Linting

1. Check for linting issues:

```shell
yarn lint
```

2. Fix linting and formatting issues:

```shell
yarn lint:fix
```

#### Pre-Commit Hook

The pre-commit hook runs automatically when committing changes to .scss files. It performs the following steps:

- Formats staged .scss files using Prettier.
- Lints and fixes issues using Stylelint.

If linting issues cannot be fixed automatically, the commit will fail. You’ll need to resolve the issues manually before committing again.

##### Skipping the Pre-Commit Hook

To skip the pre-commit hook (not recommended):

```shell
git commit --no-verify -m "Your commit message"
```

---

## How Hugo assembles CSS

The Presidium theme is highly specialised Hugo theme, and Hugo has some very strict rules when it composes the final CSS when the `hugo` build command is run.

Firstly the Presidium theme uses Hugo module imports and not the generic Hugo themes folder, so that we can have better version controls between the implemented theme layers, which directly impacts how we can support our official Presidium features.

The layers are:

1. SYSTEM LEVEL THEME - where all officially supported features are managed for ALL Presidium clients.
2. ENTERPRISE LEVEL THEME - where all client specific overrides of the system level theme should be implemented.
3. DOCS MODULE THEME - this scope is isolated to a single documentation site. This is where the Hugo build command is run and where the compiled files will be output into a `public/` directory inside the documentation module working dir.

Since Hugo uses a file REPLACEMENT inheritance mechanism, any file with a colliding relative file path will be replaced by the version of the file in the repo that imports the parent module.

> [!IMPORTANT] > **Hugo Replacement Inheritance**: Any file that exists in the ENTERPRISE LEVEL THEME inside the `assets/_sass/defaults` directory and collides with the file path of any of the files in this repo inside that directory, will COMPLETELY REPLACE the contents of the parent import file with the same name.
> Think of it as a Class override in OOP.

For example:
In the enterprise theme repo there is a file `assets/_sass/defaults/_default-variables.scss`.
The contents of that file would completely replace the contents of all the variables declared in the same file in this repo, so care must be taken not to miss any downstream use of the variables, otherwise the Hugo build will fail.

Then Hugo processes the combined files in the system, enterprise and module styles in a particular order according to the declared import order.
See the `assets/presidium.scss` file for an example.

**The file replacement logic is roughly:**

Using the perspective from the system level repo down the inheritance tree:

For each file in the repo:

- load the system level version of the file
- if a file with same relative path exists in the enterprise repo:
  - replace the system level version of the file with the enterprise version of the file
  - if a file with the same relative path exists in the documentation module:
    - replace either the system level or enterprise level version of the file with the documentation module version of the file

Alternatively, using the perspective from the documentation module repo up the inheritance tree:

Non-colliding file paths get propagated all the way down to documentation module level to be parsable in the documentation module at Hugo build time.
If there are any colliding file paths, only the closest child version of the file gets propagated down to be parsable at Hugo build time.
Similar to overriding a class in an imported Go library.

Once the file inheritance has been resolved, then the SCSS import paths are traversed in order of declaration.

### Implications

The loading order has the following implications:

- Variable definitions marked with `!default` in the `enterprise-styling-base` that exist in `presidium-styling-base` are ignored.
- Variable definitions that are marked with `!important` will not be overridden in any later import. The only way to override these variables is to use the Hugo file replacement mechanism in the advanced configuration inheritance.
- Variables defined in the enterprise's `client-custom` directory are not available to the Bootstrap and Presidium CSS because [Sass variables](https://sass-lang.com/documentation/variables/) are declarative.

### Best Practices

Variables that are intended to propagate through to all client Presidium styling themes CSS must be defined in the enterprise's default files by replacing the files in the `defaults` directory with the versions customized for your organization.

The enterprise's `client-custom` directory should include variable definitions and styling for:

- Layouts and shortcodes defined in the enterprise layout theme.
- Overrides for Presidium's CSS that can't be changed using variables.

Passing CSS variables as Sass variables requires care and thorough testing.
