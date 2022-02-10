import 'package:flutter/material.dart';
import 'package:order_app/blocs/tables_edit_bloc.dart';
import 'package:order_app/blocs/tables_edit_bloc_provider.dart';



class EditEntry extends StatefulWidget {
  @override

  _EditEntryState createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  TaBlesEditBloc _taBlesEditBloc;

  TextEditingController _noteController;

  @override
  void initState() {
    super.initState();

    _noteController = TextEditingController();
    _noteController.text = '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _taBlesEditBloc = TaBlesEditBlocProvider.of(context).taBlesEditBloc;
  }

  @override
  dispose() {
    _noteController.dispose();
    _taBlesEditBloc.dispose();
    super.dispose();
  }

  void _addOrUpdateTaBles() {
    _taBlesEditBloc.saveChanged.add('Save');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm bàn', style: TextStyle(color: Colors.lightGreen.shade800),),
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
                stream: _taBlesEditBloc.noteEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  // Use the copyWith to make sure when you edit TextField the cursor does not bounce to the first character
                  _noteController.value = _noteController.value.copyWith(text: snapshot.data);
                  return TextField(
                    controller: _noteController,
                    textInputAction: TextInputAction.newline,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: 'Tên Bàn',
                      icon: Icon(Icons.subject),
                    ),
                    maxLines: null,
                    onChanged: (note) => _taBlesEditBloc.noteEditChanged.add(note),
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
                      _addOrUpdateTaBles();
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