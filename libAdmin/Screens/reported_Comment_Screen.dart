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

final Storage storage=Storage();
final _firestore = FirebaseFirestore.instance;
class ReportedCommentScreen extends StatefulWidget {
  ReportedCommentScreen();
  @override
  State<ReportedCommentScreen> createState() => _ReportedCommentScreenState();
}

class _ReportedCommentScreenState extends State<ReportedCommentScreen> {
deleteComment(String id) async {
       await _firestore.collection('userComments').doc(id).delete();
}
deleteReportedComment(String id) async {
  await _firestore.collection('reportedComments').doc(id).delete().then((value) => Navigator.pop(context));
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Reported Comment",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context,"");
          },
          child: Icon(Icons.arrow_back_ios_new_rounded,size:
          40,color: kPrimaryColor,),
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('reportedComments').snapshots(),
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

                     return DeleteReportedCommentCard(placeData?.elementAt(index).get("username"), placeData?.elementAt(index).get("comment"),placeData?.elementAt(index).get("place"), deleteComment,deleteReportedComment, context,placeData?.elementAt(index).get("id"));


                    }


                ),
              ),
            );
          }

      ),
    );
  }
}
