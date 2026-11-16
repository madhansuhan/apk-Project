# Sankar Connect — Industrial Sealing Systems & Components Mobile Application

> **Candidate Submission:** Flutter Developer Internship Assignment  
> **Company:** Sankar Group (Sankar Sealing Systems Pvt. Ltd.)  
> **Role:** Flutter Developer Intern  
> **Evaluation Window:** 48 Hours  
> **Tech Stack:** Flutter 3.x, Dart 3.x, Provider State Management, SharedPreferences, HTTP Client, Material 3 Design

---

## 📌 Executive Summary & Brand Choice

For this assignment, the application was developed specifically around **Sankar Group's premier automotive and industrial brand**: **Sankar Sealing Systems Pvt. Ltd.** (Tier-1 OEM supplier of Multi-Layer Steel cylinder head gaskets, thermal heat shields, NVH dampers, and specialty elastomers based in Chennai).

The application, titled **Sankar Connect**, serves as an enterprise-grade mobile catalog, technical specification explorer, and RFQ (Request For Quotation) procurement platform. It demonstrates all 5 required tasks with complete functionality, input validations, persistent local caching, responsive design, dark/light theme switching, and seamless REST API integration with offline resilience.

---

## 🏗️ Architecture & Engineering Design

The project strictly follows **Clean Architecture & MVVM (Model-View-ViewModel/Provider)** principles to ensure separation of concerns, testability, and modularity.

```
                           ┌──────────────────────────┐
                           │      UI Layer (Views)    │
                           │  Screens & Custom Widgets│
                           └─────────────┬────────────┘
                                         │ Consumes (Consumer/Selector)
                                         ▼
                           ┌──────────────────────────┐
                           │ State Management Layer   │
                           │  (Providers via ChangeNotifier) │
                           │  - AuthProvider          │
                           │  - ProductProvider       │
                           │  - CartProvider          │
                           │  - ThemeProvider         │
                           └─────────────┬────────────┘
                                         │ Calls
                                         ▼
                           ┌──────────────────────────┐
                           │      Service Layer       │
                           │  - ApiService (HTTP Client)
                           │  - StorageService (Prefs)│
                           │  - AuthService           │
                           └─────────────┬────────────┘
                                         │ Interacts with
                                         ▼
                 ┌───────────────────────┴───────────────────────┐
                 │                                               │
                 ▼                                               ▼
    ┌──────────────────────────┐                   ┌──────────────────────────┐
    │ Public REST API / Remote │                   │ Persistent Local Storage │
    │ DummyJSON / Sankar Cloud │                   │   SharedPreferences      │
    └──────────────────────────┘                   └──────────────────────────┘
```

### Logical Directory Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart         # Sankar Group corporate color palette
│   │   ├── app_constants.dart      # Storage keys, metadata & certifications
│   │   ├── app_theme.dart          # Material 3 Light & Dark themes
│   │   └── api_endpoints.dart      # Remote REST endpoints & timeouts
│   ├── routes/
│   │   └── app_routes.dart         # Centralized onGenerateRoute definitions
│   └── utils/
│       └── validators.dart         # Regex email, password, phone, name validators
├── models/
│   ├── user_model.dart             # Strongly typed user profile model
│   ├── category_model.dart         # Product category classification
│   ├── product_model.dart          # Industrial component with SKU & specs
│   └── cart_item_model.dart        # RFQ basket item with calculations
├── services/
│   ├── api_service.dart            # REST API client with offline fallback
│   ├── storage_service.dart        # SharedPreferences persistence layer
│   └── auth_service.dart           # Authentication & session coordinator
├── providers/
│   ├── theme_provider.dart         # Responsive Dark/Light mode state
│   ├── auth_provider.dart          # Login/Signup/Logout & session state
│   ├── product_provider.dart       # Search, filtering, sorting, favorites
│   └── cart_provider.dart          # RFQ quote calculation & persistence
├── screens/
│   ├── splash_screen.dart          # Animated branding & session router
│   ├── main_navigation_screen.dart # 4-tab bottom navigation shell
│   ├── auth/
│   │   ├── login_screen.dart       # Form validation, autofill demo, remember me
│   │   └── signup_screen.dart      # Registration with comprehensive checks
│   ├── home/
│   │   └── home_screen.dart        # KPI dashboard, categories, featured parts
│   ├── products/
│   │   ├── product_list_screen.dart # Search, category chips, sort, grid/list
│   │   └── product_detail_screen.dart # Specs table, gallery, TDS download
│   ├── cart/
│   │   └── cart_screen.dart        # RFQ quotation builder & modal submission
│   └── profile/
│       └── profile_screen.dart     # User profile, theme toggle, corporate info
├── widgets/
│   ├── custom_button.dart          # Reusable button with loading & outline
│   ├── custom_text_field.dart      # Reusable form field with eye toggle
│   ├── product_card.dart           # Industrial item card with instant favorite
│   ├── category_chip.dart          # Interactive category pills
│   ├── loading_shimmer.dart        # Skeleton shimmer placeholders
│   ├── empty_state_view.dart       # Empty result view with action buttons
│   └── error_state_view.dart       # Network failure view with retry
└── main.dart                       # App entry point with MultiProvider setup
```

---

## 📱 Detailed Screen Walkthrough (Task 2 & 3)

### 1. Splash Screen (`splash_screen.dart`)
* **Branding:** Elegant Sankar Group emblem with dual-color gradient and smooth scale/fade animations.
* **Auto-Routing:** Asynchronously queries `StorageService` for active session tokens:
  * Routes directly to `MainNavigationScreen` if user is remembered.
  * Routes to `LoginScreen` if no valid session is present.

### 2. Authentication Screens (`login_screen.dart` & `signup_screen.dart`)
* **Form Validation:**
  * Strict regex validation for enterprise email formats.
  * Password minimum length validation.
  * Phone number validation (10–14 digits).
  * Password matching confirmation on registration.
* **Interactive Elements:**
  * Password visibility toggle (eye icon).
  * One-tap **"Auto-fill Demo Credentials"** button for quick evaluator login (`procurement@sankargroup.com` / `sankar2026`).
  * "Remember Me" checkbox persisted in SharedPreferences.
  * Forgot password modal with email dispatch simulation.
  * Terms & Conditions agreement validation checkbox.

### 3. Home / Dashboard Screen (`home_screen.dart`)
* **User Greeting:** Displays authenticated user's name and company role.
* **Quick Search Bar:** Instant trigger that routes into the catalog search.
* **KPI Metrics Row:** Real-time counters showing total components available, user saved favorites count, and active RFQ quote items.
* **OEM Highlight Card:** Highlights Sankar Group's IATF 16949 / ISO 14001:2015 Tier-1 OEM certifications.
* **Category Carousel:** Horizontally scrolling cards representing core product lines (MLS Gaskets, Thermal Shields, NVH Shims, Specialty Elastomers).
* **Featured Components:** High-priority automotive parts with quick navigation to full details.

### 4. Listing / Catalog Screen (`product_list_screen.dart`)
* **Real-Time Search:** Live filtering across title, SKU number, category, and engineering material grades.
* **Category Chips:** Instant filtering (All, MLS Cylinder Gaskets, Thermal Shields, NVH Shims, Specialty Elastomers, Exhaust Seals).
* **Sort Modal:** Bottom sheet with 5 sorting options (Relevance, Price Low→High, Price High→Low, Rating, Name A→Z).
* **View Modes:** One-tap toggle between 2-column Grid View and detailed List View.
* **State Feedback:**
  * Pull-to-refresh integration.
  * Skeleton shimmer loader while data is being fetched.
  * Error state with "Retry" action.
  * Empty state with "Reset Filters" action when no items match.

### 5. Details Screen (`product_detail_screen.dart`)
* **Media Header:** Hero image banner with horizontal gallery thumbnail switcher.
* **Component Identifiers:** SKU chip (`SG-CHG-9840`), OEM Grade badge, stock location.
* **Pricing & MOQ:** Transparent unit price in INR (₹) and Minimum Order Quantity (MOQ).
* **Technical Specifications Table:** Material grade, continuous operating temperature, nominal thickness, bore size, and quality certifications.
* **OEM Compatibility:** Compatible vehicle badges (Hyundai, Tata Motors, Mahindra, Ashok Leyland).
* **Interactive Actions:**
  * Quantity stepper (+ / - buttons respecting MOQ).
  * "View Technical Data Sheet (TDS)" modal dialog with PDF download simulation.
  * One-tap Favorite toggle with immediate snackbar feedback.
  * "Add to RFQ Quote" with custom quantity dispatch.

### 6. RFQ / Cart Screen (`cart_screen.dart`)
* **Quotation Management:** Lists all items selected for inquiry with unit pricing, subtotal, and quantity adjustment.
* **Tax Calculations:** Automatic 18% GST breakdown and total estimation.
* **Formal RFQ Submission Modal:** Bottom sheet form capturing delivery plant location, PO reference, and engineering notes with input validation.
* **Submission Confirmation:** Generates a unique tracking reference (e.g. `RFQ-SG-893041`) and clears the local basket.

### 7. Profile & Settings Screen (`profile_screen.dart`)
* **User Information:** Displays registered user profile and partner company details.
* **Dark Mode Switch:** Instant UI toggle between Light and Dark themes, persisted across app restarts in SharedPreferences.
* **Corporate Profile:** Explains Sankar Group manufacturing operations and quality compliance.
* **Sync Button:** Refreshes and synchronizes local cache with live remote REST API.
* **Logout Dialog:** Secure session teardown with confirmation.

---

## 🌐 API & Data Integration (Task 4 & 5)

### REST API Architecture (`api_service.dart`)
The application implements a resilient, multi-tiered data strategy:
1. **Live Remote Public API:** Queries public REST endpoints (`https://dummyjson.com/products`) using the standard Dart `http` package with HTTP timeouts and error status handling.
2. **Enterprise Repository:** Seamlessly combines live remote records with authentic, high-fidelity Sankar Sealing Systems product models (featuring high-boost MLS gaskets, exhaust heat shields, NVH brake shims, and FKM fluoroelastomers).
3. **Offline Resilience:** If network connectivity drops or the public API is unreachable, the service gracefully falls back to structured local product repositories without crashing or displaying blank screens.

### Data Persistence (`storage_service.dart`)
Using `shared_preferences`, the application stores:
* `user_auth_token` & `user_data_profile`: Keeps user logged in across application cold restarts.
* `remember_me_state` & `saved_user_email`: Remembers email address on the login form.
* `saved_favorite_product_ids`: Persistent list of bookmarked products.
* `local_cart_items_data`: Serialized JSON array of RFQ quote items and quantities.
* `is_dark_mode_active`: Theme preference retained across sessions.

---

## 📦 Packages & Dependencies Used

| Package | Version | Purpose & Rationale |
|---|---|---|
| `provider` | `^6.1.2` | Clean, lightweight, official state management recommended by the Flutter team. |
| `shared_preferences` | `^2.2.2` | Key-value persistent local storage for auth session, cart, favorites, and theme. |
| `http` | `^1.2.0` | Standard HTTP client for REST API requests with timeout and status code handling. |
| `google_fonts` | `^6.1.0` | Professional typography (Inter font family) for modern industrial aesthetics. |
| `shimmer` | `^3.0.0` | Skeleton loading effects for smooth asynchronous UX. |
| `cached_network_image` | `^3.3.1` | Efficient image caching and placeholder rendering. |
| `cupertino_icons` | `^1.0.6` | Supporting icon set. |
| `flutter_lints` | `^3.0.0` | Code quality and static analysis enforcement. |

---

## 🚀 How to Run the Application

### Prerequisites
* Flutter SDK (Version 3.10.0 or higher)
* Dart SDK (Version 3.0.0 or higher)
* Android Studio / VS Code with Flutter extension
* Android Emulator or physical Android device (Android 5.0+ / API 21+)

### Step-by-Step Instructions

1. **Clone or Navigate to the Project:**
   ```bash
   cd c:\Users\iampa\Desktop\Projects\Flutter
   ```

2. **Fetch Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run Automated Unit Tests:**
   ```bash
   flutter test
   ```

4. **Launch Application in Debug Mode:**
   ```bash
   flutter run
   ```

5. **Build Android Release APK:**
   ```bash
   flutter build apk --release
   ```
   
   > 📦 **Pre-built APK Ready for Submission:**
   > * Primary: `c:\Users\iampa\Desktop\Projects\Flutter\release\sankar_connect.apk`
   > * Gradle Output: `c:\Users\iampa\Desktop\Projects\Flutter\build\app\outputs\flutter-apk\app-release.apk`

---

## 🧪 Testing & Code Quality

The project includes an automated test suite in `test/unit_test.dart` verifying:
* Regex email format validation.
* Password length and matching validation.
* Full name and telephone format checks.
* JSON serialization and deserialization of `ProductModel`.
* Mathematical price and quantity calculations within `CartItemModel`.

Run tests via:
```bash
flutter test
```

---

## 📊 Alignment with Assignment Evaluation Criteria

| Evaluation Area | Weight | How It Was Addressed in Sankar Connect |
|---|---|---|
| **UI Design and Responsiveness** | **20%** | Designed with Sankar Group corporate palette (Industrial Navy & Precision Cyan), responsive cards, Material 3 specifications, full Light and Dark theme modes, and smooth animations. |
| **Flutter and Dart Code Quality** | **20%** | 100% null-safe Dart, `prefer_const_constructors` compliance, clean models, reusable widgets, error boundaries, and unit test suite. |
| **Functionality and Navigation** | **20%** | Centralized `AppRoutes`, 4 core screens plus Splash, RFQ, and Profile screens, live search, multi-category chips, 5-criteria sorting, favorites toggle, and stepper controls. |
| **API and Data Integration** | **20%** | Live REST API communication with timeout handling, offline-first fallback, SharedPreferences session management, persisted favorites, and quotation state. |
| **Code Organization and Demonstration** | **20%** | Modular Clean Architecture (`core/`, `models/`, `services/`, `providers/`, `screens/`, `widgets/`), comprehensive documentation, and submission-ready code. |

---
*Created for the Sankar Group Flutter Developer Internship Assignment.*
