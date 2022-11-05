<?php 
require_once('db.php'); 

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header("Access-Control-Allow-Headers: X-Requested-With");
header('Content-Type: application/json');

$product_no= $_POST['txtproduct_no'];
$stmt = $dbh->prepare("DELETE FROM products WHERE product_no = ?");
$result = $stmt->execute([$product_no]);

echo json_encode(['success' => $result]);
?>