# 🎮 GameExplorer

**GameExplorer** is a modern iOS app that helps users discover and track upcoming video games from the IGDB database.  
Built entirely in Swift using SwiftUI, MVVM, Coordinator pattern, and a clean modular architecture.

## 🧠 Tech Stack

- **Swift 5** - Modern, safe, and powerful
- **SwiftUI** - Declarative UI framework
- **MVVM Architecture** - Clear separation of concerns for Views and Logic
- **Coordinator Pattern** - Scalable and decoupled navigation
- **SwiftData** - Local data persistence for favorites
- **async/await** - Native concurrency for networking
- **Custom Dependency Injection** - Easy swapping between real and mock services
- **Swift Testing** - Unit testing with the new Swift native framework
- **SnapshotTesting** - UI consistency verification

## 📦 Features

- 🔎 Search for video games using IGDB API
- 📅 Browse upcoming game releases with trailers
- ⭐️ Mark and manage favorite games locally
- 🎬 Play trailers directly inside the app

## 🛠 Requirements

- iOS 17+
- Xcode 15.3+
- Swift 5

## 🔐 API Access

This app uses the [IGDB API](https://api-docs.igdb.com/) via Twitch OAuth 2.0 authentication.  
You must obtain your own **Client ID** and **Client Secret** to configure API access.  
Create a `Config.xcconfig` file based on the provided template (not tracked in Git).

## 🏗️ Project Structure

- **Architecture**
  - `Presentation/` — SwiftUI Views and ViewModels
  - `Domain/` — Use Cases and Models
  - `Data/` — Repositories and API Clients
  - `Core/` — Dependency injection, Coordinators, Extensions
  - `System/` — Configuration files

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
