# \# 🤰👶 Pregnancy \& Baby App — Flutter Mobile

# 

# \*\*One-line:\*\* Mobile app to manage pregnancy tracking, baby care, health logs, appointments, marketplace, and community support.  

# \*\*Tech:\*\* Flutter (mobile), Clean Architecture, Riverpod.

# 

# > This README explains the repository structure, what each folder is, how to run the app, and coding/branch rules.

# 

# ---

# 

# \## 📁 Repo Structure (Brief)

# 

# ```text

# lib/

# ├── core/                 # shared utilities, widgets, theme, services

# ├── features/             # features (auth, pregnancy, baby, health\_log, etc.)

# ├── l10n/                 # localization (EN, FR, AR)

# ├── app.dart              # app config (MaterialApp, theme, routes)

# ├── routes.dart           # defines the app routes

# └── main.dart             # app entry point

# ```

# 

# ---

# 

# \## 🧭 Full Explanation (What to Put Where)

# 

# \### `main.dart`

# 

# App entry. Minimal code: init services and `runApp(MyApp())`.

# 

# \### `app.dart` \& `routes.dart`

# 

# Configure `MaterialApp`, theme, and named routes. Central place to change global settings.

# 

# ---

# 

# \### `core/` — Shared Tools (Used Across Features)

# 

# \- `core/constants/` → colors, text styles, route names, string constants.

# &nbsp; - `app\_colors.dart`, `app\_text\_styles.dart`, `app\_routes.dart`

# \- `core/theme/` → `app\_theme.dart` where the ThemeData lives.

# \- `core/widgets/` → reusable UI widgets used across many screens (buttons, dialogs).

# \- `core/providers/` → cross-feature providers (`user\_mode\_provider.dart`, `locale\_provider.dart`).

# \- `core/services/` → global services (database, API, notifications, local storage).

# \- `core/utils/` → validators, formatters, extensions, date utilities.

# \- `core/exceptions/` → central exception types.

# 

# \*\*Tip:\*\* Put UI components used more than once in `core/widgets/`. If it's specific to a feature, put it under `features/<feature-name>/presentation/widgets/`.

# 

# ---

# 

# \### `features/<feature>/` — Feature Module

# 

# Each feature follows the same internal pattern: `data/`, `domain/`, `presentation/`.

# 

# \*\*Example: `features/pregnancy/`\*\*

# 

# \- `data/`

# &nbsp; - `datasources/` → local or remote data access

# &nbsp; - `models/` → DTOs for the feature

# &nbsp; - `pregnancy\_repository\_impl.dart` → concrete repo implementation

# 

# \- `domain/`

# &nbsp; - `entities/` → pure Dart models (e.g., `Pregnancy`, `Week`)

# &nbsp; - `repositories/` → abstract repository interfaces

# &nbsp; - `usecases/` → single-responsibility classes (e.g., `CalculatePregnancyWeekUseCase`)

# 

# \- `presentation/`

# &nbsp; - `pages/` → screens (e.g., `week\_tracker\_page.dart`)

# &nbsp; - `widgets/` → UI components specific to pregnancy

# &nbsp; - `providers/` → Riverpod providers (e.g., `pregnancy\_provider.dart`)

# 

# \*\*Tip:\*\* Follow this pattern for every feature.

# 

# ---

# 

# \### `l10n/` — Localization

# 

# \- `app\_en.arb` → English translations

# \- `app\_fr.arb` → French translations

# \- `app\_ar.arb` → Arabic translations

# \- Generated files (auto-created by `flutter gen-l10n`)

# 

# ---

# 

# \### `assets/`

# 

# Fonts, icons, images. Update `pubspec.yaml` to include assets.

# 

# ---

# 

# \## 📂 Complete Folder Tree

# 

# ```

# pregnancy\_baby\_app/

# ├── pubspec.yaml

# ├── README.md

# ├── CONTRIBUTING.md

# ├── analysis\_options.yaml

# ├── l10n.yaml

# ├── .gitignore

# │

# ├── lib/

# │ ├── main.dart

# │ ├── app.dart

# │ ├── routes.dart

# │ │

# │ ├── core/

# │ │ ├── constants/

# │ │ │ ├── app\_colors.dart

# │ │ │ ├── app\_text\_styles.dart

# │ │ │ └── app\_routes.dart

# │ │ ├── theme/

# │ │ │ └── app\_theme.dart

# │ │ ├── widgets/

# │ │ │ ├── custom\_button.dart

# │ │ │ ├── custom\_text\_field.dart

# │ │ │ └── app\_dialog.dart

# │ │ ├── providers/

# │ │ │ ├── user\_mode\_provider.dart

# │ │ │ ├── current\_user\_provider.dart

# │ │ │ └── locale\_provider.dart

# │ │ ├── services/

# │ │ │ ├── database/

# │ │ │ │ └── database\_service.dart

# │ │ │ ├── api\_service.dart

# │ │ │ ├── notification\_service.dart

# │ │ │ ├── local\_storage\_service.dart

# │ │ │ └── auth\_service.dart

# │ │ ├── utils/

# │ │ │ ├── date\_utils.dart

# │ │ │ ├── validators.dart

# │ │ │ ├── formatters.dart

# │ │ │ └── extensions.dart

# │ │ └── exceptions/

# │ │ └── app\_exceptions.dart

# │ │

# │ ├── features/

# │ │ ├── auth/

# │ │ │ ├── data/

# │ │ │ │ ├── datasources/

# │ │ │ │ └── models/

# │ │ │ ├── domain/

# │ │ │ │ ├── entities/

# │ │ │ │ ├── repositories/

# │ │ │ │ └── usecases/

# │ │ │ └── presentation/

# │ │ │ ├── pages/

# │ │ │ ├── widgets/

# │ │ │ └── providers/

# │ │ │

# │ │ ├── onboarding/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ ├── dashboard/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ ├── pregnancy/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ ├── baby/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ ├── health\_log/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ ├── health\_analysis/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ ├── plan/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ ├── education/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ ├── doctors/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ ├── marketplace/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ └── profile/

# │ │ ├── data/

# │ │ ├── domain/

# │ │ └── presentation/

# │ │

# │ └── l10n/

# │ ├── app\_en.arb

# │ ├── app\_fr.arb

# │ ├── app\_ar.arb

# │ └── app\_localizations.dart

# │

# ├── assets/

# │ ├── images/

# │ ├── fonts/

# │ └── lottie/

# │

# ├── test/

# │ ├── unit/

# │ ├── widget/

# │ └── integration/

# │

# └── docs/

# ```

# 

# ---

# 

# \## 🏗️ Architecture: Clean Architecture + Riverpod

# 

# \### Three Layers

# 

# 1\. \*\*Presentation Layer\*\* (`features/\*/presentation/`)

# &nbsp;  - UI, pages, widgets, Riverpod providers

# &nbsp;  - Only displays data and captures user input

# 

# 2\. \*\*Domain Layer\*\* (`features/\*/domain/`)

# &nbsp;  - Business logic, entities, repository interfaces, usecases

# &nbsp;  - No Flutter or database knowledge

# 

# 3\. \*\*Data Layer\*\* (`features/\*/data/`)

# &nbsp;  - Database access, API calls, DTOs

# &nbsp;  - Repository implementations

# 

# \### Data Flow

# 

# ```

# UI (Button Click)

# &nbsp;   ↓

# Riverpod Provider (Presentation)

# &nbsp;   ↓

# UseCase (Domain)

# &nbsp;   ↓

# Repository Implementation (Data)

# &nbsp;   ↓

# DataSource (SQLite/API)

# &nbsp;   ↓

# Return Data → Convert to Entity → Update UI

# ```

# 

# ---

# 

# \## 🌿 Branch Workflow

# 

# \### Branch Naming

# 

# ```

# main              # Production-ready code

# develop           # Staging/integration branch

# feature/...       # New features (e.g., feature/pregnancy-tracker)

# fix/...           # Bug fixes (e.g., fix/login-crash)

# docs/...          # Documentation (e.g., docs/update-readme)

# ```

# 

# \### Workflow Steps

# 

# 1\. \*\*Create feature branch:\*\*

# &nbsp;  ```bash

# &nbsp;  git checkout develop

# &nbsp;  git pull origin develop

# &nbsp;  git checkout -b feature/your-feature-name

# &nbsp;  ```

# 

# 2\. \*\*Make changes and commit:\*\*

# &nbsp;  ```bash

# &nbsp;  git add .

# &nbsp;  git commit -m "\[FEATURE] Add pregnancy week calculator"

# &nbsp;  ```

# 

# 3\. \*\*Push to GitHub:\*\*

# &nbsp;  ```bash

# &nbsp;  git push origin feature/your-feature-name

# &nbsp;  ```

# 

# 4\. \*\*Create Pull Request:\*\*

# &nbsp;  - Go to GitHub → Pull Requests → New PR

# &nbsp;  - Set base to `develop`, compare to your feature branch

# &nbsp;  - Add description and request reviewers

# 

# 5\. \*\*After approval, merge on GitHub\*\*

# 

# 6\. \*\*Delete branch:\*\*

# &nbsp;  ```bash

# &nbsp;  git branch -d feature/your-feature-name

# &nbsp;  git push origin --delete feature/your-feature-name

# &nbsp;  ```

# 

# ---

# 

# \## 📝 Development Guidelines

# 

# \### Naming Conventions

# 

# \- `camelCase` for variables, functions, properties

# \- `PascalCase` for classes and enums

# \- `snake\_case` for file names and directories

# 

# \### PR Checklist

# 

# \- \[ ] Code compiles without errors (`flutter analyze` passes)

# \- \[ ] No hardcoded values (use constants)

# \- \[ ] No debug prints

# \- \[ ] Commit messages are clear

# \- \[ ] Documentation updated if needed

# 

# ---

# 

# 

# 

# \## 🛠️ Common Commands

# 

# ```bash

# \# Clone repo

# git clone https://github.com/your-username/pregnancy-baby-app.git

# 

# \# Install dependencies

# flutter pub get

# 

# \# Generate localization files

# flutter gen-l10n

# 

# \# Analyze code

# flutter analyze

# 

# \# Run app

# flutter run

# 

# \# Create feature branch

# git checkout -b feature/your-feature

# 

# \# Commit and push

# git add .

# git commit -m "\[FEATURE] Your description"

# git push origin feature/your-feature

# ```

# 

# ---

# 

# \*\*Last Updated:\*\* October 2025# 🤰👶 Pregnancy \& Baby App — Flutter Mobile

# 

# \*\*One-line:\*\* Mobile app to manage pregnancy tracking, baby care, health logs, appointments, marketplace, and community support.  

# \*\*Tech:\*\* Flutter (mobile), Clean Architecture, Riverpod.

# 

# > This README explains the repository structure, what each folder is, how to run the app, and coding/branch rules.

# 

# ---

# 

# \## 📁 Repo Structure (Brief)

# 

# ```text

# lib/

# ├── core/                 # shared utilities, widgets, theme, services

# ├── features/             # features (auth, pregnancy, baby, health\_log, etc.)

# ├── l10n/                 # localization (EN, FR, AR)

# ├── app.dart              # app config (MaterialApp, theme, routes)

# ├── routes.dart           # defines the app routes

# └── main.dart             # app entry point

# ```

# 

# ---

# 

# \## 🧭 Full Explanation (What to Put Where)

# 

# \### `main.dart`

# 

# App entry. Minimal code: init services and `runApp(MyApp())`.

# 

# \### `app.dart` \& `routes.dart`

# 

# Configure `MaterialApp`, theme, and named routes. Central place to change global settings.

# 

# ---

# 

# \### `core/` — Shared Tools (Used Across Features)

# 

# \- `core/constants/` → colors, text styles, route names, string constants.

# &nbsp; - `app\_colors.dart`, `app\_text\_styles.dart`, `app\_routes.dart`

# \- `core/theme/` → `app\_theme.dart` where the ThemeData lives.

# \- `core/widgets/` → reusable UI widgets used across many screens (buttons, dialogs).

# \- `core/providers/` → cross-feature providers (`user\_mode\_provider.dart`, `locale\_provider.dart`).

# \- `core/services/` → global services (database, API, notifications, local storage).

# \- `core/utils/` → validators, formatters, extensions, date utilities.

# \- `core/exceptions/` → central exception types.

# 

# \*\*Tip:\*\* Put UI components used more than once in `core/widgets/`. If it's specific to a feature, put it under `features/<feature-name>/presentation/widgets/`.

# 

# ---

# 

# \### `features/<feature>/` — Feature Module

# 

# Each feature follows the same internal pattern: `data/`, `domain/`, `presentation/`.

# 

# \*\*Example: `features/pregnancy/`\*\*

# 

# \- `data/`

# &nbsp; - `datasources/` → local or remote data access

# &nbsp; - `models/` → DTOs for the feature

# &nbsp; - `pregnancy\_repository\_impl.dart` → concrete repo implementation

# 

# \- `domain/`

# &nbsp; - `entities/` → pure Dart models (e.g., `Pregnancy`, `Week`)

# &nbsp; - `repositories/` → abstract repository interfaces

# &nbsp; - `usecases/` → single-responsibility classes (e.g., `CalculatePregnancyWeekUseCase`)

# 

# \- `presentation/`

# &nbsp; - `pages/` → screens (e.g., `week\_tracker\_page.dart`)

# &nbsp; - `widgets/` → UI components specific to pregnancy

# &nbsp; - `providers/` → Riverpod providers (e.g., `pregnancy\_provider.dart`)

# 

# \*\*Tip:\*\* Follow this pattern for every feature.

# 

# ---

# 

# \### `l10n/` — Localization

# 

# \- `app\_en.arb` → English translations

# \- `app\_fr.arb` → French translations

# \- `app\_ar.arb` → Arabic translations

# \- Generated files (auto-created by `flutter gen-l10n`)

# 

# ---

# 

# \### `assets/`

# 

# Fonts, icons, images. Update `pubspec.yaml` to include assets.

# 

# ---

# 

# \## 📂 Complete Folder Tree

# 

# ```

# pregnancy\_baby\_app/

# ├── pubspec.yaml

# ├── README.md

# ├── CONTRIBUTING.md

# ├── analysis\_options.yaml

# ├── l10n.yaml

# ├── .gitignore

# │

# ├── lib/

# │ ├── main.dart

# │ ├── app.dart

# │ ├── routes.dart

# │ │

# │ ├── core/

# │ │ ├── constants/

# │ │ │ ├── app\_colors.dart

# │ │ │ ├── app\_text\_styles.dart

# │ │ │ └── app\_routes.dart

# │ │ ├── theme/

# │ │ │ └── app\_theme.dart

# │ │ ├── widgets/

# │ │ │ ├── custom\_button.dart

# │ │ │ ├── custom\_text\_field.dart

# │ │ │ └── app\_dialog.dart

# │ │ ├── providers/

# │ │ │ ├── user\_mode\_provider.dart

# │ │ │ ├── current\_user\_provider.dart

# │ │ │ └── locale\_provider.dart

# │ │ ├── services/

# │ │ │ ├── database/

# │ │ │ │ └── database\_service.dart

# │ │ │ ├── api\_service.dart

# │ │ │ ├── notification\_service.dart

# │ │ │ ├── local\_storage\_service.dart

# │ │ │ └── auth\_service.dart

# │ │ ├── utils/

# │ │ │ ├── date\_utils.dart

# │ │ │ ├── validators.dart

# │ │ │ ├── formatters.dart

# │ │ │ └── extensions.dart

# │ │ └── exceptions/

# │ │ └── app\_exceptions.dart

# │ │

# │ ├── features/

# │ │ ├── auth/

# │ │ │ ├── data/

# │ │ │ │ ├── datasources/

# │ │ │ │ └── models/

# │ │ │ ├── domain/

# │ │ │ │ ├── entities/

# │ │ │ │ ├── repositories/

# │ │ │ │ └── usecases/

# │ │ │ └── presentation/

# │ │ │ ├── pages/

# │ │ │ ├── widgets/

# │ │ │ └── providers/

# │ │ │

# │ │ ├── onboarding/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ ├── dashboard/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ ├── pregnancy/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ ├── baby/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ ├── health\_log/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ ├── health\_analysis/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ ├── plan/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ ├── education/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ ├── doctors/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ ├── marketplace/

# │ │ │ ├── data/

# │ │ │ ├── domain/

# │ │ │ └── presentation/

# │ │ │

# │ │ └── profile/

# │ │ ├── data/

# │ │ ├── domain/

# │ │ └── presentation/

# │ │

# │ └── l10n/

# │ ├── app\_en.arb

# │ ├── app\_fr.arb

# │ ├── app\_ar.arb

# │ └── app\_localizations.dart

# │

# ├── assets/

# │ ├── images/

# │ ├── fonts/

# │ └── lottie/

# │

# ├── test/

# │ ├── unit/

# │ ├── widget/

# │ └── integration/

# │

# └── docs/

# ```

# 

# ---

# 

# \## 🏗️ Architecture: Clean Architecture + Riverpod

# 

# \### Three Layers

# 

# 1\. \*\*Presentation Layer\*\* (`features/\*/presentation/`)

# &nbsp;  - UI, pages, widgets, Riverpod providers

# &nbsp;  - Only displays data and captures user input

# 

# 2\. \*\*Domain Layer\*\* (`features/\*/domain/`)

# &nbsp;  - Business logic, entities, repository interfaces, usecases

# &nbsp;  - No Flutter or database knowledge

# 

# 3\. \*\*Data Layer\*\* (`features/\*/data/`)

# &nbsp;  - Database access, API calls, DTOs

# &nbsp;  - Repository implementations

# 

# \### Data Flow

# 

# ```

# UI (Button Click)

# &nbsp;   ↓

# Riverpod Provider (Presentation)

# &nbsp;   ↓

# UseCase (Domain)

# &nbsp;   ↓

# Repository Implementation (Data)

# &nbsp;   ↓

# DataSource (SQLite/API)

# &nbsp;   ↓

# Return Data → Convert to Entity → Update UI

# ```

# 

# ---

# 

# \## 🌿 Branch Workflow

# 

# \### Branch Naming

# 

# ```

# main              # Production-ready code

# develop           # Staging/integration branch

# feature/...       # New features (e.g., feature/pregnancy-tracker)

# fix/...           # Bug fixes (e.g., fix/login-crash)

# docs/...          # Documentation (e.g., docs/update-readme)

# ```

# 

# \### Workflow Steps

# 

# 1\. \*\*Create feature branch:\*\*

# &nbsp;  ```bash

# &nbsp;  git checkout develop

# &nbsp;  git pull origin develop

# &nbsp;  git checkout -b feature/your-feature-name

# &nbsp;  ```

# 

# 2\. \*\*Make changes and commit:\*\*

# &nbsp;  ```bash

# &nbsp;  git add .

# &nbsp;  git commit -m "\[FEATURE] Add pregnancy week calculator"

# &nbsp;  ```

# 

# 3\. \*\*Push to GitHub:\*\*

# &nbsp;  ```bash

# &nbsp;  git push origin feature/your-feature-name

# &nbsp;  ```

# 

# 4\. \*\*Create Pull Request:\*\*

# &nbsp;  - Go to GitHub → Pull Requests → New PR

# &nbsp;  - Set base to `develop`, compare to your feature branch

# &nbsp;  - Add description and request reviewers

# 

# 5\. \*\*After approval, merge on GitHub\*\*

# 

# 6\. \*\*Delete branch:\*\*

# &nbsp;  ```bash

# &nbsp;  git branch -d feature/your-feature-name

# &nbsp;  git push origin --delete feature/your-feature-name

# &nbsp;  ```

# 

# ---

# 

# \## 📝 Development Guidelines

# 

# \### Naming Conventions

# 

# \- `camelCase` for variables, functions, properties

# \- `PascalCase` for classes and enums

# \- `snake\_case` for file names and directories

# 

# \### PR Checklist

# 

# \- \[ ] Code compiles without errors (`flutter analyze` passes)

# \- \[ ] No hardcoded values (use constants)

# \- \[ ] No debug prints

# \- \[ ] Commit messages are clear

# \- \[ ] Documentation updated if needed

# 

# ---

# 

# 

# 

# \## 🛠️ Common Commands

# 

# ```bash

# \# Clone repo

# git clone https://github.com/your-username/pregnancy-baby-app.git

# 

# \# Install dependencies

# flutter pub get

# 

# \# Generate localization files

# flutter gen-l10n

# 

# \# Analyze code

# flutter analyze

# 

# \# Run app

# flutter run

# 

# \# Create feature branch

# git checkout -b feature/your-feature

# 

# \# Commit and push

# git add .

# git commit -m "\[FEATURE] Your description"

# git push origin feature/your-feature

# ```

# 

# ---

# 

# \*\*Last Updated:\*\* October 2025

