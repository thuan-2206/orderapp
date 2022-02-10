import 'package:order_app/models/bill_model.dart';
import 'package:order_app/models/tables.dart';

class BillPlus{
  String documentID;
  String uid;
  String foodName;
  int numFood;
  double price;
  String idBill;

  BillPlus({
    this.documentID,
    this.uid,
    this.numFood,
    this.foodName,
    this.price,
    this.idBill
  });

  BillPlus.fromDoc(dynamic doc){
    this.documentID = doc.documentID;
    this.uid = doc["uid"];
    this.foodName = doc["foodName"];
    this.numFood = doc["numFood"];
    this.price = doc["price"];
    this.idBill = doc["idBill"];
  }

}