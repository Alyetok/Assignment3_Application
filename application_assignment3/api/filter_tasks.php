<?php
require_once "db.php";

$input = getJsonInput();
$userId = intval($input["user_id"] ?? 0);
$status = requiredValue($input, "status");

if ($userId <= 0 || $status === "") {
    sendJson(false, "User ID and status are required");
}

if (!isValidStatus($status)) {
    sendJson(false, "Invalid task status");
}

try {
    $pdo = getConnection();
    $stmt = $pdo->prepare("SELECT id, user_id, title, description, due_date, status FROM tasks WHERE user_id = ? AND status = ? ORDER BY due_date ASC");
    $stmt->execute([$userId, $status]);
    $tasks = $stmt->fetchAll(PDO::FETCH_ASSOC);

    sendJson(true, "Filtered tasks retrieved successfully", $tasks);
} catch (PDOException $e) {
    sendJson(false, "Database error while filtering tasks");
}
?>
