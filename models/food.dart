import 'dart:typed_data';
import 'package:path_provider/path_provider.dart' as path;

class Food {
  String documentID;
  String uid;
  String name;
  String idFoodCategory;
  double price;
  int quantity;
  String idImage;
  Uint8List image;

  Food ({
    this.documentID,
    this.uid,
    this.name,
    this.idFoodCategory,
    this.price,
    this.image,
    this.idImage,
    this.quantity,
  });

  //Food({this.id, this.name, this.idFoodCategory, this.price, this.image});

   Food.fromDoc(dynamic doc) {
    this.documentID = doc.documentID;
    this.uid = doc["uid"];
    this.name=  doc["name"];
    this.idFoodCategory= doc["idFoodCategory"];
    this.price= doc["price"];
    this.quantity= doc["quantity"] != null ? int.parse(doc["quantity"]) : 0;
    this.idImage= doc["idImage"];
  }

}



Future<String> _getLocalPath() async {
  return path
      .getApplicationDocumentsDirectory()
      .then((value) => value.path);
}

int parseID(String name) => int.tryParse(name) ?? 0;

String basename(String path) => path.split('/').last.split('.').first;