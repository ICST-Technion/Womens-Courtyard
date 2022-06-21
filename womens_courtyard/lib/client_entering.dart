import 'package:flutter/material.dart';
import 'package:womens_courtyard/personal_file.dart';
import 'package:womens_courtyard/user.dart';
import 'package:womens_courtyard/add_contact.dart' as add_contact_page;
import 'package:womens_courtyard/bottom_navigation_bar.dart'
    as bottom_navigation_bar;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddClientPage extends StatefulWidget {
  AddClientPage({Key? key, this.title = ''}) : super(key: key);

  final String title;

  @override
  _AddClientPageState createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  //form key
  final _formKey = GlobalKey<FormState>();
  // firebase instances
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  //controller
  final TextEditingController firstNameTextController =
      new TextEditingController();
  final TextEditingController lastNameTextController =
      new TextEditingController();
  final TextEditingController idNoTextController = new TextEditingController();
  final TextEditingController phoneNumberTextController =
      new TextEditingController();
  final TextEditingController processDescriptionTextController =
      new TextEditingController();

  List<String> nationalityOptions = ['יהודיה', 'ערביה', 'אחר'];
  String nationality = 'אחר';

  @override
  void dispose() {
    firstNameTextController.dispose();
    lastNameTextController.dispose();
    idNoTextController.dispose();
    phoneNumberTextController.dispose();
    processDescriptionTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final privateNameField = TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: firstNameTextController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'הכניסי שם פרטי';
          }
          return null;
        },
        onSaved: (value) {
          firstNameTextController.text = value ?? '';
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'שם פרטי',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final lastNameField = TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: lastNameTextController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'הכניסי שם משפחה';
          }
          return null;
        },
        onSaved: (value) {
          lastNameTextController.text = value ?? '';
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'שם משפחה',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final idNoField = TextFormField(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: idNoTextController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'הכניסי תעודת זהות';
          }
          //regExp
          RegExp passReg = new RegExp(r'^[0-9]{9}$');
          if (!passReg.hasMatch(value)) {
            return 'על התז להיות חוקי (9 ספרות)';
          }
          return null;
        },
        onSaved: (value) {
          idNoTextController.text = value ?? '';
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'תעודת זהות',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final phoneNumberField = TextFormField(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: phoneNumberTextController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'הכניסי מספר טלפון';
          }
          //regExp
          RegExp passReg = new RegExp(r'^(?:[+0]9)?[0-9]{10}$');
          if (!passReg.hasMatch(value)) {
            return 'הכניסי מספר טלפון חוקי';
          }
          return null;
        },
        onSaved: (value) {
          phoneNumberTextController.text = value ?? '';
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'מספר טלפון',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final proccessDescriptionField = TextFormField(
        minLines: 1,
        maxLines: 10,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: processDescriptionTextController,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          processDescriptionTextController.text = value ?? '';
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'תיאור טיפול',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: getHomepageAppBar(),
        body: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(15.0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'תיק טיפול',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Flexible(child: privateNameField),
                    SizedBox(
                      width: 20.0,
                    ),
                    Flexible(child: lastNameField),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 150,
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Flexible(child: idNoField),
                      SizedBox(
                        height: 10.0,
                      ),
                      Flexible(child: phoneNumberField),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    'לאום:',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                DropdownButton(
                  // Initial Value
                  value: nationality,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: nationalityOptions.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      nationality = newValue!;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'אנשי קשר:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: ElevatedButton(
                      child: Text('הוספת איש קשר'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    add_contact_page.AddContactPage()));
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(250, 84, 9, 0),
                          elevation: 4,
                          minimumSize: Size(10, 10),
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)))),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(blurRadius: 20, spreadRadius: -15)
                        ]),
                    child: proccessDescriptionField),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: ElevatedButton(
                      child: Text('הזנת קבצים חדשים'),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(250, 84, 9, 0),
                          elevation: 4,
                          minimumSize: Size(100, 50),
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)))),
                ),
                Padding(
                  padding: const EdgeInsets.all(64.0),
                  child: ElevatedButton(
                      child: Text('סיום ושמירה'),
                      onPressed: () {
                        //enter the results from the controllers.text into the firebase, then navigate back.
                        // showDialog(
                        //   context: context,
                        //   builder: (context) {
                        //     return AlertDialog(
                        //       content: Text(firstNameTextController.text),
                        //     );
                        //   },
                        // );
                        if (_formKey.currentState != null &&
                            (_formKey.currentState!).validate()) {
                          enterFileToDatabase(
                              firstName: firstNameTextController.text,
                              lastName: lastNameTextController.text,
                              idNo: idNoTextController.text,
                              phone: phoneNumberTextController.text,
                              nationality: nationality,
                              pDec: processDescriptionTextController.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('הכנסת תיק מוצלחת')),
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => bottom_navigation_bar
                                      .MyBottomNavigationBar()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 4,
                          minimumSize: Size(150, 50),
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar getHomepageAppBar() {
    return AppBar(title: Text('הזנת תיק אישי'), actions: [
      IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.account_circle,
            size: 30,
            color: Colors.white,
          )),
      IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.info,
            size: 30,
            color: Colors.white,
          )),
    ]);
  }

  ListTile getListTile(text, icon, action) {
    return ListTile(
      title: Text(text, style: TextStyle(fontSize: 19, color: Colors.white)),
      trailing: Icon(icon, color: Colors.white),
      onTap: action,
    );
  }

  void enterFileToDatabase(
      {required String firstName,
      required String lastName,
      String? idNo,
      int? age,
      String? address,
      required String phone,
      required String nationality,
      required String pDec,
      bool? inAssignment}) async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref('clients/$idNo');
    getPersonalFileRef()
        .add({
          'firstName': firstName,
          'lastName': lastName,
          'idNo': idNo ?? "",
          'age': age,
          'address': address,
          'branch': AppUser().branch,
          'phoneNo': phone,
          'nationality': nationality,
          'clientNotes': [pDec],
          'inAssignment': inAssignment,
          'processes': [],
          'appointmentHistory': [],
          'attendances': []
        })
        .then((_) => print('added'))
        .catchError((e) => print('update failed $e'));
  }
}
