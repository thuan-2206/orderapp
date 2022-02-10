import 'dart:async';
import 'package:order_app/models/bill_detail.dart';
import 'package:order_app/services/db_firestore_api.dart';

class BillPlusBloc {
  final DbApi dbApi;
  final bool add;
  BillPlus selectedBill;



  final StreamController<String> _foodNameController = StreamController<String>.broadcast();
  Sink<String> get foodNameEditChanged => _foodNameController.sink;
  Stream<String> get foodNameEdit => _foodNameController.stream;


  final StreamController<int> _numFoodController = StreamController<int>.broadcast();
  Sink<int> get numFoodEditChanged => _numFoodController.sink;
  Stream<int> get numFoodEdit => _numFoodController.stream;

  final StreamController<double> _priceController = StreamController<double>.broadcast();
  Sink<double> get priceEditChanged => _priceController.sink;
  Stream<double> get priceEdit => _priceController.stream;

  final StreamController<String> _idBillController = StreamController<String>.broadcast();
  Sink<String> get idBillEditChanged => _idBillController.sink;
  Stream<String> get idBillEdit => _idBillController.stream;


  final StreamController<String> _saveController = StreamController<String>.broadcast();
  Sink<String> get saveChanged => _saveController.sink;
  Stream<String> get saveBill => _saveController.stream;



  BillPlusBloc(this.add, this.selectedBill, this.dbApi) {
    _startEditListeners().then((finished) => _getBill(add, selectedBill));
  }

  void dispose() {
    _foodNameController.close();
    _numFoodController.close();
    _priceController.close();
    _idBillController.close();
    _saveController.close();
  }

  Future<bool> _startEditListeners() async {

    _foodNameController.stream.listen((foodName) {
      selectedBill.foodName = foodName;
    });
    _numFoodController.stream.listen((numFood) {
      selectedBill.numFood = numFood;
    });
    _priceController.stream.listen((price) {
      selectedBill.price = price;
    });
    _idBillController.stream.listen((idBill) {
      selectedBill.idBill = idBill;
    });


    _saveController.stream.listen((action) {
      if (action == 'Save') {
        _saveBill();
      }
    });
    return true;
  }

  void _getBill(bool add, BillPlus billPlus) {
    if (add) {
      selectedBill = BillPlus();
      selectedBill.uid = billPlus.uid;
      selectedBill.foodName = '';
      selectedBill.numFood = 0;
      selectedBill.price = 0;
      selectedBill.idBill = '';
    } else {
      selectedBill.foodName = billPlus.foodName;
      selectedBill.numFood = billPlus.numFood;
      selectedBill.price = billPlus.price;
      selectedBill.idBill = billPlus.idBill;
    }
    foodNameEditChanged.add(selectedBill.foodName);
    numFoodEditChanged.add(selectedBill.numFood);
    priceEditChanged.add(selectedBill.price);
    idBillEditChanged.add(selectedBill.idBill);
  }

  void _saveBill() {
    BillPlus billPlus = BillPlus(
      documentID: selectedBill.documentID,
      uid: selectedBill.uid,
      foodName: selectedBill.foodName,
      numFood: selectedBill.numFood,
      price: selectedBill.price,
      idBill: selectedBill.idBill,
    );
    add ? dbApi.addBillPlus(billPlus): dbApi.updateBillPlus(billPlus);
  }
}