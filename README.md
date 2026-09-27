# 📸 EventBooth — Open-Source AI Photobooth & Badge Platform

[![Flutter Web](https://img.shields.io/badge/Platform-Flutter%20Web-02569B?logo=flutter)](https://flutter.dev)
[![Gemini Multimodal AI](https://img.shields.io/badge/AI-Gemini%203.1%20Flash%20Image-FFCA28?logo=google)](https://aistudio.google.com)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture%20%2B%20Riverpod-00B4D8)](docs/tech-stack.md)
[![Automated Tests](https://img.shields.io/badge/Tests-100%25%20Passed-success)](test/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Live Demo](https://img.shields.io/badge/Live%20Demo-event--booth--2026.web.app-success?logo=firebase)](https://event-booth-2026.web.app)

> 🌐 **Live Demo:** [https://event-booth-2026.web.app](https://event-booth-2026.web.app)

---

## 🌟 What is EventBooth?

**EventBooth** is a production-grade, open-source Flutter Web application designed for tech conferences, meetups, hackathons, and community summits.

EventBooth transforms traditional event check-ins and photo booths into an unforgettable, gamified experience:
- **Zero-Auth Onboarding**: Attendees scan a QR code or visit the URL on any mobile device or desktop browser without downloading an app or creating an account.
- **Multimodal AI Badges**: Captures or uploads a photo and uses **Gemini 3.1 Flash Image** to render a personalized, high-definition badge celebrating your event's theme, city, and culture.
- **Real-Time Community Wall**: Displays all attendee credentials on a live, collaborative photo album with real-time updates.
- **Formula 1 Grand Prix Prize Roulette**: A high-energy gamified raffle spinner that reveals 3 lucky winners on an authentic 3-tiered podium (P1, P2, P3).
- **Secret Admin Control Room (`/admin`)**: A PIN-protected dashboard allowing organizers to dynamically brand the entire event in under 60 seconds—customizing logos, hero mascots, prompts, Gemini API keys, exporting attendees to CSV, and wiping the album between event days.
- **Real-Time Bilingual Support**: Instant one-click toggle between **English (🇺🇸)** and **Spanish (🇨🇴)** with live UI updates across all screens.

---

## 📸 Screenshots & Walkthrough

### 1. Photobooth & Live Badge Generator
*Interactive responsive camera viewfinder, file uploader, attendee details, and real-time badge preview with holographic borders.*

![EventBooth Photobooth](screenshots/1.png)

---

### 2. High-Definition Badge & Social Sharing
*Download high-resolution PNG badges and share directly to Instagram and social networks with event hashtags and dynamic role pills.*

![Official Badge Generation](screenshots/2.png)

---

### 3. Real-Time Community Photo Wall
*Live collaborative photo gallery streaming newly generated badges with organic scrapbook tilts, hover straightening animations, and modal detail views.*

![Live Community Wall](screenshots/3.png)

---

### 4. Formula 1 Grand Prix Prize Roulette & 3D Podium
*Gamified raffle modal with high-speed attendee cycling, starting lights, and a celebratory 3-tiered podium with confetti.*

![Formula 1 Roulette & Podium](screenshots/4.png)

---

### 5. Secret Admin Configuration Room
*PIN-protected control room to configure branding, custom logos, hero mascots, Gemini AI prompt templates, custom API keys, instant presets, attendee CSV exports, and community album maintenance.*

![Admin Configuration Dashboard](screenshots/5.png)

---

## ✨ Key Features

### 🎨 100% Configurable per Event
- **Instant Theming**: Customize Event Name, Tagline, Location, Official Hashtag, Badge Role Pill (`DEVFEST PIONEER`, `TECH PIONEER`, `VIP ATTENDEE`), and Community Album Tagline.
- **Visual Asset Management**:
  - Live 70x70 preview boxes with loading indicators and error fallbacks.
  - Paste any public image URL (HTTPS, CDN, Drive, Imgur) or upload files directly to Cloud Storage.
  - One-click reset to generic conference defaults.
- **Built-in Presets**: Switch instantly between presets (Quito 2026, Cancún 2026, and Generic Event) with automatic preservation of custom administrator credentials.

### 🤖 Gemini AI Multimodal Integration (Firebase AI Logic)
- Powered by Google's **Gemini 3.1 Flash Image** via **Firebase Vertex AI (Firebase AI Logic)**.
- **Zero API Key Friction**: Connects natively to your Firebase project's Vertex AI instance using the official `firebase_ai` SDK and authenticated REST endpoints. No manual API keys required in the Admin Panel!
- **Customizable Prompt Templates**: Adjust the multimodal prompt with dynamic tags (`{name}`, `{eventName}`, `{location}`, `{hashtag}`) and regional phrases catalog directly in the Admin Panel.

### 📊 Community Album & Data Management
- **One-Click CSV Export**: Export all registered attendees (`Nombre,Email,Evento,Fecha`) to a `.csv` file formatted with UTF-8 BOM (`﻿`) for perfect compatibility with Microsoft Excel and Google Sheets.
- **One-Click Album Reset**: Delete all cards safely with an irreversible confirmation modal using Cloud Firestore chunked 500-batch operations.

### 🌐 Real-Time Bilingual Internationalization (i18n)
- Seamless real-time switching between **English (🇺🇸)** and **Spanish (🇨🇴)**.
- Covers navigation, form validation, photobooth steps, community wall, F1 roulette, and the entire admin dashboard.

### 📱 Responsive & Zero-Auth Architecture
- Fluidly scales from 320px mobile viewports up to 4K conference hall projectors.
- Zero login friction: attendees jump straight into creating their badge.

---

## 🚀 Speaker & Organizer Setup Guide (Self-Hosting)

> [!IMPORTANT]
> The demo backend is dedicated to showcase events. **If you are a tech speaker, community organizer, or GDG lead**, you should deploy your own isolated Firebase backend for your event. Follow this step-by-step guide to be live in under 5 minutes:

### 📋 Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.24 or higher)
- [Firebase CLI](https://firebase.google.com/docs/cli) (`npm install -g firebase-tools`)
- [Google Cloud SDK / gcloud CLI](https://cloud.google.com/sdk/docs/install)
- A Google / Firebase Account

---

### 🛠️ Step 1: Create a Firebase Project & Upgrade to Blaze
1. Open the [Firebase Console](https://console.firebase.google.com) and click **"Add project"** (e.g., `eventbooth-myconf-2026`).
2. Upgrade your project to the **Blaze Plan (Pay as you go)**.
   > **💡 Cost Note:** Google provides generous free tiers for Vertex AI and Gemini. For a conference of 300+ attendees, total AI badge generation costs are typically under **$0.50 USD**.

---

### 🔌 Step 2: Enable Required Firebase & Google Cloud Services
In your Firebase Console, activate the following 4 services from the left sidebar (*Build* menu):

1. **Cloud Firestore**:
   - Go to **Build > Firestore Database** -> Click **"Create database"**.
   - Select your preferred region and start in *Production* (or *Test*) mode. *(The repository includes complete production security rules in `firestore.rules`)*.
2. **Cloud Storage**:
   - Go to **Build > Storage** -> Click **"Get started"**.
   - Provisions your storage bucket (`gs://<your-project-id>.firebasestorage.app`) for badge graphics.
3. **Vertex AI in Firebase (Firebase AI Logic)**:
   - Go to **Build > Vertex AI in Firebase** (or **AI Logic**) -> Click **"Get started"**.
   - Follow the prompt to enable the `firebasevertexai.googleapis.com` API for `gemini-3.1-flash-image`.
   - *Alternatively, enable it via terminal with gcloud:*
     ```bash
     gcloud services enable firebasevertexai.googleapis.com --project=<YOUR_PROJECT_ID>
     ```
4. **Firebase Hosting**:
   - Go to **Build > Hosting** -> Click **"Get started"**.

---

### 🌐 Step 3: Configure CORS on Cloud Storage (Critical for Web)
To enable web browsers to render, manipulate, and download user badges without being blocked by browser CORS policy, apply the included [`cors.json`](cors.json) to your storage bucket:

```bash
gcloud storage buckets update gs://<YOUR_PROJECT_ID>.firebasestorage.app --cors-file=cors.json
```

---

### 💻 Step 4: Clone & Configure Your Flutter App
```bash
# 1. Clone the repository
git clone https://github.com/jggomez/photo-booth.git
cd photo-booth

# 2. Get dependencies
flutter pub get

# 3. Authenticate with Firebase
firebase login

# 4. Configure FlutterFire to link your Firebase project
flutterfire configure --project=<YOUR_PROJECT_ID> --platforms=web
```
*(This automatically writes your project credentials into `lib/firebase_options.dart` and `.firebaserc`)*.

---

### 🚀 Step 5: Build & Deploy to Firebase Hosting
Deploy your web application along with the bundled security rules and storage configuration:

```bash
# 1. Build the production Web bundle
flutter build web --release

# 2. Deploy Web hosting, Firestore rules, and Storage rules
firebase deploy --only hosting,firestore:rules,storage
```

Once deployment completes, Firebase CLI will output your live URL:
```text
✔ Hosting URL: https://<YOUR_PROJECT_ID>.web.app
```

---

### ⚙️ Step 6: Brand Your Event in the Secret Admin Panel
1. Navigate to: **`https://<YOUR_PROJECT_ID>.web.app/#/admin`**
2. Enter the default administrator PIN: **`2026`**.
3. **Customize your event**:
   - Set **Event Name**, **Tagline**, **Location**, and **Official Hashtag**.
   - Upload your event's **Official Logo** and **Photobooth Hero Mascot** (or choose one of the built-in Presets: Quito, Cancún, or Generic).
   - Tailor the multimodal AI prompt template if desired.
   - **Update the Admin PIN**: Set your own private PIN (minimum 4 characters) to secure your dashboard.
4. Click **"Guardar Configuración en Vivo" / "Save Live Configuration"**.

---

### 🎉 Step 7: Ready for Your Attendees!
- Display your web URL or print a QR code on your conference slides.
- Attendees scan the QR code from their mobile phones, generate custom AI badges, view the live community photo wall, and participate in the F1 Grand Prix prize roulette!

---

## 🏛️ Architecture & Clean Code

EventBooth strictly adheres to **Clean Architecture** and **SOLID principles**:

```text
lib/
├── domain/                  # 100% Pure Dart — Core business logic
│   ├── entities/            # EventConfig, UserCard, BadgeDraft, AiBadgeResult
│   ├── repositories/        # Repository interfaces (IEventConfigRepository, IUserCardRepository, IAiBadgeService)
│   └── usecases/            # GenerateAiBadge, ClearCommunityWall, SaveEventConfig, WatchEventConfig
├── data/                    # Data Layer & Infrastructure
│   ├── models/              # DTOs (EventConfigModel, UserCardModel) with Firestore serialization
│   ├── datasources/         # Firestore (AppConfig, UserCards), Firebase Storage, AI Remote DataSource
│   └── repositories/        # Concrete repository implementations
└── presentation/            # Presentation & UI Layer
    ├── localization/        # AppStrings dictionary for English & Spanish
    ├── providers/           # Riverpod state notifiers, streams, and dependency injection
    ├── screens/             # MainHomeScreen, PhotoboothScreen, CommunityWallScreen, AdminConfigScreen
    ├── widgets/             # OfficialBadgeCard, CommunityBadgeItem, F1RouletteDialog, LanguageFlagToggle
    └── utils/               # WebImageDownloader, WebCsvExporter, SocialShareService
```

### Key Engineering Standards
- **Zero `dart:io` Imports**: Fully compatible with Flutter Web and CanvasKit/Wasm runtimes.
- **Memory Safety**: All `TextEditingController`, `AnimationController`, and `StreamSubscription` instances are strictly disposed.
- **100% Automated Test Coverage**: Unit tests for use cases and models; widget tests with mocked dependencies.

---

## 🧪 Running Automated Tests

```bash
# Run static analysis
dart analyze

# Run all automated tests
flutter test
```

---

## 🤝 Contributing & Community

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/jggomez/photo-booth/issues).

---

## 📄 License

This project is licensed under the **Apache License 2.0** — see the [LICENSE](LICENSE) file for details.
