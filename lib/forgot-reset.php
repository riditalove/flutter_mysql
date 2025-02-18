<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header('Content-Type: application/json');

error_reporting(0); // Suppress warnings
ini_set('display_errors', 0); // Don't display errors

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require 'C:\xampp\htdocs\on_duty\vendor\autoload.php';



$servername = "localhost";
$username = "root";
$password = "";
$dbname = "on_duty";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["message" => "Database connection failed"]));
}

$email = $_POST['email'];

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode(["message" => "Invalid email format"]);
    exit();
}

$sql = "SELECT id FROM users WHERE mail = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows == 0) {
    echo json_encode(["message" => "Email not found"]);
    exit();
}

$token = bin2hex(random_bytes(50));
$expiry = date("Y-m-d H:i:s", strtotime("+1 hour"));

$sql = "INSERT INTO password_resets (email, token, expiry) VALUES (?, ?, ?)
        ON DUPLICATE KEY UPDATE token = VALUES(token), expiry = VALUES(expiry)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("sss", $email, $token, $expiry);
$stmt->execute();



$mail = new PHPMailer(true);

try {
    $mail->isSMTP();
    $mail->Host       = 'smtp.gmail.com';
    $mail->SMTPAuth   = true;
    $mail->Username   = 'fabihaafrose786@gmail.com';
    $mail->Password   = 'bvog toak wisz wucu'; // Use App Password, not your Gmail password
    $mail->SMTPSecure = 'tls';
    $mail->Port       = 587;

    $mail->setFrom('fabihaafrose786@gmail.com', 'Webmaster');
    $mail->addAddress('$email');

    $mail->Subject = 'Your recovery link';
    $resetLink = "https://localhost/reset-password.php?token=$token";
    $mail->Body = "Click the link to reset your password : $resetLink";


    $mail->send();
    echo json_encode(["message" => "Password reset link sent to your email"]);
} catch (Exception $e) {
    echo json_encode(["message" => "$e->errorMessage()"]);
    echo json_encode(["message" => "sorry, something went wrong"]);
}





$conn->close();
?>
