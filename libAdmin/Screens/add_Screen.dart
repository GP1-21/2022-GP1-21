import 'dart:async';

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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';

//https://medium.com/enappd/connecting-cloud-firestore-database-to-flutter-voting-app-2da5d8631662
final Storage storage = Storage();
final _firestore = FirebaseFirestore.instance;

//https://api.flutter.dev/flutter/widgets/StatefulWidget/createState.html
class AddScreen extends StatefulWidget {
  AddScreen({required this.city});

  final String city;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  String btnText = "Choose files";
  //Setting controller for editable text field
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.708614,46.674792),
    zoom: 16,
  );

  var images;
  String category = "General", type = "Recreational Sites";

  bool showSpinner = false,time=false,priceCheck=false;
  //Picking muliple image for a place
  Future pickImage() async {
    try {
      images = await ImagePicker().pickMultiImage(requestFullMetadata: true);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
  // Adding required details of each place then submit
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
      //After adding details and clicking submit to save then clear the fields
      session.imagesURLList.clear();
      setState(() {
        showSpinner = true;
      });
      await saveStorage(nameController.text);
    }
  }
  //Storing the place in the database
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

  double lat = 0.0;
  double lng = 0.0;

  // Storing the place data in the placeData collection on Firebase
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

//https://api.flutter.dev/flutter/widgets/StatelessWidget/build.html
  //style of the page
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
                          "Name:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                            width: 210,
                            height: 50,
                            child: inputText(nameController, TextInputType.text,
                                "Name")),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Photos:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          height: 5,
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
                          horizontal: 5,
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
                        "Category:",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        width: 5,
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
                        "Type:",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        width: 5,
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
                      ],210),
                    ],),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Ticket price:",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                            width: 90,
                            height: 50,
                            child: inputText(priceController, TextInputType.text,
                                "Price" , !priceCheck)),

                        Container(
                          width: 120,
                          child: CheckboxListTile(
                            activeColor: Colors.white,
                            checkColor: Colors.black,
                            title: Text(
                              "Free",
                              style: kTextStyle,),
                            value: priceCheck,
                            onChanged: (newValue) {
                              setState(() {
                                priceController.clear();
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
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                            width: 195,
                            height: 50,
                            child: inputText(descriptionController, TextInputType.text,
                                "Description"m true)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Location:",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width:140,

                              child: TextFormField(
                                controller: locationController,
                                decoration: InputDecoration(
                                  hintText:"select location",
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),
                            ),
                      ],
                    ),
                      ],
                    ),
                    const SizedBox(height:18,),
                    Row(
                      children: [
                        const Text(
                          "Select on Map:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(width:6,),
                        RoundedButton(
                          decuration: TextDecoration.underline,
                          title: "Select On Map", //Select the place on map by a marker
                          color: kPrimaryColor,
                          onPress: () async {
                            LocationResult result =
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PlacePicker(
                                  "AIzaSyAuJYLmzmglhCpBYTn0BjbJhjWYg0fPEEA", //Google map API key
                                  displayLocation: LatLng(24.713447, 46.675209),
                                )));

                            lat = result.latLng!.latitude;
                            lng = result.latLng!.longitude;
                            locationController =
                                TextEditingController(text: result.name.toString());
                            setState(() {}); //Setting the selected location
                          },
                          textColor: Colors.blue,
                          height: 10,
                          horizontal: 5,
                        ),
                      ],
                    )

                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Opening and closing hours:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(children: [
                      SizedBox(
                          width: 100,
                          height: 50,
                          child: inputText(fromController, TextInputType.text,
                              "12:00" ,!time)),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "TO",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                        top: 10, left: 10, right: 85, bottom: 10),
                    child: RoundedButton(
                      title: "SUBMIT",
                      color: kPrimaryColor,
                      onPress: () async {
                        submit();
                      },
                      textColor: Colors.black,
                      height: 50,
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
  //After submiting the place and storing in firebase then clear the fields
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
                )),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
