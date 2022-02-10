import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_app/blocs/CategoryEditBloc.dart';
import 'package:order_app/blocs/category_edit_bloc_provider.dart';
import 'package:order_app/blocs/home_bloc.dart';
import 'package:order_app/blocs/home_bloc_provider.dart';
import 'package:order_app/models/category.dart';

class EditCategory extends StatefulWidget{
  EditCategoryState createState() => EditCategoryState();
}

class EditCategoryState extends State<EditCategory>{
  TextEditingController _nameController;
  CategoryEditBloc _categoryEditBloc;


  @override
  void initState() {
    _nameController = TextEditingController();
    _nameController.text = '';
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _categoryEditBloc = CategoryEditBlocProvider.of(context).categoryEditBloc;
  }

  @override
  dispose() {
    _nameController.dispose();
    _categoryEditBloc.dispose();
    super.dispose();
  }

  void _addOrUpdateCategory() {
    _categoryEditBloc.saveChanged.add('Save');
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {

    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm danh mục món', style: TextStyle(color: Colors.lightGreen.shade800),),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.lightGreen.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                stream: _categoryEditBloc.nameEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  // Use the copyWith to make sure when you edit TextField the cursor does not bounce to the first character
                  _nameController.value = _nameController.value.copyWith(text: snapshot.data);
                  return TextField(
                    controller: _nameController,
                    textInputAction: TextInputAction.newline,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: 'Tên loại món ăn',
                      icon: Icon(Icons.subject),
                    ),
                    maxLines: null,
                    onChanged: (name) => _categoryEditBloc.nameEditChanged.add(name),
                  );
                },
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text('Đóng'),
                    color: Colors.grey.shade100,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 8.0),
                  FlatButton(
                    child: Text('Lưu'),
                    color: Colors.lightGreen.shade100,
                    onPressed: () {
                      _addOrUpdateCategory();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }

}