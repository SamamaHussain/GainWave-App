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
Future <void> saveUser (String? Uid,String FirstName,String LastName,String Email,String Age,String Height,String Weight) async{
  userModel = UserModel(FirstName: FirstName, LastName: LastName, Email: Email, Uid: Uid, CreatedAt: Timestamp.now(), Age: Age, Height: Height, Weight: Weight);   
   return  User.doc(userModel!.Uid).set(
    {
      'FirstName':userModel!.FirstName,
      'LastName':userModel!.LastName,
      'Email':userModel!.Email,
      'uid':userModel!.Uid,
      'CreatedAt':userModel!.CreatedAt,
      'Age':userModel!.Age,
      'height':userModel!.Height,
      'weight':userModel!.Weight,
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
        String Age=userDoc['Age'];
        String height=userDoc['height'];
        String weight=userDoc['weight'];
        Map<String,String>? NameMap={'firstName':firstName,'lastName':lastName,'Age':Age,'height':height,'weight':weight};
        log('From GetUser Func: $Uid');
        return NameMap;
       }
       else{
        log('No user found');
        return null;
       }
  }

}