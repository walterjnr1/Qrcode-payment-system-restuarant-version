<?php 
require_once('db.php'); 
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header("Access-Control-Allow-Headers: X-Requested-With");
header('Content-Type: application/json');

$email = $_GET['email'];
$amt = $_GET['amt'];

//Get current bal 
$stmt = $dbh->prepare("UPDATE customers SET balance = (balance) + ? WHERE email = ?");
$result =  $stmt->execute([$amt,$email]);
echo json_encode(['success' => $result]);
?>
