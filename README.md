# ResuMatch

**ResuMatch** is a high-performance Flutter application designed to bridge the gap between job seekers and their dream roles. By leveraging **Gemini 2.5 Flash Lite** via **Gemini AI**, the app provides instant, intelligent analysis of resumes against specific job descriptions.

## Key Features

- **AI Resume Analysis**: Uses Gemini 2.5 Flash Lite for lightning-fast text processing and skill extraction.
- **Gemini AI**: Securely powered by `firebase_ai`—no client-side API keys required.
- **Dynamic UI**: Smooth animations, haptic feedback, and a reactive state-driven "Start Analysis" flow.
- **PDF Integration**: Direct text extraction from uploaded resume files.
- **Actionable Insights**: Get a percentage match score, identified strengths, and a list of missing keywords/skills.

## Tech Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Bloc / Cubit
- **Backend**: Firebase (Gemini AI)
- **AI Model**: Gemini 2.5 Flash Lite

## Getting Started

### 1. Firebase Setup

1. Create a new project in the [Firebase Console](https://console.firebase.google.com/).
2. Enable **GEMINI AI** in the Firebase sidebar (under "Build").
3. Add your Android/iOS app to the project.

### 2. Local Configuration

Ensure you have the [Firebase CLI](https://firebase.google.com/docs/cli) installed, then run:

```bash
flutterfire configure

```

This will generate `firebase_options.dart` and link your app to the correct project.

### 3. Running the App

```bash
# Get dependencies
flutter pub get

# Launch on your device/emulator
flutter run

```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

Distributed under the Attribution-NonCommercial-ShareAlike 4.0 International License. See [LICENSE](LICENSE) for more information.

## Contact

- [Email](mailto:shokhrukhbekdev@gmail.com)
- [GitHub](https://github.com/ShokhrukhbekYuldoshev)

## Show your support

Give a star if you like this project!
