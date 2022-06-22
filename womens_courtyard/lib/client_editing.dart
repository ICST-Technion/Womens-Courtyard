import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:womens_courtyard/personal_file.dart';
import 'package:womens_courtyard/search_contact_for_client.dart'
    as add_contact_page;

class EditClientPage extends StatefulWidget {
  EditClientPage(
      {Key? key,
      this.title = '',
      required this.person,
      required this.initialContacts})
      : super(key: key);

  final String title;
  final PersonalFile person;
  final List<ContactFile> initialContacts;

  @override
  _EditClientPageState createState() => _EditClientPageState(initialContacts);
}

class _EditClientPageState extends State<EditClientPage> {
  //form key
  final _formKey = GlobalKey<FormState>();
  // firebase instances
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  //controller
  final TextEditingController nameTextController = new TextEditingController();
  final TextEditingController fNameTextController = new TextEditingController();
  final TextEditingController idNoTextController = new TextEditingController();
  final TextEditingController phoneNumberTextController =
      new TextEditingController();
  final TextEditingController processDescriptionTextController =
      new TextEditingController();

  List<String> nationalityOptions = ['יהודיה', 'ערביה', 'אחר'];
  String nationality = 'אחר';
  List<ContactFile> contacts = [];

  _EditClientPageState(List<ContactFile> initialContacts) {
    contacts.addAll(initialContacts);
  }

  @override
  void dispose() {
    nameTextController.dispose();
    fNameTextController.dispose();
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
        controller: nameTextController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'הכניסי שם פרטי';
          }
          return null;
        },
        onSaved: (value) {
          nameTextController.text = value ?? '';
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

    final fNameField = TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: fNameTextController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'הכניסי שם משפחה';
          }
          return null;
        },
        onSaved: (value) {
          fNameTextController.text = value ?? '';
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
        textDirection: TextDirection.rtl,
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
        textDirection: TextDirection.rtl,
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
    load_text_editors(
        nameTextController,
        fNameTextController,
        idNoTextController,
        phoneNumberTextController,
        processDescriptionTextController,
        widget.person);
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
                    Flexible(child: fNameField),
                  ],
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
                    child: Text('הוספת איש/ת קשר'),
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
                      onPressed: () async {
                        if (_formKey.currentState != null &&
                            (_formKey.currentState!).validate()) {
                          await enterFileToDatabase(
                              nameTextController.text,
                              fNameTextController.text,
                              idNoTextController.text,
                              phoneNumberTextController.text,
                              processDescriptionTextController.text,
                              nationality,
                              contacts,
                              widget.person);
                          var count = 0;
                          Navigator.of(context, rootNavigator: true)
                              .popUntil((route) {
                            return count++ == 2;
                          });
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

  bool contactIsNotIn(List<ContactFile> existing, ContactFile newContact) {
    for (int i = 0; i < existing.length; i++) {
      if (existing[i].key == newContact.key) {
        return false;
      }
    }
    return true;
  }

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

  AppBar getHomepageAppBar() {
    return AppBar(title: Text('עריכת תיק אישי'), actions: [
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

  Future<Null> enterFileToDatabase(
      String name,
      String fname,
      String idNo,
      String phoneNo,
      String pDec,
      String nationality,
      List<ContactFile> contacts,
      PersonalFile person) async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref('clients/$idNo');

    // person.clientNotes.add(pDec);

    updatePersonalFile(person.key, {
      'firstName': name,
      'lastName': fname,
      'idNo': idNo,
      'phoneNo': phoneNo,
      'nationality': nationality,
      'contacts': contacts.map((c) => c.key).toList(),
      'clientNotes': person.clientNotes,
    })
        .then((_) => print('updated'))
        .catchError((e) => print('update failed $e'));
  }
}

void load_text_editors(
    TextEditingController nameTextController,
    TextEditingController fNameTextController,
    TextEditingController idNoTextController,
    TextEditingController phoneNumberTextController,
    TextEditingController processDescriptionTextController,
    PersonalFile person) {
  nameTextController.text = person.firstName;
  fNameTextController.text = person.lastName;
  idNoTextController.text = person.idNo.toString();
  phoneNumberTextController.text = person.phoneNo;
  processDescriptionTextController.text = '';
}
