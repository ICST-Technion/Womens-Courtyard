class Contact {
  final String name;
  final String phoneNumber;
  final String occupation;
  final String info;
  Contact(
      {required this.name,
      required this.phoneNumber,
      required this.occupation,
      required this.info});

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      occupation: json['occupation'],
      info: json['info']);
}
