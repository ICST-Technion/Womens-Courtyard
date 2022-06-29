# Womens-Courtyard Client Managment App

Welcome to the Womens-Courtyard Client Managment App, this app was created in order to help
[The Womens-Courtyard](https://hatzer.org.il/) to help manage their daily activities.

## Features

The app contains many basic features, such as:

* Adding new Caretakers to a certain branch of the courtyard
* Creating a new Client file
* Creating a new Contact file
* Monitoring daily presence of clients in the courtyard
* Extracting statistics on the courtyards activities
  * In visual form
  * In excel form in order to preform advanced data extracting

## User Managment

The app supports two type of users:

* Client Users, users owned by clients of the courtyard and have very little access. Reason being that the information in the app is private. The clients user capabilities are:
  1. Accessing the clients file
  2. Editing said file
* Caretaker Users, the users owned by caretakers of the couryard, with access to almost all the features of the app, namly:
  1. Adding new Caretaker user from the same branch
  2. Adding & editing new clients
  3. Adding & editing new contacts
  4. Extracting statistics

**Important Note**: The users are devided to branches. Any activity done on a user beloging to a specific branch can change data only of the specific branches, with the exception of **Department Users** which can affect all the branches.

## Dependencies & Activation

The application is written in flutter, using dart=@2.9, with sound null safty.
After installing flutter & dart, and choosing an ide, it is recommended to test the dependencies.\
All the library dependencies are available in the **pubsec.yaml** file.
It is recommended to run the command:

```bash
cd womens_courtyard
flutter pub get
cd ..
```

In order to resolve any dependency problems.

### Firebase emulator

After solving all the dependencies, it is imperative to work on the application using an emulator, so as not to harm the deployed firebase database.\
Since the application uses firebase emulators with the required tokens, it is neccesary to send a mail to [Ittay Alfassi](ittay.al@campus.technion.ac.il) in order to confirm the identity of the app developer.

The explanation and installing instructions for the firebase emulators can be found [here](https://firebase.google.com/docs/emulator-suite/install_and_configure).

### First User

When deploying the application, or using an emulator. The first window to open up will be the login window, without any register option.\
This is because of the applications design, in order to maintain security, not anyone can sign in.
Only signed in Caretaker users can register new users, and those registerd users can only be created in the registering user's branch (unless it is a branchde).\
This is why, when deploying\instatiating an emulator, it should already contain one Department Cartaker user, from which the user can create any other caretaker users in any branch.\
For reference consult the saved emulator in here [emulatordata](eumulatordata).

### Deployment

In order to deploy a new version of the application, consult the following file [how_to_deploy](HOW_TO_DEPLOY.txt).

## Database Configuration

The database is based in firebase, and is no-sql. In order to maintain stability, when changing the database configuration, or when creating new queries, one should consult the following markdown depiction of the [database](db_schema.md).

## Code Documentation

The following section is dedicated to any developer whishing to understand, fix bugs, or change the application in any way.\
The following will be a description of each file's purpose in the app, and it's contents.

### add_contact.dart

This file is in charge of handling the adding of another contact to a
contact list.\
The fields each contact has are:

* Phone number
* Name and surname
* Category of service
* Email.

Only by adding valid details, the worker is able to add a contact to the
registery.

### add_event.dart

This file is in charge of handling the adding of an event to the calendar.

The fields each contact has are:

* Time
* Date
* Room
* Name of activity

Only by adding valid details, the worker is able to add an event to the
calendar.
Didn't have time to finish the building of the calendar in the second sprint, left as a template for the future.

### attendance_page.dart

This file is in charge of handling attendances marking per client.

The fields of the main class are:

* PersonalFile file - a file of the client to mark the attendance to
* A key for the object

The state builder builds the page with a button to choose the date, and a TextController in order to enter a daily sentence about the client.

### attendance_search_page.dart

This page is in charge of searching certain parameters and women in the
attendance forms.
For a certain user, this page is able to trace the details of the user's
attendance from the firebase.

For further information of the inner workings of the page, consult the code.

### bottom_navigation_bar.dart

This page is in charge of the bottom navigation bar, containing:

* A Home screen.
* An attendance records screen.
* A files screen.
* A contacts screen.

### calendar.dart

This page is in charge of the calendar in the app.
It builds the calendar, all of its possible events, and has an option of
adding different events to the calendar.
For each activity, a user is able to see the time, date, room and the name
of the activity.
Didn't have time to finish the building of the calendar in the second sprint, left as a template for the future.

### client_editing.dart

This file details the page regarding the editing
of each existing client page in the app.
The fields that are present editable in this file are the following:

* Name and surname
* Title
* Nationality
* Process description
* ID
* Phone number

Additionally there's an option to add extra contacts, and add files for this
account.

### client_entering.dart

This file details the page regarding the adding
of a new client page in the app.
The fields needed for each client in this file are the following:

* Name and surname.
* Title.
* Nationality.
* Process description.
* ID.
* Phone number.

Additionally there's an option to add extra contacts, and add files for this
account.

### contact_edit_real.dart

This file is in charge of handling the editing of a contact..

The fields each contact has are:

* Phone number.
* Name and surname.
* Category of service.
* Email.

Only by adding valid details, the worker is able to add a contact to the
registery.

### firebase_options.dart

File generated by FlutterFire CLI **DO NOT CHANGE**

### FirestoreQueryObjects.dart

This file contains the firestore query objects that connect the backend to
the frontend of the app.

### forms_button.dart

A class containing a template of forms buttons used by other pages in the
app.

### generated_plugin_registrant.dart

Generated file. Do not edit.

### home_page.dart

The homepage of the application.
It doesn't hold important information but holds links to features of the app
not noted in the bottom navigation bar.
Including:

* Statistics.
* Adding a user (Both crew and non-crew).
* Calendar.

### login_screen.dart

Main app login screen.
The login works directly in parallel with the databsae, and confirms the
logging in with it.\
The page also makes sure the login details are valid, and only then tries
to login.\
Notice that this page is only for login, a regular user can't perform a
registration on her own, and only a meta user needs to register the girls.

### main.dart

This file is in charge of connecting to the firebase emulator.\
When starting the app, this file is called, and it handles the start of the
app and navigates the user to the login page.

### meeting.dart

A file containing the settings of a certain meeting in the calendar.

### meetings.dart

A class containing a list of meetings and their properties.

### nationality.dart

A class containing all possible nationalities, and returns a list taken from
the database of each nationality coupled with the name of the user.

### personal_file_search_page.dart

A file in charge of searching a personal file.
While searching, the app helps with suggestions of personal files that match
the current text in the search bar.
When a suggestion is pressed, it leads the user to the personal file
selected.

### personal_file.dart

This file contains every attribute needed for a personal file.
We define here several classes with multiple fields, including:

* Appointment
* Attendance
* Personal file

We get all information needed for the personal file of a certain user
from the database and fill up the classes presented above using it.

### register_screen.dart

Main app registration screen.\
The registration works directly in parallel with the database, and sends the
information there
The page also makes sure the registration details are valid, and only then tries
to perform the action.\
Notice that this page is only for registration, a regular user can't reach
this page on her own, only a meta user can do so.

### search_contact_for_client.dart

A file in charge of searching a contact for a certain client.\
Similar to the regular contact search, here the app gives an option to search
for a contact related to some client.\
While searching, the app helps with suggestions of personal files that match
the current text in the search bar.

### search_contact.dart

A file in charge of searching a contact.\
While searching, the app helps with suggestions of contacts that match
the current text in the search bar.\
When a suggestion is pressed, it leads the user to the contact
selected.

### statistics_logic.dart

Here is concentrated the logic behind the queries sent to the database in
order to extract the proper data the user needs.\
The queries are split into two types - Nationality induced statistics,
and attendance related one.

### statistics.dart

This page is in charge of displaying the page leading to the statistics.\
Using the database and several options, the app sends a request for certain
data to the database and receives the matching data.\
After performing the calculations, we extract a file detailing the
statistics the user asked for.

### statistic_home_page.dart

In this page we build the graphs and charts used for the visual presentation
of the calculated and collected statistics.

### user.dart

Class defining features for app user, including name, username and branch.

### view_contact.dart

This file is in charge of handling the viewing of a contact, and gives us the
option of editing (moves to another page).

The fields each contact has are:

* Phone number.
* Name and surname.
* Category of service.
* Email.

### view_personal_file.dart

This file is in charge of handling the viewing of a personal page, and gives us the
option of editing (moves to another page).

The fields each contact has are:

* Phone number.
* Name and surname.
* Nationality.
* Phone number.
* Information regarding the woman.
* Daily sentences.
* Contacts.

## Testing

The project contains two type's of built in tests

**Important Note**: all tests are preformed via githooks before every commit or push.

### Unit testing

There are unit testing using mocks in order to test the logic of the registering and logging-in options are working as intended. You can find them [here](https://github.com/ICST-Technion/Womens-Courtyard/blob/main/womens_courtyard/test/login_test.dart) and [here](https://github.com/ICST-Technion/Womens-Courtyard/blob/main/womens_courtyard/test/register_test.dart).

### Integration tests

The project contains integration test which check that the attendance entry is working properly in conjoint with the statistics. You can find those tests [here](https://github.com/ICST-Technion/Womens-Courtyard/blob/main/womens_courtyard/test/statistics_integration_test.dart).

### running the tests

In order to run the tests, run from the main folder:

```bash
cd womens_courtyard/test/
flutter test --platform chrome
```

## Contributions

* [Itamar Juwiler](https://github.com/itamar1208)
* [Ittay Alfassi](https://github.com/ittay-alfassi)
* [Omer Moreno](https://github.com/omermoreno-lab)
* [Jonathan Shkabatur](https://github.com/jony3004)
* [Ayala Fostik-Tur]()
