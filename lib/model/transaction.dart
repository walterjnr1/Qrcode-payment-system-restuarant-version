
class Transaction {
  final String paymentID;
  final String customer_email;
  final String restuarant;
  final String amount;
  final String date_payment;

  Transaction({
    required this.paymentID,
    required this.customer_email,
    required this.restuarant,
    required this.amount,
    required this.date_payment,

  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      paymentID: json['paymentID'],
      customer_email: json['customer_email'],
      restuarant: json['restuarant'],
      amount: json['amount'],
      date_payment: json['date_payment'],

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'paymentID': paymentID,
      'customer_email': customer_email,
      'restuarant': restuarant,
      'amount': amount,
      'date_payment': date_payment,
    };
  }

  Map<String, dynamic> toJson() => {
    'paymentID': paymentID,    'customer_email': customer_email,    'restuarant': restuarant,   'amount': amount,  'date_payment': date_payment,  };
}
class Env {
  //static String URL_PREFIX = "http://192.168.43.16/Qr_code_payment_system/restuarant";
static String URL_PREFIX = "https://qrcode.leastpayproject.com.ng/restuarant";
  //static String URL_PREFIX = "https://qrcode.americanlandbank.org/restuarant";


}
