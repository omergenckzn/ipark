import 'package:flutter/material.dart';

class CustomerModel {

  String name;
  String email;

  CustomerModel({required this.name, required this.email});

  Map<String,dynamic> toMap() {
    return {
      'name': name,
      'email': email
    };
  }

  factory CustomerModel.fromSnapshot(AsyncSnapshot snapshot) {
    var data = snapshot.data.data()! as Map<String, dynamic>;
    return CustomerModel(name: data['name'].toString(), email: data['email']);
  }

  factory CustomerModel.fromMap(Map map) {
    return CustomerModel(name: map['name'], email: map['email']);
  }


}