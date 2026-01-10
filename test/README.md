### Unit Tests

#### Models (test/unit/models/)

- **PregnancyModel**: Tests data serialization, edge cases, and data integrity

  - toMap/fromMap conversion
  - Active/inactive state handling
  - Date handling and edge cases
  - Reversibility of conversions

- **BabyModel**: Tests baby data management

  - Complete and minimal field scenarios
  - Optional field handling
  - Measurement edge cases (low/high birth weights)
  - Gender and theme color handling

- **CartItemModel**: Tests shopping cart functionality
  - Price calculations (integer to double conversion)
  - Quantity management
  - Variant handling (color, size)
  - copyWith method functionality

#### Services (test/unit/services/)

- **ConnectivityService**: Network connectivity monitoring

  - Connection type validation (WiFi, Mobile, Ethernet)
  - Connection state changes
  - Error handling
  - Stream management

- **NotificationService**: Local notification management

  - Notification initialization
  - Medicine reminders
  - Appointment reminders
  - Channel configuration
  - Error handling and permissions

- **OcrService**: OCR and text recognition
  - Text extraction from images
  - Lab result parsing with bounding boxes
  - Row clustering by Y-coordinate
  - Header filtering
  - Value interpretation (normal/high/low)
  - Scientific notation handling

#### BLoCs (test/unit/blocs/)

- **AuthBloc**: Authentication state management

  - App startup (session restoration)
  - Sign up flow (success and failure cases)
  - Login flow (valid/invalid credentials)
  - Logout flow
  - Profile update (success and rollback on failure)
  - Edge cases (empty inputs, rapid events)

- **MarketplaceBloc**: Marketplace state management
  - Product loading
  - Search functionality (case-insensitive, description search)
  - Category filtering
  - Combined filters (category + search)
  - State management with copyWith
  - Error handling

#### API (test/unit/api/)

- **ProductApiService**: HTTP API interactions
  - Product fetching with filters
  - Single product retrieval
  - Category fetching
  - Query parameter construction
  - Error handling (404, 500, network errors)
  - Data parsing (images, prices, availability)

### Integration Tests

#### Auth Flow Integration (test/integration/auth_flow_integration_test.dart)

- Complete signup flow
- Duplicate email prevention
- Password validation
- Login with valid/invalid credentials
- Logout flow
- Profile update flow
- App startup with/without session
- Sequential authentication operations
- Error recovery and state restoration

#### Marketplace Flow Integration (test/integration/marketplace_flow_integration_test.dart)

- Product search (name, description, case-insensitive)
- Category filtering
- Combined filters (category + search + price)
- Availability filtering
- Product sorting (price, rating, reviews)
- Discount calculations
- Price range filtering
- Pagination
- Popular products and best deals

## Key Testing Patterns

### 1. Mocking External Dependencies

All external dependencies (database, HTTP, notifications) are mocked using Mockito:

```dart
@GenerateMocks([AuthRepository])
import 'auth_bloc_test.mocks.dart';
```

### 2. BLoC Testing with bloc_test

State transitions are verified using the bloc_test package:

```dart
blocTest<AuthBloc, AuthState>(
  'emits [AuthLoading, AuthAuthenticated] when login succeeds',
  build: () => authBloc,
  act: (bloc) => bloc.add(LoginRequested(...)),
  expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
);
```

### 3. Integration Testing with Real Components

Integration tests use real implementations where appropriate:

```dart
IntegrationTestWidgetsFlutterBinding.ensureInitialized();
```

### 4. Comprehensive Edge Case Coverage

All tests include edge cases:

- Empty/null values
- Very large values
- Special characters
- Boundary conditions
- Error scenarios

`

## Generating Mocks

Before running tests, generate mocks for annotated classes:

```bash
flutter pub run build_runner build
```

Or watch for changes:

```bash
flutter pub run build_runner watch
```
