<?php
error_reporting(0); // Suppress warnings
ini_set('display_errors', 0); // Don't display errors
header('Content-Type: application/json'); // Set the content type to JSON



$servername = "localhost";
$username = "root";
$password = "";
$dbname = "on_duty";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Database connection failed: " . $conn->connect_error);
}

// Check if token is provided
if (!isset($_GET['token'])) {
    die("Invalid request.");
}

$token = $_GET['token'];
$sql = "SELECT email, expiry FROM password_resets WHERE token = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $token);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows == 0) {
    die("Invalid or expired token.");
}

$row = $result->fetch_assoc();
$email = $row['email'];
$expiry = strtotime($row['expiry']);

// Check if token has expired
if ($expiry < time()) {
    die("Token has expired. Please request a new reset link.");
}

// Handle password reset form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $new_password = $_POST['password'];
    $confirm_password = $_POST['confirm_password'];

    if (strlen($new_password) < 6) {
        die("Password must be at least 6 characters.");
    }
    if ($new_password !== $confirm_password) {
        die("Passwords do not match.");
    }

    // Hash new password
    $hashed_password = password_hash($new_password, PASSWORD_BCRYPT);

    // Update password in users table
    $update_sql = "UPDATE users SET password = ? WHERE email = ?";
    $update_stmt = $conn->prepare($update_sql);
    $update_stmt->bind_param("ss", $hashed_password, $email);
    if ($update_stmt->execute()) {
        // Delete reset token after successful password update
        $delete_sql = "DELETE FROM password_resets WHERE email = ?";
        $delete_stmt = $conn->prepare($delete_sql);
        $delete_stmt->bind_param("s", $email);
        $delete_stmt->execute();

        header('Content-Type: application/json');
        echo json_encode(['message' => 'Password reset successful. You can now <a href="login.php">log in</a>.']);

    } else {
        echo json_encode(['message' => 'error updating password']);
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password</title>
</head>
<body>
    <h2>Reset Password</h2>
    <form method="POST">
        <label>New Password:</label>
        <input type="password" name="password" required>
        <br>
        <label>Confirm Password:</label>
        <input type="password" name="confirm_password" required>
        <br>
        <button type="submit">Reset Password</button>
    </form>
</body>
</html>