# Bihar Tourism - Flutter App

A production-ready Flutter mobile app for Bihar Tourism Experiences Marketplace.

## Features

### Tourist App
- 🔐 Onboarding with phone/email login
- 🏠 Home screen with categories (Spiritual, Heritage, Food, Nature)
- 🔍 Experience listing with search & filters
- 📱 Experience detail page with guide info
- 📅 Booking flow with date selection and payment
- ❤️ Wishlist functionality
- ⭐ Reviews & ratings

### Admin Panel
- ➕ Add/edit/delete experiences
- 👤 Manage guides
- 📊 View bookings and analytics

### Guide Dashboard
- 👤 Guide profile management
- ✅ Accept/reject bookings
- 📅 View upcoming tours

## Tech Stack

- **Flutter** (Android + iOS)
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Payments**: Razorpay
- **Maps**: Google Maps
- **Local Storage**: Hive

## Project Structure

```
lib/
├── core/
│   ├── constants/       # App constants and config
│   ├── router/          # GoRouter configuration
│   ├── theme/           # Colors, typography, theme
│   ├── utils/           # Utility functions
│   └── widgets/         # Reusable widgets
├── features/
│   ├── auth/            # Authentication screens
│   ├── home/            # Home and navigation
│   ├── experiences/     # Experience listing & details
│   ├── booking/         # Booking flow
│   ├── profile/         # User profile, wishlist, settings
│   ├── admin/           # Admin dashboard
│   └── guide/           # Guide dashboard
└── shared/
    ├── models/          # Data models
    ├── providers/       # Riverpod providers
    ├── repositories/    # Data repositories
    └── services/        # External services
```

## Setup Instructions

### Prerequisites
- Flutter SDK 3.9+
- Firebase account
- Razorpay account (for payments)
- Google Cloud account (for Maps)

### 1. Clone and Install Dependencies

```bash
cd btour
flutter pub get
```

### 2. Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Enable Authentication (Email/Password and Google Sign-In)
3. Create a Firestore database
4. Enable Firebase Storage
5. Download configuration files:
   - Android: `google-services.json` → `android/app/`
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`

Or use FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 3. Google Maps Setup

1. Enable Maps SDK for Android and iOS in Google Cloud Console
2. Add API key to:
   - Android: `android/app/src/main/AndroidManifest.xml`
   - iOS: `ios/Runner/AppDelegate.swift`

### 4. Razorpay Setup

1. Create a Razorpay account
2. Get your API keys
3. Update `lib/core/constants/app_constants.dart` with your key

### 5. Add Fonts

Download and add these fonts to `assets/fonts/`:
- Poppins (Light, Regular, Medium, SemiBold, Bold)
- Playfair Display (Regular, Bold)

### 6. Run the App

```bash
flutter run
```

## Firebase Security Rules

Add these rules to your Firestore:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /experiences/{experienceId} {
      allow read: if true;
      allow write: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    match /bookings/{bookingId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth != null;
    }
    match /reviews/{reviewId} {
      allow read: if true;
      allow create: if request.auth != null;
    }
    match /guides/{guideId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

## Screenshots

The app features a Bihar cultural theme with:
- Earthy colors inspired by Madhubani art
- Deep saffron and royal blue primary colors
- Modern travel app UI like Airbnb Experiences

## License

This project is for Bihar Tourism promotion.
