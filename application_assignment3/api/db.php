<?php
// Shared database and response helper file for all API endpoints.

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, OPTIONS");

if ($_SERVER["REQUEST_METHOD"] === "OPTIONS") {
    exit;
}

const VALID_STATUSES = ["Pending", "In Progress", "Completed"];

function getConnection(): PDO
{
    try {
        $databasePath = __DIR__ . "/student_tasks.db";
        $pdo = new PDO("sqlite:" . $databasePath);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $pdo->exec("PRAGMA foreign_keys = ON");
        return $pdo;
    } catch (PDOException $e) {
        sendJson(false, "Database connection failed", null);
    }
}

function getJsonInput(): array
{
    $input = json_decode(file_get_contents("php://input"), true);
    return is_array($input) ? $input : [];
}

function sendJson(bool $success, string $message, mixed $data = null): void
{
    echo json_encode([
        "success" => $success,
        "message" => $message,
        "data" => $data,
    ]);
    exit;
}

function requiredValue(array $input, string $key): string
{
    return trim($input[$key] ?? "");
}

function isValidStatus(string $status): bool
{
    return in_array($status, VALID_STATUSES, true);
}
?>
