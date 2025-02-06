<?php
include("dbconnection.php");

$con = dbconnection();

if(isset(($_POST['email'])))
{
    $email = $_POST['email'];
}
if(isset(($_POST['password'])))
{
    $password = $_POST['password'];
}


$query = "INSERT INTO users(`mail`, `password`) VALUES ('$email','$password')";
$exe = mysqli_query($con,$query);

$array = [];

if($exe)
{
    $array["success"]="true";
}
else{
    $array["success"]="false";
}

echo json_encode($array);

?>