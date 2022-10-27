<?php 
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header("Access-Control-Allow-Headers: X-Requested-With");
header('Content-Type: application/json');
include "db.php";
header('Content-Type: application/json');

$query=$_GET['query'];
$username=$_GET['username'];

$stmt = $dbh->prepare("SELECT * FROM products WHERE (`product_no` LIKE '%".$query."%') OR (`amount` LIKE '%".$query."%') OR (`product_name` LIKE '%".$query."%') AND username='$username'");
$stmt->execute();
$result = $stmt->fetchAll(PDO::FETCH_ASSOC);
echo json_encode($result);
?>