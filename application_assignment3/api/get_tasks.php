<?php
require_once "db.php";

$input = getJsonInput();
$userId = intval($input["user_id"] ?? 0);

if ($userId <= 0) {
    sendJson(false, "Valid user ID is required");
}

try {
    $pdo = getConnection();
    $stmt = $pdo->prepare("SELECT id, user_id, title, description, due_date, status FROM tasks WHERE user_id = ? ORDER BY due_date ASC");
    $stmt->execute([$userId]);
    $tasks = $stmt->fetchAll(PDO::FETCH_ASSOC);

    sendJson(true, "Tasks retrieved successfully", $tasks);
} catch (PDOException $e) {
    sendJson(false, "Database error while retrieving tasks");
}
?>
