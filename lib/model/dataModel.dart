class Datamodel {
  final String? id;
  final String? cashIn;
  final String? cashout;
  final String? date;
  final String? day;
  final String? uid;
  final String? time;
  final String? particular;

  Datamodel({
    this.id,
    this.cashIn,
    this.cashout,
    this.date,
    this.day,
    this.uid,
    this.time,
    this.particular,
  });

  Map<String, dynamic> toJson() => {
        'cashIn': cashIn,
        'cashout': cashout,
        'date': date,
        'day': day,
        'uid': uid,
        'time': time,
        'particular': particular,
      };

  factory Datamodel.fromJson(Map<String, dynamic> json, String id) {
    return Datamodel(
      id: id,
      cashIn: json['cashIn'],
      cashout: json['cashout'],
      date: json['date'],
      day: json['day'],
      uid: json['uid'],
      time: json['time'],
      particular: json['particular'],
    );
  }
}
