class User {

  final int ID;
  final String company_name;
  final String username;
  final String password;
  final String phone;
  final String address;
  final String fullname;
  final dynamic balance;
  final String photo;


  User({
    required this.ID,
    required this.company_name,
    required this.username,
    required this.password,
    required this.phone,
    required this.address,
    required this.fullname,
    required this.balance,
    required this.photo,

  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      ID: json['ID'],
      company_name: json['company_name'],
      username: json['username'],
      password: json['password'],
      phone: json['phone'],
      address: json['address'],
      fullname: json['fullname'],
      balance: json['balance'],
      photo: json['photo'],
    );
  }
  Map<String, dynamic> toJson() => {
    'ID': ID, 'company_name': company_name,    'username': username,    'password': password,    'phone': phone,    'address': address,    'fullname': fullname,
    'balance': balance,'photo': photo,

  };
}
class Env {
  static String URL_PREFIX = "http://192.168.43.16/Qr_code_payment_system/restuarant";
//static String URL_PREFIX = "https://qrcode.leastpayproject.com.ng/restuarant";
}