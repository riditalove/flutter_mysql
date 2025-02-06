<?php

function dbconnection()
{
    $con = mysqli_connect("localhost","root","","on_duty");
    return $con;
    if($con)
    {
        echo "success";
    }
    else
    {
        echo "failure";
    }
}

dbconnection();

?>