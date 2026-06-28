<?php
require_once "db.php";

$input = getJsonInput();
$taskId = intval($input["id"] ?? 0);
$userId = intval($input["user_id"] ?? 0);
$title = requiredValue($input, "title");
$description = requiredValue($input, "description");
$dueDate = requiredValue($input, "due_date");
$status = requiredValue($input, "status");

if ($taskId <= 0 || $userId <= 0 || $title === "" || $dueDate === "" || $status === "") {
    sendJson(false, "Task ID, user ID, title, due date, and status are required");
}

if (!isValidStatus($status)) {
    sendJson(false, "Invalid task status");
}

try {
    $pdo = getConnection();

    $check = $pdo->prepare("SELECT id FROM tasks WHERE id = ? AND user_id = ?");
    $check->execute([$taskId, $userId]);
    if (!$check->fetch()) {
        sendJson(false, "Task not found");
    }

    $stmt = $pdo->prepare("UPDATE tasks SET title = ?, description = ?, due_date = ?, status = ? WHERE id = ? AND user_id = ?");
    $stmt->execute([$title, $description, $dueDate, $status, $taskId, $userId]);

    sendJson(true, "Task updated successfully", null);
} catch (PDOException $e) {
    sendJson(false, "Database error while updating task");
}
?>
