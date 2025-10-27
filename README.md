# 🤰👶 Pregnancy & Baby App — Flutter Mobile

**One-line:** Mobile app to manage pregnancy tracking, baby care, health logs, appointments, marketplace, and community support.  
**Tech:** Flutter (mobile), Clean Architecture, Riverpod.

> This README explains the repository structure, what each folder is, how to run the app, and coding/branch rules.

---

## 📁 Repo Structure (Brief)

```text
lib/
├── core/                 # shared utilities, widgets, theme, services
├── features/             # features (auth, pregnancy, baby, health_log, etc.)
├── l10n/                 # localization (EN, FR, AR)
├── app.dart              # app config (MaterialApp, theme, routes)
├── routes.dart           # defines the app routes
└── main.dart             # app entry point
```

---

## 🧭 Full Explanation (What to Put Where)

### `main.dart`

App entry. Minimal code: init services and `runApp(MyApp())`.

### `app.dart` & `routes.dart`

Configure `MaterialApp`, theme, and named routes. Central place to change global settings.

---

### `core/` — Shared Tools (Used Across Features)

- `core/constants/` → colors, text styles, route names, string constants.
  - `app_colors.dart`, `app_text_styles.dart`, `app_routes.dart`
- `core/theme/` → `app_theme.dart` where the ThemeData lives.
- `core/widgets/` → reusable UI widgets used across many screens (buttons, dialogs).
- `core/providers/` → cross-feature providers (`user_mode_provider.dart`, `locale_provider.dart`).
- `core/services/` → global services (database, API, notifications, local storage).
- `core/utils/` → validators, formatters, extensions, date utilities.
- `core/exceptions/` → central exception types.

**Tip:** Put UI components used more than once in `core/widgets/`. If it's specific to a feature, put it under `features/<feature-name>/presentation/widgets/`.

---

### `features/<feature>/` — Feature Module

Each feature follows the same internal pattern: `data/`, `domain/`, `presentation/`.

**Example: `features/pregnancy/`**

- `data/`
  - `datasources/` → local or remote data access
  - `models/` → DTOs for the feature
  - `pregnancy_repository_impl.dart` → concrete repo implementation

- `domain/`
  - `entities/` → pure Dart models (e.g., `Pregnancy`, `Week`)
  - `repositories/` → abstract repository interfaces
  - `usecases/` → single-responsibility classes (e.g., `CalculatePregnancyWeekUseCase`)

- `presentation/`
  - `pages/` → screens (e.g., `week_tracker_page.dart`)
  - `widgets/` → UI components specific to pregnancy
  - `providers/` → Riverpod providers (e.g., `pregnancy_provider.dart`)

**Tip:** Follow this pattern for every feature.

---

### `l10n/` — Localization

- `app_en.arb` → English translations
- `app_fr.arb` → French translations
- `app_ar.arb` → Arabic translations
- Generated files (auto-created by `flutter gen-l10n`)

---

### `assets/`

Fonts, icons, images. Update `pubspec.yaml` to include assets.

---

## 📂 Complete Folder Tree

```
pregnancy_baby_app/
├── pubspec.yaml                    # Dependencies
├── README.md                       # This file
├── CONTRIBUTING.md                 # Git workflow & guidelines
├── analysis_options.yaml           # Dart linter rules
├── l10n.yaml                       # Localization config
├── .gitignore                      # Git ignore rules
│
├── lib/
│ ├── main.dart                     # App entry point
│ ├── app.dart                      # MaterialApp config
│ ├── routes.dart                   # Named routes
│ │
│ ├── core/                         # Shared utilities
│ │ ├── constants/
│ │ │ ├── app_colors.dart
│ │ │ ├── app_text_styles.dart
│ │ │ └── app_routes.dart
│ │ ├── theme/
│ │ │ └── app_theme.dart
│ │ ├── widgets/                   # Reusable UI components
│ │ │ ├── custom_button.dart
│ │ │ ├── custom_text_field.dart
│ │ │ └── app_dialog.dart
│ │ ├── providers/                 # Cross-feature providers
│ │ │ ├── user_mode_provider.dart
│ │ │ ├── current_user_provider.dart
│ │ │ └── locale_provider.dart
│ │ ├── services/                  # Global services
│ │ │ ├── database/
│ │ │ │ └── database_service.dart
│ │ │ ├── api_service.dart
│ │ │ ├── notification_service.dart
│ │ │ ├── local_storage_service.dart
│ │ │ └── auth_service.dart
│ │ ├── utils/                     # Helper functions
│ │ │ ├── date_utils.dart
│ │ │ ├── validators.dart
│ │ │ ├── formatters.dart
│ │ │ └── extensions.dart
│ │ └── exceptions/
│ │ └── app_exceptions.dart
│ │
│ ├── features/                    # 12 Independent Features
│ │ ├── auth/                      # Login, signup
│ │ │ ├── data/
│ │ │ │ ├── datasources/
│ │ │ │ └── models/
│ │ │ ├── domain/
│ │ │ │ ├── entities/
│ │ │ │ ├── repositories/
│ │ │ │ └── usecases/
│ │ │ └── presentation/
│ │ │ ├── pages/
│ │ │ ├── widgets/
│ │ │ └── providers/
│ │ │
│ │ ├── onboarding/                # Mode selection, forms
│ │ ├── dashboard/                 # Home screen
│ │ ├── pregnancy/                 # Pregnancy tracking
│ │ ├── baby/                      # Baby profile & tracking
│ │ ├── health_log/                # Vitals, symptoms, mood
│ │ ├── health_analysis/           # Risk detection, OCR
│ │ ├── plan/                      # Calendar, appointments
│ │ ├── education/                 # Articles, videos, tips
│ │ ├── doctors/                   # Find doctors, book
│ │ ├── marketplace/               # Products, cart
│ │ └── profile/                   # Settings, history
│ │ (Each feature has data/domain/presentation structure)
│ │
│ └── l10n/                        # Localization files
│ ├── app_en.arb                  # English
│ ├── app_fr.arb                  # French
│ ├── app_ar.arb                  # Arabic
│ └── app_localizations.dart      # Generated file
│
├── assets/
│ ├── images/
│ ├── fonts/
│ └── lottie/
│
├── test/                          # Tests
│ ├── unit/
│ ├── widget/
│ └── integration/
│
└── docs/                          # Documentation
```

---

## 🏗️ Architecture: Clean Architecture + Riverpod

### Three Layers

1. **Presentation Layer** (`features/*/presentation/`)
   - UI, pages, widgets, Riverpod providers
   - Only displays data and captures user input

2. **Domain Layer** (`features/*/domain/`)
   - Business logic, entities, repository interfaces, usecases
   - No Flutter or database knowledge

3. **Data Layer** (`features/*/data/`)
   - Database access, API calls, DTOs
   - Repository implementations

### Data Flow

```
UI (Button Click)
    ↓
Riverpod Provider (Presentation)
    ↓
UseCase (Domain)
    ↓
Repository Implementation (Data)
    ↓
DataSource (SQLite/API)
    ↓
Return Data → Convert to Entity → Update UI
```

---

## 🌿 Branch Workflow

### Branch Naming

```
main              # Production-ready code
develop           # Staging/integration branch
feature/...       # New features (e.g., feature/pregnancy-tracker)
fix/...           # Bug fixes (e.g., fix/login-crash)
docs/...          # Documentation (e.g., docs/update-readme)
```

### Workflow Steps

1. **Create feature branch:**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/your-feature-name
   ```

2. **Make changes and commit:**
   ```bash
   git add .
   git commit -m "[FEATURE] Add pregnancy week calculator"
   ```

3. **Push to GitHub:**
   ```bash
   git push origin feature/your-feature-name
   ```

4. **Create Pull Request:**
   - Go to GitHub → Pull Requests → New PR
   - Set base to `develop`, compare to your feature branch
   - Add description and request reviewers

5. **After approval, merge on GitHub**

6. **Delete branch:**
   ```bash
   git branch -d feature/your-feature-name
   git push origin --delete feature/your-feature-name
   ```

---

## 📝 Development Guidelines

### Naming Conventions

- `camelCase` for variables, functions, properties
- `PascalCase` for classes and enums
- `snake_case` for file names and directories

### PR Checklist

- [ ] Code compiles without errors (`flutter analyze` passes)
- [ ] No hardcoded values (use constants)
- [ ] No debug prints
- [ ] Commit messages are clear
- [ ] Documentation updated if needed

---



## 🛠️ Common Commands

```bash
# Clone repo
git clone https://github.com/your-username/pregnancy-baby-app.git

# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Analyze code
flutter analyze

# Run app
flutter run

# Create feature branch
git checkout -b feature/your-feature

# Commit and push
git add .
git commit -m "[FEATURE] Your description"
git push origin feature/your-feature
```

---

**Last Updated:** October 2025
