<?php
require_once "db.php";

$input = getJsonInput();
$name = requiredValue($input, "name");
$email = requiredValue($input, "email");
$password = $input["password"] ?? "";

if ($name === "" || $email === "" || $password === "") {
    sendJson(false, "All fields are required");
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    sendJson(false, "Invalid email format");
}

if (strlen($password) < 6) {
    sendJson(false, "Password must be at least 6 characters");
}

try {
    $pdo = getConnection();

    $check = $pdo->prepare("SELECT id FROM users WHERE email = ?");
    $check->execute([$email]);
    if ($check->fetch()) {
        sendJson(false, "Email already registered");
    }

    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
    $stmt = $pdo->prepare("INSERT INTO users (name, email, password) VALUES (?, ?, ?)");
    $stmt->execute([$name, $email, $hashedPassword]);

    sendJson(true, "Registration successful", [
        "id" => $pdo->lastInsertId(),
        "name" => $name,
        "email" => $email,
    ]);
} catch (PDOException $e) {
    sendJson(false, "Database error during registration");
}
?>
