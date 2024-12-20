# presidium-styling-base

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
