import 'package:flutter/material.dart';
import 'package:womens_courtyard/personal_file.dart';
import 'package:womens_courtyard/user.dart';
import 'package:womens_courtyard/search_contact_for_client.dart'
    as add_contact_page;
import 'package:womens_courtyard/bottom_navigation_bar.dart'
    as bottom_navigation_bar;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// This file details the page regarding the adding
/// of a new client page in the app.
/// The fields needed for each client in this file are the following:
/// * Name and surname.
/// * Title.
/// * Nationality.
/// * Process description.
/// * ID.
/// * Phone number.
///
/// Additionally there's an option to add extra contacts, and add files for this
/// account.

class AddClientPage extends StatefulWidget {
  AddClientPage({Key? key, this.title = ''}) : super(key: key);

  final String title;

  @override
  _AddClientPageState createState() => _AddClientPageState();
}

/// The main class that's in charge of the state of each field needed for the
/// page and the design in the app.

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
  //map of contacts
  List<ContactFile> contacts = [];

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
    // This method is rerun every time there's a certain change in the state
    // of the program., and builds the design of the page.

    // Here starts the definition of all fields containing information regarding
    // the purpose of the page.

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
            return null;
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
          prefixIcon: Icon(Icons.badge_outlined),
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
          prefixIcon: Icon(Icons.phone),
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
          prefixIcon: Icon(Icons.assignment),
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
                getContactsContainer(),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: ElevatedButton(
                    child: Text('הוספת איש קשר'),
                    onPressed: () async {
                      ContactFile chosenContact = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  add_contact_page.SearchContactForClient()));
                      if (chosenContact != null &&
                          chosenContact != Null &&
                          contactIsNotIn(contacts, chosenContact)) {
                        contacts.add(chosenContact);
                        setState(() {});
                        print("added to contacts, and reloded state");
                      }
                    },
                  ),
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
                        //enter the results from the controllers.text into the firebase,
                        // then navigate back.

                        if (_formKey.currentState != null &&
                            (_formKey.currentState!).validate()) {
                          enterFileToDatabase(
                              firstName: firstNameTextController.text,
                              lastName: lastNameTextController.text,
                              idNo: idNoTextController.text,
                              phone: phoneNumberTextController.text,
                              nationality: nationality,
                              pDec: processDescriptionTextController.text,
                              contactKeys: contacts
                                  .map((contact) => contact.key)
                                  .toList());
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

  /// Several functions relating to the use of contacts.

  Container getContactsContainer() {
    if (contacts.length > 0) {
      return Container(
        height: 100,
        child: new ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return new Card(
              child: new ListTile(
                leading: Icon(Icons.contact_page),
                trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        contacts.remove(contacts[index]);
                      });
                      print("got here" + contacts.length.toString());
                    }),
                title: new Text(
                    contacts[index].firstName + " " + contacts[index].lastName),
                subtitle: new Text(contacts[index].field),
                onTap: () {},
              ),
              margin: const EdgeInsets.all(0.0),
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }

  bool contactIsNotIn(List<ContactFile> existing, ContactFile newContact) {
    for (int i = 0; i < existing.length; i++) {
      if (existing[i].key == newContact.key) {
        return false;
      }
    }
    return true;
  }

  AppBar getHomepageAppBar() {
    return AppBar(title: Text('הזנת תיק אישי'));
  }

  ListTile getListTile(text, icon, action) {
    return ListTile(
      title: Text(text, style: TextStyle(fontSize: 19, color: Colors.white)),
      trailing: Icon(icon, color: Colors.white),
      onTap: action,
    );
  }

  /// This functions inserts every new file to the database.
  /// It uses the info gathered for the new client, and inserts it to the
  /// database in the way needed in order to keep its correctness.
  ///
  /// It also prints a message to the console of whether a certain adding action
  /// succeeded or not.

  void enterFileToDatabase(
      {required String firstName,
      required String lastName,
      String? idNo,
      int? age,
      String? address,
      required String phone,
      required String nationality,
      required String pDec,
      bool? inAssignment,
      List<String>? contactKeys}) async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref('clients/$idNo');
    putPersonalFile({
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
      'attendances': [],
      'contacts': contactKeys ?? []
    }).then((_) => print('added')).catchError((e) => print('update failed $e'));
  }
}
