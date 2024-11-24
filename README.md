# MVVM Flutter Demo

A Flutter demonstration application showcasing the MVVM (Model-View-ViewModel) architecture pattern with clean code principles and modern state management.

## Architecture Overview

The application is structured using the MVVM pattern with clear separation of concerns:

### 📱 Presentation Layer
- **Views**: Flutter widgets that handle UI rendering
- **ViewModels**: Manage UI state and business logic
- Uses Provider for state management
- Implements loading states and error handling

### 🏗 Domain Layer
- Business logic and model definitions
- Pure Dart code with no Flutter dependencies
- Contains entity models and business rules

### 💾 Data Layer
- Handles data persistence and retrieval
- Repository pattern implementation
- Local storage using SharedPreferences

## Project Structure





