<?php 
require_once('db.php'); 
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header("Access-Control-Allow-Headers: X-Requested-With");

$digits = 4;
$product_no=rand(pow(10, $digits-1), pow(10, $digits)-1);

$name = $_POST['txtname'] ?? '';
$amt = $_POST['txtamt'] ?? '';

$username = $_POST['username'] ?? '';

date_default_timezone_set('Africa/Lagos');
$current_date = date('Y-m-d');

//check if product already exist
$stmt = $dbh->prepare("SELECT * FROM products WHERE product_name=? and username=?");
$stmt->execute([$name,$username]); 
$user = $stmt->fetch();
if ($user) {
echo json_encode("Product Already Exist");
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
INSERT INTO products (product_no,username,product_name, amount,photo) VALUES (:product_no,:username,:product_name, :amount,:photo)";
$product_data = array(
 ':product_no'  => $product_no,
 ':username'  => $username,
 ':product_name'  => $name,
 ':amount'   => $amt,
  ':photo'  => $image
 );
 
$statement = $dbh->prepare($query);
if($statement->execute($product_data)) {

echo json_encode("success");
} else {
echo json_encode("Something Went Wrong");
}
}
?>