import 'dart:async';
import 'dart:typed_data';

import 'package:order_app/models/category.dart';
import 'package:order_app/models/food.dart';
import 'package:order_app/services/db_firestore_api.dart';

class FoodBloc {


  final DbApi dbApi;
  final bool add;
  Food selectedFood;


  final StreamController<String> _nameController = StreamController<String>.broadcast();
  Sink<String> get nameEditChanged => _nameController.sink;
  Stream<String> get nameEdit => _nameController.stream;


  final StreamController<double> _priceController = StreamController<double>.broadcast();
  Sink<double> get priceEditChanged => _priceController.sink;
  Stream<double> get priceEdit => _priceController.stream;

  final StreamController<String> _idCategoryController = StreamController<String>.broadcast();
  Sink<String> get idCategoryEditChanged => _idCategoryController.sink;
  Stream<String> get idCategoryEdit => _idCategoryController.stream;

  final StreamController<Uint8List> _imageController = StreamController<Uint8List>.broadcast();
  Sink<Uint8List> get imageEditChanged => _imageController.sink;
  Stream<Uint8List> get imageEdit => _imageController.stream;

  final StreamController<String> _saveController = StreamController<String>.broadcast();
  Sink<String> get saveChanged => _saveController.sink;
  Stream<String> get saveFood => _saveController.stream;

  final StreamController<List<String>> _categoryController = StreamController<List<String>>.broadcast();
  Sink<List<String>> get _addCategory => _categoryController.sink;
  Stream<List<String>> get categoryList => _categoryController.stream;

  final StreamController<int> _quantityController = StreamController<int>.broadcast();
  Sink<int> get quantityEditChanged => _quantityController.sink;
  Stream<int> get quantityEdit => _quantityController.stream;



  FoodBloc(this.add, this.selectedFood, this.dbApi) {
    _startEditListeners().then((finished) => _getFood(add, selectedFood));
  }

  void dispose() {
    _nameController.close();
    _priceController.close();
    _idCategoryController.close();
    _imageController.close();
    _saveController.close();
    _categoryController.close();
    _quantityController.close();
  }

  Future<bool> _startEditListeners() async {

    _nameController.stream.listen((name) {
      selectedFood.name = name;
    });
    _priceController.stream.listen((price) {
      selectedFood.price = price;
    });
    _idCategoryController.stream.listen((idCategory) {
      selectedFood.idFoodCategory = idCategory;
    });
   _imageController.stream.listen((image) {
      selectedFood.image = image;
    });
   _quantityController.stream.listen((quantity) {
     selectedFood.quantity = quantity;
   });
    _saveController.stream.listen((action) {
      if (action == 'Save') {
        _saveFood();
      }
    });
    return true;
  }

  void _getFood(bool add, Food food) {
    if (add) {
      selectedFood = Food();
      selectedFood.name = '';
      selectedFood.price = 0;
      selectedFood.idFoodCategory = '';
      selectedFood.image = null;
      selectedFood.uid = food.uid;
      selectedFood.quantity = 0;
    } else {
      selectedFood.name = food.name;
      selectedFood.price = food.price;
      selectedFood.idFoodCategory = food.idFoodCategory;
      selectedFood.image = food.image;
      selectedFood.quantity = food.quantity;
    }
    nameEditChanged.add(selectedFood.name);
    priceEditChanged.add(selectedFood.price);
    idCategoryEditChanged.add(selectedFood.idFoodCategory);
    imageEditChanged.add(selectedFood.image);
    quantityEditChanged.add(selectedFood.quantity);
  }

  void _saveFood() {
    Food food = Food(
      documentID: selectedFood.documentID,
      name: selectedFood.name,
      price: selectedFood.price,
      uid: selectedFood.uid,
      idFoodCategory: selectedFood.idFoodCategory,
      image: selectedFood.image,
      quantity: selectedFood.quantity,
    );
    add ? dbApi.addFood(food) : dbApi.updateFood(food);
  }
}