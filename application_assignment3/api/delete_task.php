<?php
require_once "db.php";

$input = getJsonInput();
$taskId = intval($input["id"] ?? 0);
$userId = intval($input["user_id"] ?? 0);

if ($taskId <= 0 || $userId <= 0) {
    sendJson(false, "Task ID and user ID are required");
}

try {
    $pdo = getConnection();

    $check = $pdo->prepare("SELECT id FROM tasks WHERE id = ? AND user_id = ?");
    $check->execute([$taskId, $userId]);
    if (!$check->fetch()) {
        sendJson(false, "Task not found");
    }

    $stmt = $pdo->prepare("DELETE FROM tasks WHERE id = ? AND user_id = ?");
    $stmt->execute([$taskId, $userId]);

    sendJson(true, "Task deleted successfully", null);
} catch (PDOException $e) {
    sendJson(false, "Database error while deleting task");
}
?>
