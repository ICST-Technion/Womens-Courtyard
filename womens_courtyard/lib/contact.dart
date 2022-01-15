class Contact {
  final String name;
  final String phoneNumber;
  final String occupation;
  final String info;
  Contact({this.name, this.phoneNumber, this.occupation, this.info});

  factory Contact.fromJson(Map<String, dynamic> json) =>
      Contact(name: json['name'], phoneNumber: json['phoneNumber'], occupation: json['occupation'], info: json['info']);
}
