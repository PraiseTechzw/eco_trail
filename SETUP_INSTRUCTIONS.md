# Eco-Trail Setup Instructions

## 🎉 Project Status

The Eco-Trail Flutter application has been successfully initialized with:

### ✅ Completed Features
- **Project Structure**: Clean architecture with feature-based organization
- **Dependencies**: All required packages installed and configured
- **Theme System**: Earth-tone color palette with light/dark mode support
- **Navigation**: Bottom navigation with 5 main sections (Map, Events, Bookings, Tips, Profile)
- **Firebase Integration**: Authentication, Firestore, and Storage configured
- **Models**: User, EcoLocation, and Event data models
- **UI Components**: Splash screen, onboarding, and basic page layouts

### 📁 Project Structure
```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── services/          # Firebase and other services
│   ├── theme/             # App theme and colors
│   └── utils/             # Utility functions
├── features/
│   ├── map/               # Interactive eco map feature
│   ├── events/            # Events calendar feature
│   ├── bookings/          # Booking system
│   ├── profile/           # User profile and settings
│   └── tips/              # Sustainability tips and carbon tracker
├── models/                 # Data models
├── widgets/               # Reusable widgets
└── main.dart             # App entry point
```

## 🚀 Next Steps

### 1. Firebase Configuration
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication, Firestore, and Storage
3. Download configuration files:
   - `google-services.json` for Android (place in `android/app/`)
   - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)
4. Update `lib/firebase_options.dart` with your Firebase configuration

### 2. Google Maps Setup
1. Get a Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
2. Update `lib/core/constants/app_constants.dart` with your API key
3. Enable the following APIs:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Places API
   - Geocoding API

### 3. Run the Application
```bash
flutter pub get
flutter run
```

## 🔧 Configuration Files to Update

### Firebase Options (`lib/firebase_options.dart`)
Replace the placeholder values with your actual Firebase configuration:
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'your-android-api-key',
  appId: 'your-android-app-id',
  messagingSenderId: 'your-sender-id',
  projectId: 'your-project-id',
  storageBucket: 'your-project-id.appspot.com',
);
```

### App Constants (`lib/core/constants/app_constants.dart`)
Update with your API keys:
```dart
static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
static const String stripePublishableKey = 'YOUR_STRIPE_PUBLISHABLE_KEY';
```

## 🎨 Design System

### Color Palette
- **Primary Green**: `#2D5016` (Deep forest green)
- **Secondary Green**: `#4A7C59` (Sage green)
- **Light Green**: `#8FBC8F` (Light sage)
- **Accent Green**: `#6B8E23` (Olive green)
- **Earth Browns**: Various brown tones for earth elements
- **Neutral Colors**: Cream, off-white, and gray tones

### Theme Features
- Material Design 3 with earth-tone colors
- Light and dark mode support
- Responsive design
- Accessibility considerations

## 📱 Current App Features

### 1. Map Page
- Google Maps integration (requires API key)
- Location services
- Eco-friendly location markers
- Search and filter functionality (placeholder)

### 2. Events Page
- Local events calendar
- Event categories and filtering
- Event details and booking

### 3. Bookings Page
- User booking management
- Payment integration (Stripe)
- Booking history

### 4. Tips Page
- Sustainability tips and advice
- Carbon footprint tracker
- Environmental impact calculator

### 5. Profile Page
- User authentication
- Theme switching
- Settings and preferences
- Language selection

## 🔮 Future Enhancements

### Phase 2 Features
- [ ] Interactive map with real eco locations
- [ ] Event calendar with real data
- [ ] Payment integration with Stripe
- [ ] Carbon footprint tracking
- [ ] Offline support and caching
- [ ] Multilingual support
- [ ] Push notifications
- [ ] Social features and reviews

### Phase 3 Features
- [ ] AI-powered itinerary planning
- [ ] Carbon offset integration
- [ ] Gamification and achievements
- [ ] Community forums
- [ ] Advanced analytics

## 🛠️ Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run with specific device
flutter run -d <device-id>

# Build for release
flutter build apk --release
flutter build ios --release

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
flutter format .
```

## 📚 Documentation

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Google Maps Flutter Plugin](https://pub.dev/packages/google_maps_flutter)
- [Riverpod State Management](https://riverpod.dev/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

---

**Eco-Trail** - Travel Consciously, Explore Sustainably 🌱
