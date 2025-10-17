# Eco-Trail 🌱

A cross-platform Flutter mobile application that promotes sustainable tourism by connecting eco-conscious travelers with verified eco-friendly experiences, local businesses, and cultural sites.

## Features

- 🗺️ **Interactive Eco Map** - Display eco-certified accommodations, nature trails, cultural sites, and local farms using Google Maps
- 📅 **Local Events Calendar** - Showcase sustainability-related workshops, cultural festivals, and green events
- 📱 **Booking System** - Allow users to book eco-lodges, guided tours, and transport with integrated payment support
- 🌍 **Sustainability Tips & Carbon Tracker** - Provide personalized sustainability advice and track carbon footprint
- ⭐ **Reviews & Recommendations** - Enable travelers to share experiences focused on ethical travel
- 📱 **Offline Navigation** - Support GPS-based map and content caching for offline exploration
- 🌐 **Multilingual & Accessible** - Include multilingual support, offline mode, and clean, minimalistic UI

## Tech Stack

- **Framework**: Flutter (cross-platform for Android & iOS)
- **Backend**: Firebase (Firestore, Auth, Storage)
- **Maps**: Google Maps API
- **State Management**: Riverpod
- **Local Storage**: Hive
- **Payment**: Stripe
- **UI**: Material Design 3 with earth-tone colors

## Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd eco_trail
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication, Firestore, and Storage
   - Download the configuration files:
     - `google-services.json` for Android (place in `android/app/`)
     - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)
   - Update `lib/firebase_options.dart` with your Firebase configuration

4. **Google Maps Setup**
   - Get a Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
   - Update `lib/core/constants/app_constants.dart` with your API key
   - Enable the following APIs:
     - Maps SDK for Android
     - Maps SDK for iOS
     - Places API
     - Geocoding API

5. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── services/           # Firebase and other services
│   ├── theme/              # App theme and colors
│   └── utils/              # Utility functions
├── features/
│   ├── map/                # Interactive eco map feature
│   ├── events/             # Events calendar feature
│   ├── bookings/           # Booking system
│   ├── profile/            # User profile and settings
│   └── tips/               # Sustainability tips and carbon tracker
├── models/                 # Data models
├── widgets/                # Reusable widgets
└── main.dart              # App entry point
```

## Configuration

### Environment Variables

Create a `.env` file in the root directory:

```env
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key
FIREBASE_PROJECT_ID=your_firebase_project_id
```

### Firebase Security Rules

Update your Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Public read access for eco locations and events
    match /eco_locations/{locationId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    match /events/{eventId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

## Features Implementation Status

- [x] Project setup and dependencies
- [x] Theme and color palette
- [x] Bottom navigation structure
- [x] Basic page layouts
- [x] Firebase configuration
- [ ] Interactive map with Google Maps
- [ ] Events calendar
- [ ] Booking system
- [ ] Payment integration
- [ ] Carbon tracker
- [ ] Offline support
- [ ] Multilingual support

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, email support@ecotrail.app or join our Discord community.

---

**Eco-Trail** - Travel Consciously, Explore Sustainably 🌱