# API Documentation

All endpoints use JSON requests and JSON responses.

Base URL example:

```text
http://localhost/application_assignment3/api
```

Standard response format:

```json
{
  "success": true,
  "message": "Message here",
  "data": []
}
```

## Register

Endpoint:

```text
POST /register.php
```

Request:

```json
{
  "name": "Ali Student",
  "email": "ali@student.com",
  "password": "password123"
}
```

Success:

```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "id": 1,
    "name": "Ali Student",
    "email": "ali@student.com"
  }
}
```

## Login

Endpoint:

```text
POST /login.php
```

Request:

```json
{
  "email": "demo@student.com",
  "password": "password123"
}
```

Success returns the logged-in user without the password.

## Get Tasks

Endpoint:

```text
POST /get_tasks.php
```

Request:

```json
{
  "user_id": 1
}
```

Returns all tasks for that user.

## Add Task

Endpoint:

```text
POST /add_task.php
```

Request:

```json
{
  "user_id": 1,
  "title": "Assignment Report",
  "description": "Write final report",
  "due_date": "2026-07-01",
  "status": "Pending"
}
```

Valid status values:

- Pending
- In Progress
- Completed

## Update Task

Endpoint:

```text
POST /update_task.php
```

Request:

```json
{
  "id": 1,
  "user_id": 1,
  "title": "Updated Assignment Report",
  "description": "Update the final report",
  "due_date": "2026-07-02",
  "status": "In Progress"
}
```

## Delete Task

Endpoint:

```text
POST /delete_task.php
```

Request:

```json
{
  "id": 1,
  "user_id": 1
}
```

## Filter Tasks

Endpoint:

```text
POST /filter_tasks.php
```

Request:

```json
{
  "user_id": 1,
  "status": "Completed"
}
```

The Flutter app filters locally as required, but this endpoint is included for backend completeness.

## Error Handling

The API handles:

- Empty fields
- Invalid email format
- Duplicate registration
- Invalid login
- Task not found
- Database errors
- Invalid status values
