


class Item {
  String documentID;
  String name;
  String price;
  String uid;

  Item({
    this.documentID,
    this.name,
    this.price,
    this.uid
  });

  factory Item.fromDoc(dynamic doc) => Item(
      documentID: doc.documentID,
      price: doc["price"],
      name: doc["name"],
      uid: doc["uid"]
  );
}
