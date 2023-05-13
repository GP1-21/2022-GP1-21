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
//connect to the database in firebase, //https://medium.com/enappd/connecting-cloud-firestore-database-to-flutter-voting-app-2da5d8631662
final Storage storage = Storage();
final _firestore = FirebaseFirestore.instance;
//Create the class of the Delete Comment page, https://api.flutter.dev/flutter/widgets/StatefulWidget/createState.html
class DeleteCommentScreen extends StatefulWidget {
  DeleteCommentScreen({
    required this.place,
  });
  final String place;
  @override
  State<DeleteCommentScreen> createState() => _DeleteCommentScreenState();
}
//Create the Delete comment collection to the database, //https://dart.dev/codelabs/async-await
class _DeleteCommentScreenState extends State<DeleteCommentScreen> {
  delete(String id) async {
    await _firestore
        .collection('userComments')
        .doc(id)
        .delete()
        .then((value) => Navigator.pop(context));
  }
  //Create and design the frame of the page and the feilds
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Delete Comment",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 40,
            color: kPrimaryColor,
          ),
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('userComments')
              .where("place", isEqualTo: widget.place)
              .orderBy("username", descending: false)
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
              padding: const EdgeInsets.only(
                  top: 30, bottom: 30, left: 16, right: 16),
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
                      return DeleteCommentCard(
                          placeData?.elementAt(index).get("username"),
                          placeData?.elementAt(index).get("comment"),
                          placeData?.elementAt(index).get("place"),
                          delete,
                          context);
                    }),
              ),
            );
          }),
    );
  }
}
