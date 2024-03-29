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

//https://medium.com/enappd/connecting-cloud-firestore-database-to-flutter-voting-app-2da5d8631662
//connect to the database in firebase
final Storage storage = Storage();
final _firestore = FirebaseFirestore.instance;

//https://api.flutter.dev/flutter/widgets/StatefulWidget/createState.html
//StatefulWidget describes part of the user interface
class EditScreen extends StatefulWidget {
  EditScreen({required this.city, required this.category, required this.type, this.imageUrls, required this.name, required this.price, required this.description, required this.location, required this.from, required this.to, required this.time, required this.priceCheck});
  final String city,name,price,description,location,from,to;
  late final String category,type;
  late final imageUrls;
  final bool time,priceCheck;

  //state read synchronously when the widget is built, might change during the lifetime of the widget
  @override
  State<EditScreen> createState() => _EditScreenState();
}

//initialize text controller
class _EditScreenState extends State<EditScreen> {

  String btnText = "Choose files";
  var images;
  bool priceCheck=false,time=false;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

 //https://api.flutter.dev/flutter/widgets/State/initState.html
@override
  void initState() {
    // TODO: implement initState
  setControllers();
  super.initState();
  }

  setControllers(){
  setState(() {
    session.imagesURLList=widget.imageUrls;
    priceCheck=widget.priceCheck;
    time=widget.time;
    nameController.text=widget.name;
    priceController.text=widget.price;
    descriptionController.text=widget.description;
    locationController.text=widget.location;
    fromController.text=widget.from;
    toController.text=widget.to;
  });
  }

  bool showSpinner = false;

//select image from the device
  Future pickImage() async {
    try {
      images = await ImagePicker().pickMultiImage(requestFullMetadata: true);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  //text filled
  Future save() async{
    if (nameController.text == "") {
      tost(context, "Please type place name");
    }
    else if (widget.imageUrls==[] && images==null) {
      tost(context, "Please select image");
    }
    else if (priceCheck==false && priceController.text == "") {
      tost(context, "Please type price");
    }
    else if (descriptionController.text == "") {
      tost(context, "Please type description");
    }
    else if (locationController.text == "") {
      tost(context, "Please type location");
    }
    else if (time==false && fromController.text == "") {
      tost(context, "Please type time 'from'");
    }
    else if (time==false && toController.text == "") {
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

  //delete from database
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

  //save to database
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

  //add new data to the database
  Future updateData() async {
    await _firestore.collection('placeData').doc(widget.name).update(
      {
        'name': nameController.text,
        'images': session.imagesURLList,
        'city': widget.city,
        'category':widget.category,
        'type':widget.type,
        'price':priceController.text,
        'free':priceCheck?"1":"0",
        'description':descriptionController.text,
        'location':locationController.text,
        'from':fromController.text,
        'to':toController.text,
        'time':time?"1":"0",
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

//https://api.flutter.dev/flutter/widgets/StatelessWidget/build.html
//the page structure
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
                                "Place Name",false)),
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
                          height: 15,
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
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      //drop down menu
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
                        "Type:",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      //drop down menu
                      dropDownalert(widget.type,"type", <String>[
                        'Recreational Sites',
                        'Historical Sites',
                        'Malls',
                        "Water Resorts",
                        "Restaurants & Cafes",
                        "Beach",
                        "Spa",
                        "Parks"
                      ],200),
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
                          width: 15,
                        ),
                        SizedBox(
                            width: 90,
                            height: 50,
                            child: inputText(priceController, TextInputType.text,
                                "Price",!priceCheck)),

                        Container(
                          width: 120,
                          child: CheckboxListTile(
                            activeColor: Colors.white,
                            checkColor: Colors.black,
                            title: Text("Free",style: kTextStyle,),
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
                                "Description",true)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    //edit text location the location can't be changed
                    Row(
                      children: [
                        const Text(
                          "Location:",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                            width: 230,
                            height: 50,
                            child: inputText(locationController, TextInputType.text,
                                "Location",false)),
                      ],
                    ),
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
                              "12:00",!time)),

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
                              "12:00",!time)),

                    ],),
                    CheckboxListTile(
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                      title: Text("Open 24 hours",style: kTextStyle,),
                      value: time,
                      onChanged: (newValue) {
                        setState(() {
                          toController.clear();
                          fromController.clear();
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
                        save();
                      },
                      textColor: Colors.black,
                      height: 20,
                      horizontal: 0,
                    ),
                  ),
                ),
              ],
            ),          ),
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
