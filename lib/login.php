<?php
include('db_connect.php');



$email = isset($_POST['email']) ? trim($_POST['email']) : '';
$password = isset($_POST['password']) ? trim($_POST['password']) : '';

// Query the database to check if email and password match
$query = "SELECT * FROM users WHERE mail = '$email' AND password = '$password'";
$result = mysqli_query($con, $query);

if (mysqli_num_rows($result) > 0) {
    // User exists
    echo json_encode(["status" => "success", "message" => "Login successful"]);
} else {
    // User does not exist
    echo json_encode(["status" => "error", "message" => "Invalid email or password"]);
}

?>