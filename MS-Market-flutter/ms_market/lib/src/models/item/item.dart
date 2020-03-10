import 'package:ms_market/src/models/borrow_request.dart';
import 'package:ms_market/src/models/item/image_token.dart';
import 'package:ms_market/src/models/item/rating.dart';
import 'package:ms_market/src/models/item/rating_summary.dart';
import 'package:ms_market/src/models/user.dart';

enum ContractCategory {
  BORROW,
  LEND,
  OTHER,
  SELL,
  TRADE
}

ContractCategory parseContractCategory(String value) {
  if (value == null) return null;
  return ContractCategory.values.firstWhere(
    (status) => status.toString().contains(value),
    orElse: () => null
  );
}

String formatContractCategory(ContractCategory status) {
  if (status == null) {
    return null;
  }
  // enums strings are of format BorrowStatus.ACCEPTED;
  return status.toString().split(".")[1];
}

extension ReadableContractCategory on ContractCategory {
  String readableContractCategory() {
    switch (this) {
      case ContractCategory.BORROW: return "chcę wypożyczyć";
      case ContractCategory.LEND: return "mogę wypożyczyć";
      case ContractCategory.SELL: return "chcę sprzedać";
      case ContractCategory.TRADE: return "chcę się wymienić";
      case ContractCategory.OTHER: return "nieokreślono";
      default: return "nie wiem";
    }
  }
}

enum ItemCategory {
  ELECTRONICS,
  FOOD,
  KITCHEN,
  OTHER
}

ItemCategory parseItemCategory(String value) {
  if (value == null) return null;
  return ItemCategory.values.firstWhere(
    (status) => status.toString().contains(value),
    orElse: () => null
  );
}

String formatItemCategory(ItemCategory status) {
  if (status == null) {
    return null;
  }
  // enums strings are of format BorrowStatus.ACCEPTED;
  return status.toString().split(".")[1];
}

extension ReadableItemCategory on ItemCategory {
  String readableItemCategory() {
    switch (this) {
      case ItemCategory.FOOD: return "przedmiot spożywczy";
      case ItemCategory.ELECTRONICS: return "technologia";
      case ItemCategory.KITCHEN: return "przemiot kuchenny";
      case ItemCategory.OTHER: return "inne";
      default: return "nieznane";
    }
  }
}

class CreateItem {
  String ownerId;
  String name;
  String description;
  ItemCategory itemCategory;
  ContractCategory contractCategory;
  DateTime expiresAt;

  CreateItem({
    this.ownerId,
    this.name,
    this.description,
    this.itemCategory,
    this.contractCategory,
    this.expiresAt
  });
}

class UpdateItem {
  String id;
  String name;
  String description;
  ItemCategory itemCategory;
  ContractCategory contractCategory;
  DateTime expiresAt;

  UpdateItem({
    this.id,
    this.name,
    this.description,
    this.itemCategory,
    this.contractCategory,
    this.expiresAt,
  });
}

class Item {
  String id;
  String name;
  String description;
  DateTime createdAt;
  DateTime expiresAt;
  ItemCategory itemCategory;
  ContractCategory contractCategory;
  User owner;
  String ownerId;
  List<BorrowRequest> borrowRequests;
  ImageToken imageToken;
  List<Rating> ratings;
  RatingSummary summary;

  Item({
    this.id,
    this.name,
    this.description,
    this.createdAt,
    this.expiresAt,
    this.itemCategory,
    this.contractCategory,
    this.owner,
    this.ownerId,
    this.borrowRequests,
    this.imageToken,
    this.ratings,
    this.summary});

  static final keys = [
      'id',
      'name',
      'description',
      'createdAt',
      'expiresAt',
      'imageUrl',
      'itemCategory',
      'contractCategory',
      'owner',
      'ownerId',
      'borrowRequests',
      'imageToken',
      'ratings',
      'summary'
  ];



  Item.fromJson(Map<String, dynamic> json) {
    // keys.forEach((key) => json.putIfAbsent(key, null));

    id = json['id'];
    name = json['name'];
    description = json['description'];
    createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    expiresAt = json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null;
    itemCategory = parseItemCategory(json['itemCategory']);
    contractCategory = parseContractCategory(json['contractCategory']);
    owner = json['owner'] != null ? User.fromJson(json['owner']) : null;
    ownerId = json['ownerId'];
    if (json['borrowRequests'] != null) {
      borrowRequests = List<BorrowRequest>();
      json['borrowRequests'].forEach((v) {
        borrowRequests.add(BorrowRequest.fromJson(v));
      });
    }


    imageToken = json['imageToken'] != null ? ImageToken.fromJson(json['imageToken']) : null;
    if (json['ratings'] != null) {
      ratings = new List<Rating>();
      json['ratings'].forEach((v) {
        ratings.add(Rating.fromJson(v));
      });
    }
    summary = json['summary'] != null ? RatingSummary.fromJson(json['summary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['createdAt'] = this.createdAt?.toIso8601String();
    data['expiresAt'] = this.expiresAt?.toIso8601String();
    data['itemCategory'] = formatItemCategory(this.itemCategory);
    data['contractCategory'] = formatContractCategory(this.contractCategory);
    data['owner'] = this.owner?.toJson();
    data['ownerId'] = this.ownerId;
    data['borrowRequests'] = this.borrowRequests?.map((v) => v.toJson())?.toList();
    data['imageToken'] = this.imageToken?.toJson();
    data['ratings'] = this.ratings?.map((v) => v.toJson())?.toList();
    data['summary'] = this.summary?.toJson();

    return data;
  }

  void merge(Item other) {
    name = other.name ?? name;
    description = other.description ?? description;
    createdAt = other.createdAt ?? createdAt;
    expiresAt = other.expiresAt ?? expiresAt;
    itemCategory = other.itemCategory ?? itemCategory;
    contractCategory = other.contractCategory ?? contractCategory;
    owner = other.owner ?? owner;
    ownerId = other.ownerId ?? ownerId;
    borrowRequests = other.borrowRequests ?? borrowRequests;
    imageToken = other.imageToken ?? imageToken;
    ratings = other.ratings ?? ratings;
    summary = other.summary ?? summary;
  }
}
