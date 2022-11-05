<?php 
require_once('db.php'); 
//error_reporting(0);

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header("Access-Control-Allow-Headers: X-Requested-With");

$username = $_POST['txtusername'] ?? '';
$fullname = $_POST['txtfullname'] ?? '';
$password = $_POST['txtpassword'] ?? '';
$restaurant = $_POST['txtrestaurant'] ?? '';
$phone = $_POST['txtphone']?? '';
$address = $_POST['txtaddress']?? '';
//$photo = $_POST['photo']?? '';

date_default_timezone_set('Africa/Lagos');
$current_date = date('Y-m-d');

//check if username already exist
$stmt = $dbh->prepare("SELECT * FROM users WHERE username=?");
$stmt->execute([$username]); 
$user = $stmt->fetch();
if ($user) {
echo json_encode("User Already Exist");
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

    
//save user details
$query = "
INSERT INTO users (company_name, username,password, fullname,phone, address,photo) VALUES (:restaurant, :username, :password,:fullname, :phone,:address,:photo)";

$user_data = array(
 ':restaurant'  => $restaurant,
 ':username'   => $username,
  ':password'   => $password,
  ':fullname'   => $fullname,
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