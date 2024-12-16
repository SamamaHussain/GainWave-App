import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gain_wave_app/models/UserModel.dart';

class FirestoreFuncs {
  UserModel? userModel;
  String? FirstName;
  String? LastName;

  //Creating User Collection
final CollectionReference User=FirebaseFirestore.instance.collection('user');

//Adding New User Doc
Future <void> saveUser (String? Uid,String FirstName,String LastName,String Email){
  userModel = UserModel(FirstName: FirstName, LastName: LastName, Email: Email, Uid: Uid, CreatedAt: Timestamp.now());
   return  User.doc(userModel!.Uid).set(
    {
      'FirstName':userModel!.FirstName,
      'LastName':userModel!.LastName,
      'Email':userModel!.Email,
      'uid':userModel!.Uid,
      'CreatedAt':userModel!.CreatedAt,
    }
    
   );
}

// Reading Names Data Later
  Future<Map<String,String>?> getUser(String? Uid) async{
    // TODO: implement getUser
    DocumentSnapshot userDoc =await User.doc(Uid).get();
       if (userDoc.exists) {
        String firstName=userDoc['FirstName'];
        String lastName=userDoc['LastName'];
        Map<String,String>? NameMap={'firstName':firstName,'lastName':lastName};
        log('From GetUser Func: ${Uid}');
        return NameMap;
       }
       else{
        log('No user found');
        return null;
       }
  }

}