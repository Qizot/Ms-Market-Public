import 'package:equatable/equatable.dart';
import 'package:ms_market/src/models/borrow_request.dart';
import 'package:ms_market/src/models/item/item.dart';

class User  extends Equatable{
  String id;
  int tenantId;
  String email;
  String name;
  String surname;
  String dormitory;
  String room;
  DateTime joined;
  
  List<BorrowRequest> borrowRequests;
  List<Item> items;

  @override
  List<Object> get props => [id];

  User(
      {this.id,
      this.tenantId,
      this.email,
      this.name,
      this.surname,
      this.dormitory,
      this.room,
      this.joined,
      this.borrowRequests,
      this.items});


  static final keys = [
    'id', 
    'tenantId',
    'email',
    'name',
    'surname',
    'dormitory',
    'room',
    'joined',
    'borrowRequests',
    'items',
  ];

  User.fromJson(Map<String, dynamic> json) {

    id = json['id'];
    tenantId = json['tenantId'];
    email = json['email'];
    name = json['name'];
    surname = json['surname'];
    dormitory = json['dormitory'];
    room = json['room'];
    if (json['joined'] != null) {
      joined = DateTime.parse(json['joined']);
    }
    if (json['borrowRequests'] != null) {
      borrowRequests = List<BorrowRequest>();
      json['borrowRequests'].forEach((v) {
        borrowRequests.add(BorrowRequest.fromJson(v));
      });
    }

    if (json['items'] != null) {
      items = List<Item>();
      json['items'].forEach((v) {
        items.add(Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tenantId'] = this.tenantId;
    data['email'] = this.email;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['dormitory'] = this.dormitory;
    data['room'] = this.room;
    data['joined'] = this.joined?.toIso8601String();
    data['borrowRequests'] = this.borrowRequests?.map((v) => v.toJson())?.toList();
    data['items'] = this.items?.map((v) => v.toJson())?.toList();
    return data;
  }
}