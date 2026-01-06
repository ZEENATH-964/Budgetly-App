class Datamodel {
  final String? id;
  final String? cashIn;
  final String? cashout;
  final DateTime createdAt;   // ⭐ IMPORTANT
  final String? uid;
  final String? particular;
  final String? category;

  Datamodel({
    this.id,
    this.cashIn,
    this.cashout,
    required this.createdAt,
    this.uid,
    this.particular,
    this.category,
  });

  Map<String, dynamic> toJson() => {
        'cashIn': cashIn,
        'cashout': cashout,
        'createdAt': createdAt.toIso8601String(), // ⭐
        'uid': uid,
        'particular': particular,
        'category': category,
      };

  factory Datamodel.fromJson(Map<String, dynamic> json, String id) {
    return Datamodel(
      id: id,
      cashIn: json['cashIn'],
      cashout: json['cashout'],
      createdAt: DateTime.parse(json['createdAt']), // ⭐
      uid: json['uid'],
      particular: json['particular'],
      category: json['category'],
    );
  }
}
