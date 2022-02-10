import 'dart:async';

import 'package:order_app/models/category.dart';
import 'package:order_app/services/db_firestore_api.dart';

class CategoryEditBloc {
  final DbApi dbApi;
  final bool add;
  Category selectedCategory;


  final StreamController<String> _nameController = StreamController<String>.broadcast();
  Sink<String> get nameEditChanged => _nameController.sink;
  Stream<String> get nameEdit => _nameController.stream;


  final StreamController<String> _saveController = StreamController<String>.broadcast();
  Sink<String> get saveChanged => _saveController.sink;
  Stream<String> get saveCategory => _saveController.stream;


  CategoryEditBloc(this.add, this.selectedCategory, this.dbApi) {
    _startEditListeners().then((finished) => _getCategory(add, selectedCategory));
  }

  void dispose() {
    _nameController.close();
    _saveController.close();
  }

  Future<bool> _startEditListeners() async {

    _nameController.stream.listen((name) {
      selectedCategory.name = name;
    });
    _saveController.stream.listen((action) {
      if (action == 'Save') {
        _saveCategory();
      }
    });
    return true;
  }

  void _getCategory(bool add, Category category) {
    if (add) {
      selectedCategory = Category();
      selectedCategory.name = '';
      selectedCategory.uid = category.uid;
    } else {
      selectedCategory.name = category.name;
    }
    nameEditChanged.add(selectedCategory.name);
  }

  void _saveCategory() {
    Category category = Category(
      documentID: selectedCategory.documentID,
      name: selectedCategory.name,
      uid: selectedCategory.uid,
    );
    add ? dbApi.addCategory(category) : dbApi.updateCategory(category);
  }
}