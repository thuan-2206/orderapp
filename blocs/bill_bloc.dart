import 'dart:async';

import 'package:order_app/models/bill_model.dart';
import 'package:order_app/services/db_firestore_api.dart';

class BillBloc {
  final DbApi dbApi;
  final bool add;
  Bill selectedBill;


  final StreamController<String> _tableController = StreamController<String>.broadcast();
  Sink<String> get tableEditChanged => _tableController.sink;
  Stream<String> get tableEdit => _tableController.stream;


  final StreamController<String> _checkOutController = StreamController<String>.broadcast();
  Sink<String> get checkOutEditChanged => _checkOutController.sink;
  Stream<String> get checkOutEdit => _checkOutController.stream;

  final StreamController<double> _discountController = StreamController<double>.broadcast();
  Sink<double> get discountEditChanged => _discountController.sink;
  Stream<double> get discountEdit => _discountController.stream;

  final StreamController<double> _totalPriceController = StreamController<double>.broadcast();
  Sink<double> get totalPriceEditChanged => _totalPriceController.sink;
  Stream<double> get totalPriceEdit => _totalPriceController.stream;


  final StreamController<String> _saveController = StreamController<String>.broadcast();
  Sink<String> get saveChanged => _saveController.sink;
  Stream<String> get saveBill => _saveController.stream;


  BillBloc(this.add, this.selectedBill, this.dbApi) {
    _startEditListeners().then((finished) => _getBill(add, selectedBill));
  }

  void dispose() {
    _tableController.close();
    _checkOutController.close();
    _discountController.close();
    _totalPriceController.close();
    _saveController.close();
  }

  Future<bool> _startEditListeners() async {

    _tableController.stream.listen((tab) {
      selectedBill.nameTable = tab;
    });

    _checkOutController.stream.listen((checkOut) {
      selectedBill.dateCheckOut = checkOut;
    });

    _discountController.stream.listen((discount) {
      selectedBill.discount = discount;
    });

    _totalPriceController.stream.listen((totalPrice) {
      selectedBill.totalPrice = totalPrice;
    });

    _saveController.stream.listen((action) {
      if (action == 'Save') {
        _saveBill();
      }
    });
    return true;
  }

  void _getBill(bool add, Bill bill) {
    if (add) {
      selectedBill = Bill();
      selectedBill.nameTable = '';
      selectedBill.uid = bill.uid;
      selectedBill.dateCheckOut = DateTime.now().toString();
      selectedBill.discount = 0;
      selectedBill.totalPrice = 0;
    } else {
      selectedBill.nameTable = bill.nameTable;
      selectedBill.dateCheckOut = bill.dateCheckOut;
      selectedBill.discount = bill.discount;
      selectedBill.totalPrice = bill.totalPrice;
    }
    tableEditChanged.add(selectedBill.nameTable);
    checkOutEditChanged.add(selectedBill.dateCheckOut);
    discountEditChanged.add(selectedBill.discount);
    totalPriceEditChanged.add(selectedBill.totalPrice);
  }

  void _saveBill() {
    Bill bill = Bill(
      documentID: selectedBill.documentID,
      nameTable: selectedBill.nameTable,
      uid: selectedBill.uid,
      dateCheckOut: selectedBill.dateCheckOut,
      discount: selectedBill.discount,
      totalPrice: selectedBill.totalPrice,
    );
    add ? dbApi.addBill(bill): dbApi.updateBill(bill);
  }
}