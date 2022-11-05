class Product_search {
  final String product_no;
  final String product_name;
  final dynamic amount;
  final String photo;
  Product_search({
    required this.product_no,
    required this.product_name,
    required this.amount,
    required this.photo
  });
  factory Product_search.fromJson(Map<String, dynamic> json) {
    return Product_search(
      product_no: json['product_no'],
      product_name: json['product_name'],
      amount: json['amount'],
      photo: json['photo'],
     );
  }
  Map<String, dynamic> toJson() => {
    'product_no': product_no,
    'product_name': product_name,
    'amount': amount,
    'photo': photo,
  };
}
class Env_s {
<<<<<<< HEAD
 //static String URL_PREFIX = "http://192.168.43.16/Qr_code_payment_system/restuarant";
 static String URL_PREFIX = "https://qrcode.leastpayproject.com.ng/restuarant";
  //static String URL_PREFIX = "https://qrcode.americanlandbank.org/restuarant";

}
=======
 static String URL_PREFIX = "http://192.168.43.16/Qr_code_payment_system/restuarant";
 // static String URL_PREFIX = "https://qrcode.leastpayproject.com.ng/restuarant";
}
>>>>>>> 40733bf7a178cb778e698a205b9341ace1d421f4
