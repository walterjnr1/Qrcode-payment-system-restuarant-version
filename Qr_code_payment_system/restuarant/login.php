<?php 
require_once('db.php'); 

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header("Access-Control-Allow-Headers: X-Requested-With");

$username = $_POST['txtusername'];
$password = $_POST['txtpassword'];

$sql = "SELECT * FROM `users` WHERE `username`=? AND `password`=?";
			$query = $dbh->prepare($sql);
			$query->execute(array($username,$password));
			$row = $query->rowCount();
			$fetch = $query->fetch();
			if($row > 0) {
echo json_encode("Success");
}else { 
echo json_encode("Wrong Username and Password");
}
?>



