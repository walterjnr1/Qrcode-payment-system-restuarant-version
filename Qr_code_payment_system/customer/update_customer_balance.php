<?php 
require_once('db.php'); 
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header("Access-Control-Allow-Headers: X-Requested-With");
header('Content-Type: application/json');


date_default_timezone_set('Africa/Lagos');
$current_date = date('Y-m-d');

$email = $_GET['email'];
$amt = $_GET['amt'];

//$amt = 3000;
//$email = 'newleastpaysolution@gmail.com';

//update customer current bal
$stmt = $dbh->prepare("UPDATE customers SET balance = (balance) - ? WHERE email = ?");
$result =  $stmt->execute([$amt,$email]);
echo json_encode(['success' => $result]);


$username = $_GET['username'];
$amt_user = $_GET['amt_user'];
//update user/restaurant current bal
$stmt = $dbh->prepare("UPDATE users SET balance = (balance) + ? WHERE username = ?");
$result =  $stmt->execute([$amt_user,$username]);
echo json_encode(['success' => $result]);

//get resturant name
$sql = "SELECT * FROM users WHERE username = :username";
$query = $dbh -> prepare($sql);
$query -> bindParam(':username', $username, PDO::PARAM_STR);

//$username = 'walterjnr1';
$query -> execute();
$results = $query -> fetchAll(PDO::FETCH_OBJ);
if($query -> rowCount() > 0)
{
foreach($results as $result)
{
$restuarant_name=$result -> company_name;
//echo $result -> company_name . ", ";

}
}

//save to payment records
$digits = 5;
$paymentID=rand(pow(10, $digits-1), pow(10, $digits)-1);

$sql = 'INSERT INTO payments(paymentID,owner_username,customer_email,restuarant, amount,date_payment) VALUES(:paymentID,:owner_username,:customer_email,:restuarant, :amount,:date_payment)';
$statement = $dbh->prepare($sql);
$statement->execute([
    ':paymentID'  => $paymentID,
    ':owner_username'  => $username,
    ':customer_email'  => $email,
    ':restuarant'  => $restuarant_name,
    ':amount'   => $amt_user,
     ':date_payment'  => $current_date]);

$payment_id = $dbh->lastInsertId();
?>
