<?php 
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header("Access-Control-Allow-Headers: X-Requested-With");
header('Content-Type: application/json');
include "db.php";
header('Content-Type: application/json');

$email=$_GET['customer_email'];
$stmt = $dbh->prepare("SELECT * FROM payments where customer_email='$email' order by ID DESC");
$stmt->execute();
$result = $stmt->fetchAll(PDO::FETCH_ASSOC);
echo json_encode($result);
?>


