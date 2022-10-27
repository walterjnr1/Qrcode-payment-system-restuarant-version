<?php 
require_once('db.php'); 
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header("Access-Control-Allow-Headers: X-Requested-With");
header('Content-Type: application/json');

$username = $_GET['username'];
$total = $_GET['total'];

//$total = 1000;
//$username = 'walterjnr1';

//Get current bal
$stmt = $dbh->prepare("UPDATE users SET balance = (balance) + ? WHERE username = ?");
$result =  $stmt->execute([$total,$username]);
echo json_encode(['success' => $result]);
?>
