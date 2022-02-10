
class Category{
  String documentID;
  String name;
  String uid;

  Category({
    this.documentID,
    this.name,
    this.uid
  });

  factory Category.fromDoc(dynamic doc) => Category(
      documentID: doc.documentID,
      name: doc["name"],
      uid: doc["uid"]
  );
}