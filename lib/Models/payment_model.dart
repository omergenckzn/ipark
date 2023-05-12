import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {

  DateTime startDate;

  PaymentModel(
      this.startDate, this.endDate, this.carPlateNumber, this.carImageUrl);

  DateTime? endDate;
  String carPlateNumber;
  String carImageUrl;




  factory PaymentModel.fromMap(Map map) {
    Timestamp timestampStart = map['startDate'];
    Timestamp? timestampEnd = map['endDate'];

    return PaymentModel(timestampStart.toDate(), timestampEnd?.toDate(), map['carPlateNumber'], map['carImageUrl']);
  }

}