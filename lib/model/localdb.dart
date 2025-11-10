
import 'package:hive/hive.dart';
    part 'localdb.g.dart';
@HiveType(typeId: 0)
class UserAcoountDb {
  @HiveField(0)
   String? email;
   @HiveField(1)
   String? password;

   UserAcoountDb({
    required this.email,
    required this.password
   });

   
}