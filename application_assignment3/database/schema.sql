-- SQLite database creation script for Student Task and Reminder App
-- Database name: student_tasks.db

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    due_date TEXT NOT NULL,
    status TEXT NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id)
);

-- Sample task data belongs to user ID 1.
-- Use database/create_database.php for a ready demo database with a hashed password.
INSERT INTO users (id, name, email, password)
VALUES (1, 'Demo Student', 'demo@student.com', 'password123');

INSERT INTO tasks (user_id, title, description, due_date, status) VALUES
(1, 'Assignment Report', 'Write and submit the final assignment report.', '2026-07-01', 'Pending'),
(1, 'Database Project', 'Complete SQLite database tables and test PHP APIs.', '2026-07-03', 'In Progress'),
(1, 'Presentation Slides', 'Prepare slides for lecturer demonstration.', '2026-07-05', 'Pending'),
(1, 'Quiz Revision', 'Revise lecture notes for the upcoming quiz.', '2026-07-07', 'Completed'),
(1, 'Lab Exercise', 'Finish weekly programming lab exercise.', '2026-07-09', 'Pending');
