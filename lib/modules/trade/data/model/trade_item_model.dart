// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TradeItemModel {
  int id;
  String title;
  double quantity;
  double price;
  double unitPrice;
  TradeItemModel(
    this.id,
    this.title,
    this.quantity,
    this.price,
    this.unitPrice,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'quantity': quantity,
      'price': price,
      'unitPrice': unitPrice,
    };
  }

  factory TradeItemModel.fromMap(Map<String, dynamic> map) {
    return TradeItemModel(
      map['id'] as int,
      map['title'] as String,
      map['quantity'] as double,
      map['price'] as double,
      map['unitPrice'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory TradeItemModel.fromJson(String source) => TradeItemModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
