
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:order_app/blocs/home_bloc_provider.dart';
import 'package:order_app/models/food.dart';
import 'package:order_app/services/db_firestore_api.dart';

import 'bill_detail.dart';

class TaBles {
  String documentID;
  String note;
  String uid;
  int status;
  List<Food> foods;
  DateTime dateCheckIn;
  int chess;

 TaBles({
    this.documentID,
    this.note,
    this.uid,
    this.status,
    this.foods,
    this.dateCheckIn,
   this.chess,
  });



  TaBle(TaBles clone) {
    this.documentID = clone.documentID;
    this.uid = clone.uid;
    this.note = clone.note;
    this.status = clone.status;
    this.foods = clone.foods.map((food) => food).toList();
    this.dateCheckIn = clone.dateCheckIn;
    this.chess = clone.chess;
  }

  factory TaBles.fromDoc(dynamic doc) => TaBles(
      documentID: doc.documentID,
      note: doc["note"],
      uid: doc["uid"],
      status: doc["_status"],
      foods: List<Food>(),
    chess: doc["_chess"],

  );
  /*TaBles.fromDoc(dynamic doc){
    this.documentID = doc.documentID;
    this.uid = doc["uid"];
    this.note = doc["note"];
    this.status = doc["status"];
    this.foods = List<Food>();
  }*/



  List<Food> get fooda {
    if (foods == null) foods = List<Food>();
    return foods;
  }

  void addFoods(Future<List<Food>> _foods) async {
    // Add BillDetail for table
    this.fooda.addAll(await _foods);
  }

  List<Food> combineFoods(List<Food> _menuFoods) {
    List<Food> menuFoods = List<Food>.from(_menuFoods);

    if (fooda != null)
      for (var i = 0; i < fooda.length; i++) {
        for (var j = 0; j < menuFoods.length; j++) {
          if (fooda[i].documentID == menuFoods[j].documentID) {
            menuFoods[j] = fooda[i];
            break;
          }
        }
      }

    return menuFoods;
  }

  void addFood(Food food) {
    // Check food exists in foods
    // exists: update food, not exists: add to foods
    int k = 1;
    int index = findIndexFood(food);
    if (index == -1) {
      //add to foods
      Food _food =  food..quantity = 1;
      fooda.add(_food);
    } else {
      k++;
      // update food
      fooda[index].quantity++;
    }

    if (fooda.isNotEmpty) {
      this.status = 1;
    }

    if (this.dateCheckIn == null) {
      this.dateCheckIn = DateTime.now();
    }
  }

  bool addBillPlus(Food food){
    int index = findIndexFood(food);
    if(index == -1){
      return true;
    }
    else{
      return false;
    }
  }

  void subFood(Food food) {
    int index = findIndexFood(food);
    if (index != -1) {
      if (fooda[index].quantity > 1) {
        fooda[index].quantity--;
      } else {
        deleteFood(fooda[index]);
      }
    }

    if (fooda.isEmpty) {
      this.status = -1;
    }
  }

  void deleteFood(Food food) {
    int index = findIndexFood(food);
    if (index != -1) {
      fooda.remove(fooda[index]);
    }

    if (fooda.isEmpty) {
      this.status = -1;
    }
  }

  int findIndexFood(Food food) {
    if (fooda != null)
      for (var i = 0; i < fooda.length; i++) {
        if (food.documentID == fooda[i].documentID) {
          return i;
        }
      }
    return -1;
  }

  double getTotalPrice() {
    double totalPrice = 0.0;

    for (var food in fooda) {
      totalPrice += food.price * food.quantity;
    }

    return totalPrice;
  }




}