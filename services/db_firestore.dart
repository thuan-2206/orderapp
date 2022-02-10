import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_app/models/bill_detail.dart';
import 'package:order_app/models/bill_model.dart';
import 'package:order_app/models/category.dart';
import 'package:order_app/models/food.dart';
import 'package:order_app/models/food_item.dart';
import 'package:order_app/models/report.dart';
import 'package:order_app/models/tables.dart';
import 'db_firestore_api.dart';


class DbFirestoreService implements DbApi {
  final Firestore _firestore = Firestore.instance;
  final String _collectionTaBles = 'taBles';
  final String _collectionCategory = 'category';
  final String _collectionFood = 'food';
  final String _collectionBill = 'bill';
  final String _collectionBillPlus = 'billPlus';
  final String _collectionReport = 'report';

  DbFirestoreService() {
    _firestore.settings(timestampsInSnapshotsEnabled: true);
  }

  Stream<List<TaBles>> taBlesLists(String uid) {
    return _firestore
        .collection(_collectionTaBles)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<TaBles> _listTaBles = snapshot.documents.map((doc) => TaBles.fromDoc(doc)).toList();
      return _listTaBles;
    });
  }



  Future<TaBles> getTaBles(String documentID) {
    return _firestore
        .collection(_collectionTaBles)
        .document(documentID)
        .get()
        .then((documentSnapshot) {
      return TaBles.fromDoc(documentSnapshot);
    });
  }



  Future<bool> addTaBles(TaBles taBles) async {
    DocumentReference _documentReference =
    await _firestore.collection(_collectionTaBles).add({
      'note': taBles.note,
      'uid': taBles.uid,
    });
    return _documentReference.documentID != null;
  }



  void updateTaBles(TaBles taBles) async {
    await _firestore
        .collection(_collectionTaBles)
        .document(taBles.documentID)
        .updateData({
      'note': taBles.note,
    })
        .catchError((error) => print('Error updating: $error'));
  }



  /*void updateTaBlesWithTransaction(TaBles taBles) async {
    DocumentReference _documentReference = _firestore.collection(_collectionTaBles).document(taBles.documentID);
    var taBlesData = {
      'note': taBles.note,
    };
    _firestore.runTransaction((transaction) async {
      await transaction
          .update(_documentReference, taBlesData)
          .catchError((error) => print('Error updating: $error'));
    });
  }*/



  void deleteTaBles(TaBles taBles) async {
    await _firestore
        .collection(_collectionTaBles)
        .document(taBles.documentID)
        .delete()
        .catchError((error) => print('Error deleting: $error'));
  }



  Stream<List<Category>> categoryList(String uid){
    return _firestore
        .collection(_collectionCategory)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Category> _listCategory = snapshot.documents.map((doc) => Category.fromDoc(doc)).toList();
      return _listCategory;
    });
  }

  Future<Category> getCategory(String documentID){
    return _firestore
        .collection(_collectionCategory)
        .document(documentID)
        .get()
        .then((documentSnapshot) {
      return Category.fromDoc(documentSnapshot);
    });
  }
  Future<bool> addCategory(Category category) async {
    DocumentReference _documentReference =
        await _firestore.collection(_collectionCategory).add({
      'name': category.name,
      'uid': category.uid,
    });
    return _documentReference.documentID != null;
  }
  void updateCategory(Category category) async{
    await _firestore
        .collection(_collectionCategory)
        .document(category.documentID)
        .updateData({
      'name': category.name,
    })
        .catchError((error) => print('Error updating: $error'));
  }
 /*void updateCategoryWithTransaction(Category category) async{
    DocumentReference _documentReference = _firestore.collection(_collectionCategory).document(category.documentID);
    var categoryData = {
      'name': category.name,
    };
    _firestore.runTransaction((transaction) async {
      await transaction
          .update(_documentReference, categoryData)
          .catchError((error) => print('Error updating: $error'));
    });
  }*/
  void deleteCategory(Category category) async{
    await _firestore
        .collection(_collectionCategory)
        .document(category.documentID)
        .delete()
        .catchError((error) => print('Error deleting: $error'));
  }

  Stream<List<Food>> foodList(String uid){
    return _firestore
        .collection(_collectionFood)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Food> _listFood = snapshot.documents.map((doc) => Food.fromDoc(doc)).toList();
      return _listFood;
    });
  }
  Future<Food> getFood(String documentID){
    return _firestore
        .collection(_collectionFood)
        .document(documentID)
        .get()
        .then((documentSnapshot) {
      return Food.fromDoc(documentSnapshot);
    });
  }
  Future<bool> addFood(Food food) async{
    DocumentReference _documentReference =
        await _firestore.collection(_collectionFood).add({
          'name': food.name,
          'uid': food.uid,
          'idFoodCategory': food.idFoodCategory,
          'price': food.price,
          'idImage': food.idImage,
          'image': food.image,
        });
    return _documentReference.documentID != null;
  }
  void updateFood(Food food) async{
    await _firestore
        .collection(_collectionFood)
        .document(food.documentID)
        .updateData({
      'name': food.name,
      'idFoodCategory': food.idFoodCategory,
      'price': food.price,
      'image': food.image,
    })
        .catchError((error) => print('Error updating: $error'));
  }
  /*void updateFoodWithTransaction(Food food){
    DocumentReference _documentReference = _firestore.collection(_collectionFood).document(food.documentID);
    var foodData = {
      'name': food.name,
      'idFoodCategory': food.idFoodCategory,
      'price': food.price,
      'image': food.image,
    };
    _firestore.runTransaction((transaction) async {
      await transaction
          .update(_documentReference, foodData)
          .catchError((error) => print('Error updating: $error'));
    });
  }*/
  void deleteFood(Food food) async{
    await _firestore
        .collection(_collectionFood)
        .document(food.documentID)
        .delete()
        .catchError((error) => print('Error deleting: $error'));
  }


  Stream<List<Bill>> billList(String uid){
    return _firestore
        .collection(_collectionBill)
        .where('dateCheckOut', isGreaterThan: uid).orderBy('dateCheckOut')
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Bill> _listBill = snapshot.documents.map((doc) => Bill.fromDoc(doc)).toList();
      return _listBill;
    });
  }
  Stream<List<Bill>> billListWeek(String uid){
    return _firestore
        .collection(_collectionBill)
        .where('dateCheckOut', isGreaterThan: uid).orderBy('dateCheckOut')
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Bill> _listBill = snapshot.documents.map((doc) => Bill.fromDoc(doc)).toList();
      return _listBill;
    });
  }
  Future<Bill> getBill(String documentID){
    return _firestore
        .collection(_collectionBill)
        .document(documentID)
        .get()
        .then((documentSnapshot) {
      return Bill.fromDoc(documentSnapshot);
    });
  }
  Future<bool> addBill(Bill bill) async{
    DocumentReference _documentReference =
    await _firestore.collection(_collectionBill).add({
      'uid': bill.uid,
      'nameTable': bill.nameTable,
      'dateCheckOut': bill.dateCheckOut,
      'discount': bill.discount,
      'totalPrice': bill.totalPrice,
    });
    return _documentReference.documentID != null;
  }

  void updateBill(Bill bill) async{
    await _firestore
        .collection(_collectionBill)
        .document(bill.documentID)
        .updateData({
      'nameTable': bill.nameTable,
      'discount': bill.discount,
      'totalPrice': bill.totalPrice,
      'dateCheckOut': bill.dateCheckOut,
    })
        .catchError((error) => print('Error updating: $error'));
  }
  /*void updateBillWithTransaction(Bill bill){
    DocumentReference _documentReference = _firestore.collection(_collectionBill).document(bill.documentID);
    var billData = {
      'nameTable': bill.nameTable,
      'discount': bill.discount,
      'totalPrice': bill.totalPrice,
      'dateCheckOut': bill.dateCheckOut,
    };
    _firestore.runTransaction((transaction) async {
      await transaction
          .update(_documentReference, billData)
          .catchError((error) => print('Error updating: $error'));
    });
  }*/

  void deleteBill(Bill bill) async{
    await _firestore
        .collection(_collectionBill)
        .document(bill.documentID)
        .delete()
        .catchError((error) => print('Error deleting: $error'));
  }

  Stream<List<BillPlus>> billPlusList(String uid){
    return _firestore
        .collection(_collectionBillPlus)
        .where('idBill', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<BillPlus> _listBillPlus = snapshot.documents.map((doc) => BillPlus.fromDoc(doc)).toList();
      return _listBillPlus;
    });
  }

  Future<BillPlus> getBillPlus(String documentID){
    return _firestore
        .collection(_collectionBillPlus)
        .document(documentID)
        .get()
        .then((documentSnapshot) {
      return BillPlus.fromDoc(documentSnapshot);
    });
  }

  Future<bool> addBillPlus(BillPlus billPlus) async{
    DocumentReference _documentReference =
    await _firestore.collection(_collectionBillPlus).add({
      'uid': billPlus.uid,
      'foodName': billPlus.foodName,
      'numFood': billPlus.numFood,
      'price': billPlus.price,
      'idBill': billPlus.idBill,
    });
    return _documentReference.documentID != null;
  }

  void updateBillPlus(BillPlus billPlus) async{
    await _firestore
        .collection(_collectionBillPlus)
        .document(billPlus.documentID)
        .updateData({
      'foodName': billPlus.foodName,
      'numFood': billPlus.numFood,
      'price': billPlus.price,
      'idBill': billPlus.idBill,
    })
        .catchError((error) => print('Error updating: $error'));
  }

  /*void updateBillPlusWithTransaction(BillPlus billPlus){
    DocumentReference _documentReference = _firestore.collection(_collectionBillPlus).document(billPlus.documentID);
    var billData = {
      'price': billPlus.price,
      'foodName': billPlus.foodName,
      'numFood': billPlus.numFood,
      'idBill': billPlus.idBill,
    };
    _firestore.runTransaction((transaction) async {
      await transaction
          .update(_documentReference, billData)
          .catchError((error) => print('Error updating: $error'));
    });
  }*/

  void deleteBillPlus(BillPlus billPlus) async{
    await _firestore
        .collection(_collectionBillPlus)
        .document(billPlus.documentID)
        .delete()
        .catchError((error) => print('Error deleting: $error'));
  }

  Stream<List<Report>> reportList(String uid){
    return _firestore
        .collection(_collectionReport)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Report> _listReport = snapshot.documents.map((doc) => Report.fromDoc(doc)).toList();
      return _listReport;
    });
  }
  Future<Report> getReport(String documentID){
    return _firestore
        .collection(_collectionReport)
        .document(documentID)
        .get()
        .then((documentSnapshot) {
      return Report.fromDoc(documentSnapshot);
    });
  }
  Future<bool> addReport(Report report) async{
    DocumentReference _documentReference =
        await _firestore.collection(_collectionReport).add({
      'uid': report.uid,
      'day': report.day,
      'totalPrice': report.totalPrice,
    });
    return _documentReference.documentID != null;
  }
  void updateReport(Report report) async{
    await _firestore
        .collection(_collectionReport)
        .document(report.documentID)
        .updateData({
      'day': report.day,
      'totalPrice': report.totalPrice,
    })
        .catchError((error) => print('Error updating: $error'));
  }
  /*void updateReportWithTransaction(Report report){
    DocumentReference _documentReference = _firestore.collection(_collectionReport).document(report.documentID);
    var reportData = {
      'day': report.day,
      'totalPrice': report.totalPrice,
    };
    _firestore.runTransaction((transaction) async {
      await transaction
          .update(_documentReference, reportData)
          .catchError((error) => print('Error updating: $error'));
    });
  }*/
  void deleteReport(Report report) async{
    await _firestore
        .collection(_collectionReport)
        .document(report.documentID)
        .delete()
        .catchError((error) => print('Error deleting: $error'));
  }
}



