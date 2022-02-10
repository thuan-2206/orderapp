class Report {
  String documentID;
  String uid;
  DateTime day;
  double totalPrice;


  Report({
    this.documentID,
    this.totalPrice,
    this.uid,
    this.day,
});


  factory Report.fromDoc(dynamic doc) => Report(
    documentID: doc.documentID,
    uid: doc["uid"],
    totalPrice: doc["totalPrice"],
    day: doc["day"],
  );

}