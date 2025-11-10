class Usermetadata {
  String? companyName;
  String? phone;
  String? address;

  Usermetadata(
      {required this.address, required this.companyName, required this.phone});

  factory Usermetadata.fromFireBase(Map<String, dynamic> docs) {
    return Usermetadata(
        address: docs['address'],
        companyName: docs['company'],
        phone: docs['phone']);
  }
}
