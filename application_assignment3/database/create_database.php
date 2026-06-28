<?php
// Run this file once from the terminal:
// php create_database.php
//
// It creates api/student_tasks.db with one demo user and five sample tasks.

$apiFolder = dirname(__DIR__) . DIRECTORY_SEPARATOR . "api";
$databasePath = $apiFolder . DIRECTORY_SEPARATOR . "student_tasks.db";

if (!is_dir($apiFolder)) {
    mkdir($apiFolder, 0777, true);
}

$pdo = new PDO("sqlite:" . $databasePath);
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$pdo->exec("PRAGMA foreign_keys = ON");

$pdo->exec("
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
);
");

$pdo->exec("
CREATE TABLE IF NOT EXISTS tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    due_date TEXT NOT NULL,
    status TEXT NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id)
);
");

// Clear existing demo data so rerunning the script gives a predictable result.
$pdo->exec("DELETE FROM tasks");
$pdo->exec("DELETE FROM users");
$pdo->exec("DELETE FROM sqlite_sequence WHERE name IN ('users', 'tasks')");

$passwordHash = password_hash("password123", PASSWORD_DEFAULT);
$userStmt = $pdo->prepare("INSERT INTO users (name, email, password) VALUES (?, ?, ?)");
$userStmt->execute(["Demo Student", "demo@student.com", $passwordHash]);
$userId = (int)$pdo->lastInsertId();

$tasks = [
    ["Assignment Report", "Write and submit the final assignment report.", "2026-07-01", "Pending"],
    ["Database Project", "Complete SQLite database tables and test PHP APIs.", "2026-07-03", "In Progress"],
    ["Presentation Slides", "Prepare slides for lecturer demonstration.", "2026-07-05", "Pending"],
    ["Quiz Revision", "Revise lecture notes for the upcoming quiz.", "2026-07-07", "Completed"],
    ["Lab Exercise", "Finish weekly programming lab exercise.", "2026-07-09", "Pending"],
];

$taskStmt = $pdo->prepare("INSERT INTO tasks (user_id, title, description, due_date, status) VALUES (?, ?, ?, ?, ?)");
foreach ($tasks as $task) {
    $taskStmt->execute([$userId, $task[0], $task[1], $task[2], $task[3]]);
}

echo "Database created successfully at: " . $databasePath . PHP_EOL;
echo "Demo login: demo@student.com / password123" . PHP_EOL;
?>
