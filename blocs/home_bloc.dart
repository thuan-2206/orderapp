import 'dart:async';

import 'package:order_app/models/bill_detail.dart';
import 'package:order_app/models/bill_model.dart';
import 'package:order_app/models/category.dart';
import 'package:order_app/models/food.dart';
import 'package:order_app/models/food_item.dart';
import 'package:order_app/models/report.dart';
import 'package:order_app/models/tables.dart';
import 'package:order_app/services/authenticationApi.dart';
import 'package:order_app/services/db_firestore_api.dart';




class HomeBloc {
  final DbApi dbApi;
  final AuthenticationApi authenticationApi;
  final String idBill;
  final String dateCheckOut;

  final StreamController<List<TaBles>> _taBlesController = StreamController<List<TaBles>>.broadcast();
  Sink<List<TaBles>> get _addTaBlesList => _taBlesController.sink;
  Stream<List<TaBles>> get taBlesList => _taBlesController.stream;

  final StreamController<List<Item>> _itemController = StreamController<List<Item>>.broadcast();
  Sink<List<Item>> get _addItemList => _itemController.sink;
  Stream<List<Item>> get itemList => _itemController.stream;

  final StreamController<List<Category>> _categoryController = StreamController<List<Category>>.broadcast();
  Sink<List<Category>> get _addCategory => _categoryController.sink;
  Stream<List<Category>> get categoryList => _categoryController.stream;

  final StreamController<List<Food>> _foodController = StreamController<List<Food>>.broadcast();
  Sink<List<Food>> get _addFood => _foodController.sink;
  Stream<List<Food>> get foodList => _foodController.stream;

  final StreamController<List<Bill>> _billController = StreamController<List<Bill>>.broadcast();
  Sink<List<Bill>> get _addBill => _billController.sink;
  Stream<List<Bill>> get billList => _billController.stream;

  final StreamController<List<BillPlus>> _billPlusController = StreamController<List<BillPlus>>.broadcast();
  Sink<List<BillPlus>> get _addBillPlus => _billPlusController.sink;
  Stream<List<BillPlus>> get billPlusList => _billPlusController.stream;

  final StreamController<List<Report>> _reportController = StreamController<List<Report>>.broadcast();
  Sink<List<Report>> get _addReport => _reportController.sink;
  Stream<List<Report>> get reportList => _reportController.stream;

  final StreamController<TaBles> _deleteTaBlesController = StreamController<TaBles>.broadcast();
  Sink<TaBles> get xoaBan => _deleteTaBlesController.sink;

  final StreamController<Item> _deleteItemController = StreamController<Item>.broadcast();
  Sink<Item> get deleteItem => _deleteItemController.sink;

  final StreamController<Category> _deleteCategoryController = StreamController<Category>.broadcast();
  Sink<Category> get deleteCategory => _deleteCategoryController.sink;

  final StreamController<Food> _deleteFoodController = StreamController<Food>.broadcast();
  Sink<Food> get deleteFood => _deleteFoodController.sink;

  final StreamController<Bill> _deleteBillController = StreamController<Bill>.broadcast();
  Sink<Bill> get deleteBill => _deleteBillController.sink;

  final StreamController<BillPlus> _deleteBillPlusController = StreamController<BillPlus>.broadcast();
  Sink<BillPlus> get deleteBillPlus => _deleteBillPlusController.sink;

  final StreamController<Report> _deleteReportController = StreamController<Report>.broadcast();
  Sink<Report> get deleteReport => _deleteReportController.sink;

  HomeBloc(this.dbApi, this.authenticationApi, this.idBill, this.dateCheckOut) {
    _startListeners();

  }

  void dispose() {
    _taBlesController.close();
    _deleteTaBlesController.close();
    _itemController.close();
    _deleteItemController.close();
    _categoryController.close();
    _deleteCategoryController.close();
    _foodController.close();
    _deleteFoodController.close();
    _billController.close();
    _deleteBillController.close();
    _billPlusController.close();
    _deleteBillPlusController.close();
    _reportController.close();
    _deleteReportController.close();
  }

  void _startListeners() {
    authenticationApi.getFirebaseAuth().currentUser().then((user) {
      dbApi.taBlesLists(user.uid).listen((tablesList) {
        _addTaBlesList.add(tablesList);
      });

      _deleteTaBlesController.stream.listen((taBles) {
        dbApi.deleteTaBles(taBles);
      });


      dbApi.categoryList(user.uid).listen((categoryList) {
        _addCategory.add(categoryList);
      });

      _deleteCategoryController.stream.listen((category) {
        dbApi.deleteCategory(category);
      });
      dbApi.foodList(user.uid).listen((foodList) {
        _addFood.add(foodList);
      });
      _deleteFoodController.stream.listen((food) {
        dbApi.deleteFood(food);
      });
      dbApi.billList(dateCheckOut).listen((billList) {
        _addBill.add(billList);
      });
      dbApi.billListWeek(dateCheckOut).listen((billList) {
        _addBill.add(billList);
      });
      _deleteBillController.stream.listen((bill) {
        dbApi.deleteBill(bill);
      });
      dbApi.billPlusList(idBill).listen((billPlusList) {
        _addBillPlus.add(billPlusList);
      });
      _deleteBillPlusController.stream.listen((billPlus) {
        dbApi.deleteBillPlus(billPlus);
      });

    });
  }

}