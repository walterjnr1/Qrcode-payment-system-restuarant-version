<?php 
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header("Access-Control-Allow-Headers: X-Requested-With");
header('Content-Type: application/json');
include "db.php";
header('Content-Type: application/json');

$email =  $_GET['email'];
$stmt = $dbh->prepare("SELECT * FROM customers WHERE email = ?");
$stmt->execute([$email]);
$result = $stmt->fetchAll(PDO::FETCH_ASSOC);
echo json_encode($result);
?>