import 'package:order_app/models/bill_detail.dart';
import 'package:order_app/models/bill_model.dart';
import 'package:order_app/models/category.dart';
import 'package:order_app/models/food.dart';
import 'package:order_app/models/food_item.dart';
import 'package:order_app/models/report.dart';
import 'package:order_app/models/tables.dart';

abstract class DbApi {
  Stream<List<TaBles>> taBlesLists(String uid);
  Future<TaBles> getTaBles(String documentID);
  Future<bool> addTaBles(TaBles taBles);
  void updateTaBles(TaBles taBles);
  //void updateTaBlesWithTransaction(TaBles taBles);
  void deleteTaBles(TaBles taBles);
  //Category///////
  Stream<List<Category>> categoryList(String uid);
  Future<Category> getCategory(String documentID);
  Future<bool> addCategory(Category category);
  void updateCategory(Category category);
  //void updateCategoryWithTransaction(Category category);
  void deleteCategory(Category category);
  //Food//////////
  Stream<List<Food>> foodList(String uid);
  Future<Food> getFood(String documentID);
  Future<bool> addFood(Food food);
  void updateFood(Food food);
  //void updateFoodWithTransaction(Food food);
  void deleteFood(Food food);
  //Bill///////////
  Stream<List<Bill>> billList(String uid);
  Stream<List<Bill>> billListWeek(String uid);
  Future<Bill> getBill(String documentID);
  Future<bool> addBill(Bill bill);
  void updateBill(Bill bill);
  //void updateBillWithTransaction(Bill bill);
  void deleteBill(Bill bill);
  //Bill_detail////
  Stream<List<BillPlus>> billPlusList(String uid);
  Future<BillPlus> getBillPlus(String documentID);
  Future<bool> addBillPlus(BillPlus billPlus);
  void updateBillPlus(BillPlus billPlus);
  //void updateBillPlusWithTransaction(BillPlus billPlus);
  void deleteBillPlus(BillPlus billPlus);
  //Report/////////////
  Stream<List<Report>> reportList(String uid);
  Future<Report> getReport(String documentID);
  Future<bool> addReport(Report report);
  void updateReport(Report report);
  //void updateReportWithTransaction(Report report);
  void deleteReport(Report report);
}