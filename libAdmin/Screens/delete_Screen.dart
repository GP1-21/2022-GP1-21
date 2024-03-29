import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huna_ksa_admin/Components/storage_service.dart';
import 'dart:io';
import 'package:huna_ksa_admin/Widgets//city_Card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huna_ksa_admin/Components/common_Functions.dart';
import 'package:huna_ksa_admin/Components/constants.dart';
import 'package:huna_ksa_admin/Components/session.dart' as session;
import 'package:huna_ksa_admin/Widgets/deletePlace_Card.dart';
import 'package:huna_ksa_admin/Widgets/rounded_Button.dart';
import 'package:image_picker/image_picker.dart';

//https://medium.com/enappd/connecting-cloud-firestore-database-to-flutter-voting-app-2da5d8631662
//connect to the database in firebase
final Storage storage=Storage();
final _firestore = FirebaseFirestore.instance;

//https://api.flutter.dev/flutter/widgets/StatefulWidget/createState.html
//StatefulWidget describes part of the user interface
class DeleteScreen extends StatefulWidget {
  DeleteScreen({required this.city});
final String city;

  //state read synchronously when the widget is built, might change during the lifetime of the widget
  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {

  Future delete(String name,List imageUrls) async {
    if (imageUrls.isEmpty) return;
    for (int i = 0; i < imageUrls.length; i++) {
      storage.deleteImages(name + i.toString()).then((value) async {
        if (i == imageUrls.length - 1) {
          await _firestore.collection('placeData').doc(name).delete().then((value) => Navigator.pop(context));
        }
      });
    }
  }

  
//https://api.flutter.dev/flutter/widgets/StatelessWidget/build.html
  //page structure
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Delete Place",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          //delete icon
          child: Icon(Icons.arrow_back_ios_new_rounded,size:
          40,color: kPrimaryColor,),
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('placeData')
              .where("city",isEqualTo: widget.city)
              .orderBy("name", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: kProgressIndicatorColor,
                  color: kProgressIndicatorColor,
                ),
              );
            }
            final placeData = snapshot.data?.docs;


            return Padding(
              padding: const EdgeInsets.only(top: 30,bottom: 30,left: 16,right: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: kPrimaryColor,

                ),
                child: ListView.builder(
                  //scrollDirection: Axis.horizontal,

                    //padding: const EdgeInsets.only(left: 16, right:16),
                    itemCount: placeData?.length,
                    itemBuilder: (BuildContext listContext, int index) {

                     //this send the data to the deletePlace_Card page in the widgets file to be deleted
                     return DeletePlaceCard(placeData?.elementAt(index).get("images"), placeData?.elementAt(index).get("name"), delete, context);


                    }


                ),
              ),
            );
          }

      ),
    );
  }
}
