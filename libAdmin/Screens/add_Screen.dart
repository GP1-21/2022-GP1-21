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

class AddScreen extends StatefulWidget {
  AddScreen({required this.city});
  final String city;
  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  String btnText = "Choose files";
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  var images;
  String category = "General", type = "Recreational Sites";

  bool showSpinner = false,time=false,priceCheck=false;

  Future pickImage() async {
    try {
      images = await ImagePicker().pickMultiImage(requestFullMetadata: true);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future submit() async {
    if (nameController.text == "") {
      tost(context, "Please type place name");
    }else if (images.isEmpty) {
      tost(context, "Please select image");
    }  else if (priceCheck==false && priceController.text == "") {
      tost(context, "Please type price");
    }else if (descriptionController.text == "") {
      tost(context, "Please type description");
    }else if (locationController.text == "") {
      tost(context, "Please type location");
    }  else if (time==false && fromController.text == "") {
      tost(context, "Please type time 'from'");
    } else if (time==false && toController.text == "") {
      tost(context, "Please type time 'to'");
    } else {
      session.imagesURLList.clear();
      setState(() {
        showSpinner = true;
      });
      await saveStorage(nameController.text);
    }
  }
  Future saveStorage(String name) async {
    if (images.isEmpty) return;
    for (int i = 0; i < images.length; i++) {
      storage.uploadFile(images[i].path, name + i.toString()).then((value) {
        if (i == images.length - 1) {
          print("Saved to storage");
          saveData();
        }
      });
      // setState(() {
      //   print(images[i].name); });
    }
  }
  Future saveData() async {
    await _firestore.collection('placeData').doc(nameController.text).set(
      {
        'name': nameController.text,
        'images': session.imagesURLList,
        'city': widget.city,
        'category':category,
        'type':type,
        'price':priceController.text,
        'free':priceCheck?"1":"0",
        'description':descriptionController.text,
        'location':locationController.text,
        'from':fromController.text,
        'to':toController.text,
        'time':time?"1":"0",
      },
    ).then((value) {
clearData();
tost(context, "${nameController.text} added successfully");
    });
    // setState(() {
    //   showSpinner = false;
    // });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add Place",
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
                      dropDownalertBeforedays(category,"category", <String>[
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
                      dropDownalertBeforedays(type,"type", <String>[
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
                            value: priceCheck,
                            onChanged: (newValue) {
                              setState(() {
                                priceCheck = newValue!;
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
                      value: time,
                      onChanged: (newValue) {
                        setState(() {
                          time = newValue!;
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
                      title: "Submit",
                      color: kPrimaryColor,
                      onPress: () async {
                        submit();
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
  clearData(){
    setState(() {
      category = "General";
      type = "Recreational Sites";
      showSpinner = false;
      time=false;
      priceCheck=false;
      session.imagesURLList.clear();
      images.clear();
      nameController.text="";
      priceController.text="";
      descriptionController.text="";
      locationController.text="";
      fromController.text="";
      toController.text="";
    });
  }
  Widget dropDownalertBeforedays(String name, String function, List<String> itemList,double width) {
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
                  category = value!;
                });
              } else if (function == "type") {
                setState(() {
                  type = value!;
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
