import 'dart:io';
import 'package:huna_ksa_admin/Components/session.dart' as session;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
class Storage{
  final firebase_storage.FirebaseStorage storage=firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName)async{
    File file=File(filePath);

    try{
      //await storage.ref('places/$fileName').delete();

      String url= await (await storage.ref('places/$fileName').putFile(file)).ref.getDownloadURL();
      session.imagesURLList.add(url);
    }on firebase_core.FirebaseException catch (e)
    {
      print(e);
    }
  }
  Future<void> deleteImages(String fileName)async{

    try{
      await storage.ref('places/$fileName').delete();


    }on firebase_core.FirebaseException catch (e)
    {
      print(e);
    }
  }
}