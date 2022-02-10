import 'dart:async';

import 'package:order_app/models/tables.dart';
import 'package:order_app/services/db_firestore_api.dart';




class TaBlesEditBloc {
  final DbApi dbApi;
  final bool add;
  TaBles selectedTaBles;


  final StreamController<String> _noteController = StreamController<String>.broadcast();
  Sink<String> get noteEditChanged => _noteController.sink;
  Stream<String> get noteEdit => _noteController.stream;

  final StreamController<String> _saveController = StreamController<String>.broadcast();
  Sink<String> get saveChanged => _saveController.sink;
  Stream<String> get saveTaBles => _saveController.stream;

  TaBlesEditBloc(this.add, this.selectedTaBles, this.dbApi) {
    _startEditListeners().then((finished) => _getTaBles(add, selectedTaBles));
  }

  void dispose() {
    _noteController.close();
    _saveController.close();
  }

  Future<bool> _startEditListeners() async {

    _noteController.stream.listen((note) {
      selectedTaBles.note = note;
    });
    _saveController.stream.listen((action) {
      if (action == 'Save') {
        _saveJournal();
      }
    });
    return true;
  }

  void _getTaBles(bool add, TaBles taBles) {
    if (add) {
      selectedTaBles = TaBles();
      selectedTaBles.note = '';
      selectedTaBles.uid = taBles.uid;
    } else {
      selectedTaBles.note = taBles.note;
    }
    noteEditChanged.add(selectedTaBles.note);
  }

  void _saveJournal() {
    TaBles journal = TaBles(
      documentID: selectedTaBles.documentID,
      note: selectedTaBles.note,
      uid: selectedTaBles.uid,
    );
    add ? dbApi.addTaBles(journal) : dbApi.updateTaBles(journal);
  }
}