<?php
require_once "db.php";

$input = getJsonInput();
$userId = intval($input["user_id"] ?? 0);
$title = requiredValue($input, "title");
$description = requiredValue($input, "description");
$dueDate = requiredValue($input, "due_date");
$status = requiredValue($input, "status");

if ($userId <= 0 || $title === "" || $dueDate === "" || $status === "") {
    sendJson(false, "User ID, title, due date, and status are required");
}

if (!isValidStatus($status)) {
    sendJson(false, "Invalid task status");
}

try {
    $pdo = getConnection();
    $stmt = $pdo->prepare("INSERT INTO tasks (user_id, title, description, due_date, status) VALUES (?, ?, ?, ?, ?)");
    $stmt->execute([$userId, $title, $description, $dueDate, $status]);

    sendJson(true, "Task added successfully", [
        "id" => $pdo->lastInsertId(),
        "user_id" => $userId,
        "title" => $title,
        "description" => $description,
        "due_date" => $dueDate,
        "status" => $status,
    ]);
} catch (PDOException $e) {
    sendJson(false, "Database error while adding task");
}
?>
