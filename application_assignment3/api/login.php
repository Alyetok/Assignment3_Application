<?php
require_once "db.php";

$input = getJsonInput();
$email = requiredValue($input, "email");
$password = $input["password"] ?? "";

if ($email === "" || $password === "") {
    sendJson(false, "Email and password are required");
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    sendJson(false, "Invalid email format");
}

try {
    $pdo = getConnection();
    $stmt = $pdo->prepare("SELECT id, name, email, password FROM users WHERE email = ?");
    $stmt->execute([$email]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    // New registered users use password_hash().
    // The second check keeps the plain SQL demo seed easy for beginners to run.
    $passwordMatches = $user && (
        password_verify($password, $user["password"]) ||
        hash_equals($user["password"], $password)
    );

    if (!$passwordMatches) {
        sendJson(false, "Invalid email or password");
    }

    sendJson(true, "Login successful", [
        "id" => $user["id"],
        "name" => $user["name"],
        "email" => $user["email"],
    ]);
} catch (PDOException $e) {
    sendJson(false, "Database error during login");
}
?>
