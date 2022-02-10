
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:order_app/models/tables.dart';
import 'package:order_app/models/food.dart';

class Bill {
  String documentID;
  String uid;
  String nameTable;
  String dateCheckOut;
  double discount;
  double totalPrice;
  TaBles table;

  Bill({
    this.documentID,
    this.uid,
    this.nameTable,
    this.dateCheckOut,
    this.discount,
    this.totalPrice,
    this.table,
  });

  /*factory Bill.fromDoc(dynamic doc) => Bill(
    documentID: doc.documentID,
    uid: doc["uid"],
    nameTable: doc["nameTable"],
    dateCheckOut: DateTime.parse(doc["dateCheckOut"]),
    discount: double.parse(doc["discount"]),
    totalPrice: double.parse(doc["totalPrice"]),
  );*/

  Bill.fromDoc(dynamic doc){
    this.documentID = doc.documentID;
    this.uid = doc["uid"];
    this.nameTable = doc["nameTable"];
    this.dateCheckOut = doc["dateCheckOut"];
    this.discount = doc["discount"];
    this.totalPrice = doc["totalPrice"];
    //this.taBles.addFoods(_foods)

  }


}