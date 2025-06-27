# Payment Dashboard Frontend

A Flutter application for the Payment Dashboard System that provides a modern, responsive interface for managing payments and users.

## Features

- **Authentication**: Secure login with JWT tokens
- **Dashboard**: Overview with statistics and revenue charts
- **Payments Management**: View, filter, and create payments with pagination
- **User Management**: Admin-only user creation and management
- **Responsive Design**: Works on mobile, tablet, and desktop
- **Real-time Updates**: Live data updates using Provider state management

## Prerequisites

- Flutter SDK (version 3.8.1 or higher)
- Dart SDK
- VS Code or Android Studio (recommended)
- Backend API running on `http://localhost:3000`

## Installation

1. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

2. **Ensure backend is running:**
   Make sure the NestJS backend is running on `http://localhost:3000`

3. **Run the application:**
   ```bash
   # For web (recommended for development)
   flutter run -d chrome
   
   # For mobile (Android)
   flutter run
   
   # For desktop
   flutter run -d windows
   ```

## Default Credentials

- **Username**: `admin`
- **Password**: `admin123`

## Project Structure

```
lib/
├── models/              # Data models
├── providers/           # State management
├── screens/             # App screens
├── services/            # API and storage services
├── widgets/             # Reusable UI components
└── main.dart           # App entry point
```

## Key Dependencies

- **provider**: State management
- **http**: API communication
- **shared_preferences**: Local storage
- **fl_chart**: Charts and graphs
- **intl**: Date formatting
- **responsive_framework**: Responsive design
