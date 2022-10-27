<?php 
require_once('db.php'); 
//error_reporting(0);

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header("Access-Control-Allow-Headers: X-Requested-With");

$email = $_POST['txtemail'] ?? '';
$cust_name = $_POST['txtcust_name'] ?? '';
$password = $_POST['txtpassword'] ?? '';
$phone = $_POST['txtphone']?? '';
$address = $_POST['txtaddress']?? '';


date_default_timezone_set('Africa/Lagos');
$current_date = date('Y-m-d');

//check if email already exist
$stmt = $dbh->prepare("SELECT * FROM customers WHERE email=?");
$stmt->execute([$email]); 
$user = $stmt->fetch();
if ($user) {
echo json_encode("Email Address Already Exist");
}else{

    //get image name
    $image = $_FILES['image']['name'] ?? ''; 

    //create date now
    $date = date('Y-m-d');

    //make image path
    $imagePath = 'uploads/'.$image; 

    $tmp_name = $_FILES['image']['tmp_name']; 

    //move image to images folder
    move_uploaded_file($tmp_name, $imagePath);
    $image = "uploads/" .$_FILES['image']['name'] ; 

    
//save customers details
$query = "
INSERT INTO customers (cust_name,email,password,phone, address,photo) VALUES (:cust_name,:email, :password, :phone,:address,:photo)";

$user_data = array(
    ':cust_name'   => $cust_name,
 ':email'   => $email,
  ':password'   => $password,
 ':phone'   => $phone,
  ':address'  => $address,
  ':photo'  => $image
 );
 
$statement = $dbh->prepare($query);
if($statement->execute($user_data)) {

echo json_encode("success");
} else {
echo json_encode("Something Went Wrong");
}
}
?>