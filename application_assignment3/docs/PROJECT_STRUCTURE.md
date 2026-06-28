# Project Structure Explanation

```text
application_assignment3/
├── flutter_app/
│   ├── lib/
│   │   ├── models/
│   │   │   ├── user.dart
│   │   │   └── task.dart
│   │   ├── services/
│   │   │   └── api_service.dart
│   │   ├── screens/
│   │   │   ├── splash_screen.dart
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   ├── add_task_screen.dart
│   │   │   └── edit_task_screen.dart
│   │   ├── widgets/
│   │   │   └── task_card.dart
│   │   └── main.dart
│   └── pubspec.yaml
├── api/
│   ├── db.php
│   ├── register.php
│   ├── login.php
│   ├── get_tasks.php
│   ├── add_task.php
│   ├── update_task.php
│   ├── delete_task.php
│   └── filter_tasks.php
├── database/
│   ├── schema.sql
│   └── create_database.php
└── docs/
    ├── SETUP_INSTRUCTIONS.md
    ├── API_DOCUMENTATION.md
    └── PROJECT_STRUCTURE.md
```

## Flutter Folder

`models` contains simple Dart classes for users and tasks.

`services/api_service.dart` handles all HTTP communication with PHP endpoints.

`screens` contains the required app pages:

- Splash screen
- Login screen
- Register screen
- Home task list screen
- Add task screen
- Edit task screen

`widgets/task_card.dart` contains a reusable card widget for showing a task.

## API Folder

The PHP files are REST-style endpoints. Each endpoint receives JSON, validates input, talks to SQLite using PDO, and returns JSON.

`db.php` contains shared code for:

- SQLite connection
- JSON input reading
- JSON output response
- Status validation

## Database Folder

`schema.sql` shows the database tables required by the assignment.

`create_database.php` creates the actual SQLite database and inserts demo data.

## Why This Design Is Simple

- No Firebase
- No push notifications
- No real-time updates
- No third-party login
- No complex authentication tokens
- Task filtering is done inside Flutter
- PHP APIs are short and easy to explain
