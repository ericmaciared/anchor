# ⚓ Anchor

> **Become better, daily.**

A beautiful, intuitive Flutter app for building lasting habits and managing tasks with style. Anchor
helps you stay grounded in your goals while providing a delightful user experience.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white)

## ✨ Features

### 🎯 Task Management

- **Smart Scheduling**: Schedule tasks with start times and durations
- **Subtask Support**: Break down complex tasks into manageable steps
- **Flexible Organization**: Scheduled and unscheduled task categories
- **Progress Tracking**: Visual progress indicators and completion states
- **Custom Notifications**: Set reminders before task start times

### 🔥 Habit Building

- **Streak Tracking**: Visual streak counters with fire icons
- **Daily Completion**: Simple tap-to-complete interface
- **Habit Categories**: Pre-built habits plus custom creation
- **Progress Insights**: Track your consistency over time

### 🎨 Beautiful Design

- **Dynamic Gradients**: Animated background gradients that evolve over time
- **Liquid Glass Effects**: Modern glassmorphism UI elements
- **Adaptive Themes**: Automatic light/dark mode support
- **Smooth Animations**: Delightful micro-interactions throughout
- **Haptic Feedback**: Tactile responses for every interaction

### 📱 Personalization

- **Profile Customization**: Set your name and preferences
- **Display Options**: Compact or spacious layout modes
- **Visual Effects**: Toggle confetti and other celebrations
- **Daily Quotes**: Inspirational quotes to start your day
- **Status Messages**: Smart greeting system with progress insights

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (included with Flutter)
- Android Studio / VS Code with Flutter extensions
- iOS development tools (for iOS builds)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/anchor.git
   cd anchor
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Release

**Android APK:**

```bash
flutter build apk --release
```

**iOS IPA:**

```bash
flutter build ios --release
```

## 🏗️ Architecture

Anchor follows a clean, modular architecture built on Flutter best practices:

```
lib/
├── core/                   # Core utilities and shared resources
│   ├── database/          # SQLite database schema and providers
│   ├── router/            # Navigation and routing
│   ├── theme/             # App theming and design tokens
│   ├── services/          # Haptic feedback and other services
│   ├── mixins/            # Reusable behavior mixins
│   └── widgets/           # Core reusable widgets
├── features/              # Feature-based organization
│   ├── tasks/             # Task management feature
│   ├── habits/            # Habit tracking feature
│   ├── profile/           # User profile and settings
│   ├── shared/            # Shared feature components
│   └── welcome/           # Onboarding experience
└── main.dart              # App entry point
```

### Key Technologies

- **State Management**: Riverpod for reactive state management
- **Database**: SQLite with sqflite for local data persistence
- **Navigation**: GoRouter for declarative routing
- **Animations**: Custom animation controllers with safe disposal
- **UI Effects**: Liquid Glass Renderer for glassmorphism effects
- **Notifications**: Local notifications with timezone support

## 🎨 Design Philosophy

Anchor embraces a **"liquid modern"** design language that combines:

- **Fluid Interactions**: Smooth, physics-based animations
- **Glass Aesthetics**: Translucent surfaces with blur effects
- **Dynamic Backgrounds**: Ever-changing gradient compositions
- **Tactile Feedback**: Rich haptic responses for every interaction
- **Thoughtful Typography**: Carefully chosen text hierarchy and spacing

## 🧪 Testing

Run the test suite:

```bash
flutter test
```

For integration tests:

```bash
flutter test integration_test/
```

## 📚 Dependencies

### Core Dependencies

- `flutter_riverpod` - State management
- `sqflite` - Local database
- `go_router` - Navigation
- `shared_preferences` - Settings persistence

### UI & Animation

- `liquid_glass_renderer` - Glassmorphism effects
- `confetti` - Celebration animations
- `table_calendar` - Calendar widget
- `day_night_time_picker` - Time selection

### Utilities

- `uuid` - Unique ID generation
- `intl` - Internationalization
- `csv` - Quote data parsing
- `flutter_local_notifications` - Task reminders

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide] for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes with tests
4. Commit using conventional commits: `git commit -m "feat: add amazing feature"`
5. Push to your branch: `git push origin feature/amazing-feature`
6. Open a Pull Request

## 🙏 Acknowledgments

- Inspired by modern productivity apps and mindful design
- Built with love using Flutter and the amazing Flutter community packages

---

<div style="text-align: center; margin-top: 20px;">

**[Download on App Store]** | **[Visit Website]**

Made with ❤️ and ☕ by the Anchor Team

</div>
