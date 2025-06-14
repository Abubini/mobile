# 🎮 BookMyScreen - Mobile Cinema Booking Application

A cross-platform Flutter application for cinema ticket booking with Firebase integration and multi-platform support.

---

## 📱 Application Overview

BookMyScreen is a comprehensive mobile cinema booking application built with Flutter, supporting:

* Android
* iOS
* macOS
* Linux
* Windows
* Web

### ✨ Key Features

* 🎟️ Cinema ticket booking across multiple platforms
* 🔐 Firebase backend integration
* 📷 QR code scanning for ticket validation
* 🧱 Multi-platform deployment support
* 🎨 Modern Flutter UI with native performance

---

## 🛠️ Technical Stack

* **Framework:** Flutter (Stable Channel)
* **Backend:** Firebase
* **Platforms:** Android, iOS, macOS, Linux, Windows, Web
* **Build Systems:** Gradle (Android), Xcode (iOS/macOS), CMake (Linux/Windows)

---

## 📋 Prerequisites

### ✅ Required Software

* Flutter SDK (Stable channel)
* Android Studio
* Xcode (macOS only)
* Visual Studio (for Windows)
* Git

### ⚙️ Platform-Specific Requirements

#### Android

* Android SDK API Level 23+
* Java 11+
* NDK 27.0.12077973

#### iOS

* iOS 11.0+
* Xcode 12.0+
* CocoaPods

#### Desktop

* **Linux:** GTK+ 3.0, CMake 3.10+
* **Windows:** Visual Studio 2019+, CMake 3.14+
* **macOS:** macOS 10.14+, Xcode 12.0+

---

## 🚀 Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/Abubini/mobile.git
cd mobile
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Configuration

#### Android

1. Add `google-services.json` to `android/app/`
2. Make sure the Firebase project ID is: `cinema-app-6e991`
3. Package name should match: `com.example.BookMyScreen`

#### iOS

1. Add `GoogleService-Info.plist` to `ios/Runner/`
2. Configure Firebase via Xcode project settings

---

## ⚙️ Platform-Specific Builds

### 🧪 Run Application

```bash
flutter run               # Run on default device
flutter run -d android   # Run on Android
flutter run -d ios       # Run on iOS
flutter run -d chrome    # Run on Web
flutter run -d windows   # Run on Windows
flutter run -d linux     # Run on Linux
flutter run -d macos     # Run on macOS
```

### 🔧 Debug & Hot Reload

```bash
flutter run --debug      # Debug mode
# Press 'r' in terminal for hot reload
```

---

## 📱 Platform Configuration

### Android

* Package Name: `com.example.BookMyScreen`
* Min SDK: 23
* Permissions: Internet, Camera, Storage

### iOS

* Bundle ID: `com.example.cinemaApp`
* Display Name: "Cinema App"
* Min iOS Version: 11.0+

### Web

* App Name: "cinema\_app"
* Theme Color: `#0175C2`
* Display Mode: Standalone PWA

---

## 🔥 Firebase Integration

* Project ID: `cinema-app-6e991`
* Storage Bucket: `cinema-app-6e991.firebasestorage.app`
* Services:

  * Firebase Auth
  * Firestore
  * Firebase Storage

---

## 📦 Build Commands

### 📄 Release Builds

```bash
flutter build apk --release         # Android APK
flutter build appbundle --release  # Android AAB
flutter build ios --release        # iOS
flutter build linux --release      # Linux
flutter build windows --release    # Windows
flutter build macos --release      # macOS
flutter build web --release        # Web
```

### 🧪 Debug Builds

```bash
flutter build apk --debug
flutter build ios --debug
```

---

## 🥺 Testing

```bash
flutter test                      # Unit tests
flutter test integration_test/   # Integration tests
```

Platform Testing:

* ✅ Android Emulator or Device
* ✅ iOS Simulator or Device
* ✅ Desktop Machine
* ✅ Web Browsers: Chrome, Firefox, Safari

---

## 🗂 Project Structure

```
mobile/
├── android/          # Android-specific
├── ios/              # iOS-specific
├── linux/            # Linux-specific
├── macos/            # macOS-specific
├── web/              # Web-specific
├── windows/          # Windows-specific
├── lib/              # Dart/Flutter app code
├── test/             # Unit tests
└── integration_test/ # Integration tests
```

---

## 🚀 Deployment

### Android

* Sign APK/AAB
* Upload to Google Play Console

### iOS

* Archive in Xcode
* Upload to App Store Connect

### Web

* Deploy `build/web/` to your hosting service
* Setup PWA and HTTPS

### Desktop

* Build native installer (Windows `.exe`, macOS `.dmg`, etc.)
* Distribute via store or direct download

---

## 🤝 Contributing

1. Fork this repo
2. Create a new feature branch
3. Commit your changes
4. Run all tests
5. Submit a pull request

---

## 📞 Support

For issues or support, please open an issue in the [GitHub repository](https://github.com/Abubini/mobile/issues).

---

> **Note**: Firebase configuration files are required for full functionality. Ensure they are properly set up before building for production.
