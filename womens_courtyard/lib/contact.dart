class Contact {
  final String name;
  final String phoneNumber;
  final String occupation;
  Contact({this.name, this.phoneNumber, this.occupation});

  factory Contact.fromJson(Map<String, dynamic> json) =>
      Contact(name: json['name'], phoneNumber: json['phoneNumber'], occupation: json['occupation']);
}
