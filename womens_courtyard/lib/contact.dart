class Contact {
  final String name;
  final String phoneNumber;
  Contact({this.name, this.phoneNumber});

  factory Contact.fromJson(Map<String, dynamic> json) =>
      Contact(name: json['name'], phoneNumber: json['phoneNumber']);
}
