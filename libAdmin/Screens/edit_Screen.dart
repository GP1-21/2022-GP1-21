import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huna_ksa_admin/Components/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huna_ksa_admin/Components/common_Functions.dart';
import 'package:huna_ksa_admin/Components/constants.dart';
import 'package:huna_ksa_admin/Components/session.dart' as session;
import 'package:huna_ksa_admin/Widgets/rounded_Button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

final Storage storage = Storage();
final _firestore = FirebaseFirestore.instance;

class EditScreen extends StatefulWidget {
  EditScreen({required this.city, required this.category, required this.type, this.imageUrls, required this.name, required this.price, required this.description, required this.location, required this.from, required this.to, required this.time, required this.priceCheck});
  final String city,name,price,description,location,from,to;
  late final String category,type;
  late final imageUrls;
  late final bool time,priceCheck;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  String btnText = "Choose files";
  var images;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
@override
  void initState() {
    // TODO: implement initState
  setControllers();
  super.initState();
  }
  setControllers(){
  setState(() {
    session.imagesURLList=widget.imageUrls;
    nameController.text=widget.name;
    priceController.text=widget.price;
    descriptionController.text=widget.description;
    locationController.text=widget.location;
    fromController.text=widget.from;
    toController.text=widget.to;
  });
  }

  bool showSpinner = false;

  Future pickImage() async {
    try {
      images = await ImagePicker().pickMultiImage(requestFullMetadata: true);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future save() async{
    if (nameController.text == "") {
      tost(context, "Please type place name");
    }
    else if (widget.imageUrls==[] && images==null) {
      tost(context, "Please select image");
    }
    else if (widget.priceCheck==false && priceController.text == "") {
      tost(context, "Please type price");
    }
    else if (descriptionController.text == "") {
      tost(context, "Please type description");
    }
    else if (locationController.text == "") {
      tost(context, "Please type location");
    }
    else if (widget.time==false && fromController.text == "") {
      tost(context, "Please type time 'from'");
    }
    else if (widget.time==false && toController.text == "") {
      tost(context, "Please type time 'to'");
    }
else
     {
       setState(() {
        showSpinner = true;
      });
      if(images==null){
        await updateData();

      }else{
        await deleteStorage(widget.name);


      }
    }
  }
  Future deleteStorage(String name) async {
    if (session.imagesURLList.isEmpty) return;
    for (int i = 0; i < session.imagesURLList.length; i++) {
      storage.deleteImages(name + i.toString()).then((value) {

        if (i == widget.imageUrls.length - 1) {

          saveStorage(nameController.text);
        }
      });
    }
  }
  Future saveStorage(String name) async {
    session.imagesURLList.clear();
    if (images.isEmpty) return;
    for (int i = 0; i < images.length; i++) {
      storage.uploadFile(images[i].path, name + i.toString()).then((value) {
        if (i == images.length - 1) {
          updateData();
        }
      });

    }
  }
  Future updateData() async {
    await _firestore.collection('placeData').doc(widget.name).update(
      {
        'name': nameController.text,
        'images': session.imagesURLList,
        'city': widget.city,
        'category':widget.category,
        'type':widget.type,
        'price':priceController.text,
        'free':widget.priceCheck?"1":"0",
        'description':descriptionController.text,
        'location':locationController.text,
        'from':fromController.text,
        'to':toController.text,
        'time':widget.time?"1":"0",
      },
    ).then((value) {
      session.imagesURLList.clear();
      tost(context, "${nameController.text} updated successfully");
      setState(() {
        showSpinner = false;
      });
      Navigator.pop(context);
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Place",
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
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Place name:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                            width: 230,
                            height: 50,
                            child: inputText(nameController, TextInputType.text,
                                "Place Name")),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Place photos:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RoundedButton(
                          decuration: TextDecoration.underline,
                          title: btnText,
                          color: kPrimaryColor,

                          onPress: () async {
                            pickImage();
                          },
                          textColor: Colors.blue,
                          height: 30,
                          horizontal: 10,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(children: [
                      Text(
                        "Place category:",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      dropDownalert(widget.category,"category", <String>[
                        'General',
                        'Woman',
                        'Kids',
                      ],150),
                    ],),

                    SizedBox(
                      height: 20,
                    ),
                    Row(children: [
                      Text(
                        "Place type:",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      dropDownalert( widget.type,"type", <String>[
                        'Recreational Sites',
                        'Historical Sites',
                        'Malls',
                        "Water Resorts",
                        "Restaurants & Cafes",
                        "Beach",
                        "Spa",
                        "Parks"
                      ],230),
                    ],),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Ticket price:",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                            width: 100,
                            height: 50,
                            child: inputText(priceController, TextInputType.text,
                                "Price")),

                        Container(
                          width: 130,
                          child: CheckboxListTile(
                            activeColor: Colors.white,
                            checkColor: Colors.black,
                            title: Text("Free",style: kTextStyle,),
                            value: widget.priceCheck,
                            onChanged: (newValue) {
                              setState(() {
                                widget.priceCheck = newValue!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Description:",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                            width: 240,
                            height: 50,
                            child: inputText(descriptionController, TextInputType.text,
                                "Description")),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      children: [
                        const Text(
                          "Location:",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                            width: 240,
                            height: 50,
                            child: inputText(locationController, TextInputType.text,
                                "Location")),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Opening and closing hours:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(children: [
                      SizedBox(
                          width: 100,
                          height: 50,
                          child: inputText(fromController, TextInputType.text,
                              "12:00")),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "to",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                          width: 100,
                          height: 50,
                          child: inputText(toController, TextInputType.text,
                              "12:00")),

                    ],),
                    CheckboxListTile(
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                      title: Text("Open 24 hours",style: kTextStyle,),
                      value: widget.time,
                      onChanged: (newValue) {
                        setState(() {
                          widget.time = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                    ),

                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30, left: 10, right: 10, bottom: 30),
                    child: RoundedButton(
                      title: "Save",
                      color: kPrimaryColor,
                      onPress: () async{
                       save();
                      },
                      textColor: Colors.black,
                      height: 20,
                      horizontal: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDownalert( String name,String function, List<String> itemList,double width) {
    return Container(
      height: 50,
      width: width,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: DropdownButtonHideUnderline(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: DropdownButtonFormField(
            style: kTextStyle,
            icon: const Icon(Icons.arrow_drop_down_rounded),
            iconSize: 30,
            iconEnabledColor: kPrimaryColor,
            isExpanded: true,
            hint: Center(
              child: Text("", style: TextStyle(color: Colors.black)),
            ),
            decoration: InputDecoration.collapsed(hintText: ''),
            value: name,
            onChanged: (value) {
              if (function == 'category') {
                setState(() {
                  widget.category = value as String;
                });
              } else if (function == "type") {
                setState(() {
                  widget.type = value as String;
                });
              }
            },
            items: itemList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(
                    child: Text(
                  value,
                  //style: kSimpleButtonTextStyle,
                )),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
