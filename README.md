Riyoshi
The future of barber booking in India.

🚀 Project Overview
Riyoshi is a Flutter-based mobile application designed to bridge the gap between Indian barbers and their clients. This repository contains the frontend source code.

Current Status: Sprint 1 - Authentication UI & Validation (Mocked).

🛠 Prerequisites
To run this project, you need the Flutter SDK and the Android SDK (for the toolchain and emulator).

Installation Guides
Since installation varies by operating system, please refer to the official Flutter documentation:

Install Flutter on Linux (Recommended for your current setup)

Install Flutter on Windows

Install Flutter on macOS

📦 Setup & Installation
Clone the Repo:

Bash

git clone git@github.com:pratripat/Riyoshi-App.git
cd riyoshi
Environment Check:
Verify your Flutter and Android SDK pathing:

Bash

flutter doctor
Install Dependencies:

Bash

flutter pub get
Run the App:

Bash

flutter run
🔑 Usage & Testing
The app currently launches into a Login Screen.

Frontend Logic: The app performs client-side validation using Regular Expressions.

Testing Auth: Enter a valid email format and any password. Upon clicking "Continue", the app will validate the input and output the credentials to the Debug Console.

Current State: No backend API or Database is connected yet. All data handling is local and temporary.

🤝 Contributing
This is a collaborative project between [Your Name] and [Friend's Name]. If the Riyoshi team is taking over this project:

Ensure flutter doctor is green.

Check main.dart for the core routing logic.