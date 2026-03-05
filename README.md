# Riyoshi
*The future of barber booking in India.*

## 🚀 Project Overview
Riyoshi is a Flutter-based mobile application designed to bridge the gap between Indian barbers and their clients. This repository contains the frontend source code.

**Current Status:** Sprint 1 - Authentication UI & Validation (Mocked).

## 🛠 Prerequisites
To run this project, you need the **Flutter SDK** and the **Android SDK**.

### **Installation Guides**
Installation varies by operating system. Refer to the official documentation:
* [Install Flutter on Linux](https://docs.flutter.dev/get-started/install/linux)
* [Install Flutter on Windows](https://docs.flutter.dev/get-started/install/windows)
* [Install Flutter on macOS](https://docs.flutter.dev/get-started/install/macos)

## 📦 Setup & Installation

1. **Clone the Repo:**
   ```bash
   git clone https://github.com/pratripat/Riyoshi-App
   cd Riyoshi-App
   ```

2. **Environment Check:**
   Verify your Flutter toolchain is functional:
   ```bash
   flutter doctor
   ```

3. **Fetch Dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the Application:**
   ```bash
   flutter run
   ```

## 🔑 Usage & Testing
The app currently launches into the Login Screen.

**Validation:** The "Continue" button triggers a validation check. It requires a valid email format (via RegExp) and a non-empty password.

**Testing:** Enter a valid email (e.g., `user@riyoshi.com`) and any password.

**Observation:** Successful validation will print the email and password to the Debug Console (Stdout).