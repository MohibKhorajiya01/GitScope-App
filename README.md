<div align="center">

<img src="https://img.shields.io/badge/Flutter-3.7%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
<img src="https://img.shields.io/badge/Dart-3.0%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
<img src="https://img.shields.io/badge/GitHub_GraphQL-API-181717?style=for-the-badge&logo=github&logoColor=white"/>
<img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge"/>

# 🔭 GitScope

**A sleek, GitHub-inspired Flutter app to explore any GitHub profile and their repositories — powered by the GitHub GraphQL API.**

[Features](#-features) • [Screenshots](#-screenshots) • [Architecture](#️-architecture) • [Getting Started](#-getting-started) • [Tech Stack](#-tech-stack) • [Contributing](#-contributing) • [License](#-license)

</div>

---

## ✨ Features

| Feature | Description |
|--------|-------------|
| 🔍 **User Search** | Search any GitHub username instantly |
| 👤 **Profile View** | Avatar, bio, company, location, followers, following & repo count |
| 📂 **Repository Explorer** | Browse all public repos with language, stars & forks |
| 📜 **Infinite Scroll** | Auto-loads more repositories as you scroll down |
| 🔗 **Open in GitHub** | Tap any repo to open it directly in the browser |
| 🕐 **Recent Searches** | Search history persists locally across app restarts |
| ⭐ **Popular Developers** | Quick-access cards for famous GitHub profiles |
| 🎨 **GitHub-Themed UI** | Dark AppBar, clean cards, and GitHub-inspired color palette |

---

## 📸 Screenshots

> Coming soon — contributions welcome!

---

## 🏗️ Architecture

GitScope follows **Clean Architecture** with a feature-based folder structure for clear separation of concerns and scalability.

```
lib/
├── core/                   # Theme, constants, errors, GraphQL client
├── features/
│   ├── profile/            # User profile (domain → data → presentation)
│   ├── repositories/       # Repo list with pagination
│   └── search/             # Home screen & recent searches
├── router/                 # GoRouter navigation
├── shared/                 # Reusable widgets (LanguageBadge, ErrorView, etc.)
└── splash/                 # Splash screen
```

Each feature is structured as:
```
feature/
├── domain/        # Entities & repository interfaces
├── data/          # Data sources, models & repository implementations
└── presentation/  # Riverpod providers, screens & widgets
```

---

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| [Flutter](https://flutter.dev/) | Cross-platform UI framework |
| [Riverpod](https://riverpod.dev/) *(with code gen)* | Reactive state management |
| [graphql_flutter](https://pub.dev/packages/graphql_flutter) | GitHub GraphQL API integration |
| [GoRouter](https://pub.dev/packages/go_router) | Declarative navigation & routing |
| [Google Fonts (Inter)](https://pub.dev/packages/google_fonts) | Clean, modern typography |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | Local persistence for recent searches |
| [url_launcher](https://pub.dev/packages/url_launcher) | Open repository links in browser |
| [Freezed](https://pub.dev/packages/freezed) | Sealed classes for error handling |

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** `>= 3.7.0`  
  → [Install Flutter](https://docs.flutter.dev/get-started/install)
- A **GitHub Personal Access Token (Classic)**  
  → [Generate one here](https://github.com/settings/tokens/new) with the following scopes:
  - `read:user`
  - `public_repo`

---

### Setup

**1. Clone the repository**
```bash
git clone https://github.com/YOUR_USERNAME/gitscope.git
cd gitscope
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Generate code** *(Riverpod + Freezed)*
```bash
dart run build_runner build --delete-conflicting-outputs
```

**4. Add your GitHub token**

Create a `.env` file in the project root:
```env
GITHUB_TOKEN=your_github_personal_access_token_here
```

> ⚠️ **Security:** The `.env` file is already listed in `.gitignore` — your token will **never** be pushed to GitHub.

**5. Run the app**
```bash
flutter run
```

---

## 📦 Building for Release

**Android APK**
```bash
flutter build apk --release
```

**iOS**
```bash
flutter build ios --release
```

---

## 🧪 Running Tests

```bash
flutter test
```

---

## 🤝 Contributing

Contributions are welcome and appreciated! Here's how to get started:

1. **Fork** this repository
2. **Create** a feature branch: `git checkout -b feature/your-feature-name`
3. **Commit** your changes: `git commit -m 'feat: add your feature'`
4. **Push** to your branch: `git push origin feature/your-feature-name`
5. **Open a Pull Request**

Please make sure your code follows the existing architecture and style conventions.

---

## 🐛 Known Issues / Roadmap

- [ ] Add screenshots to README
- [ ] Write unit & widget tests
- [ ] Add dark/light theme toggle
- [ ] Support for GitHub Organizations
- [ ] Repository detail screen with README preview

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

<div align="center">

Made with ❤️ using Flutter

⭐ **Star this repo** if you found it useful!

</div>
