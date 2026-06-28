# Setup Instructions

## 1. Install Required Software

Install:

- Flutter SDK
- Android Studio or VS Code
- XAMPP, Laragon, or another PHP local server
- PHP SQLite extension

## 2. Copy Project to Server Folder

Copy the whole `application_assignment3` folder into your local web server folder.

For XAMPP, a common location is:

```text
C:\xampp\htdocs\application_assignment3
```

The API should then be available at:

```text
http://localhost/application_assignment3/api
```

## 3. Create SQLite Database

Open a terminal in:

```text
application_assignment3/database
```

Run:

```bash
php create_database.php
```

This creates:

```text
application_assignment3/api/student_tasks.db
```

It also inserts one demo user and five sample tasks.

Demo login:

```text
Email: demo@student.com
Password: password123
```

## 4. Configure Flutter API URL

Open:

```text
flutter_app/lib/services/api_service.dart
```

For Android emulator, use:

```dart
static const String baseUrl = 'http://10.0.2.2/application_assignment3/api';
```

For a physical phone, use your computer IP address:

```dart
static const String baseUrl = 'http://192.168.1.10/application_assignment3/api';
```

## 5. Run Flutter App

Open terminal in:

```text
application_assignment3/flutter_app
```

Run:

```bash
flutter pub get
flutter run
```

## 6. Lecturer Demonstration Flow

Demonstrate these steps:

1. Open splash screen
2. Register a new account
3. Login
4. View task list
5. Add a task
6. Filter tasks by status
7. Edit task details and status
8. Delete a task
9. Logout
