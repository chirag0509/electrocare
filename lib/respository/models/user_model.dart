import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String image;
  final String address;
  final int balance;
  final Map<String, dynamic> plan;
  final String upiId;
  final bool isActive;
  final Timestamp createdAt;

  const UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.image,
    required this.address,
    required this.balance,
    required this.plan,
    required this.upiId,
    required this.isActive,
    required this.createdAt,
  });

  toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phone": phone,
      "password": password,
      "image": image,
      "address": address,
      "balance": balance,
      "plan": plan,
      "upiId": upiId,
      "isActive": isActive,
      "createdAt": createdAt,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      firstName: data["firstName"],
      lastName: data["lastName"],
      email: data["email"],
      phone: data["phone"],
      password: data["password"],
      image: data["image"],
      address: data["address"],
      balance: data["balance"],
      plan: data["plan"],
      upiId: data["upiId"],
      isActive: data["isActive"],
      createdAt: data["createdAt"],
    );
  }
}
