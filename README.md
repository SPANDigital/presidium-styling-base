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

## Linting and Pre-Commit Hook Setup
This project uses `Stylelint`, `Prettier`, and `Husky` to ensure consistent SCSS formatting and linting. A pre-commit hook is configured to automatically run linting tasks before commits.

### Prerequisites
- Ensure **Node.js** and **Yarn** are installed.
- Clone the repository to your local machine.

### Installation

1. Install dependencies:
  ```bash
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
