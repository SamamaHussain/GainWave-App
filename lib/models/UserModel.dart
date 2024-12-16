// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String FirstName;
  String LastName;
  String Email;
  String? Uid;
  Timestamp CreatedAt;
  UserModel({
    required this.FirstName,
    required this.LastName,
    required this.Email,
    required this.Uid,
    required this.CreatedAt,
  });
}
