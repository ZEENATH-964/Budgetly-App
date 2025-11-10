// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shersoft/controller/localdb.dart';
// import 'package:shersoft/controller/login.dart';
// import 'package:shersoft/view/account/accountwidget.dart';
// import 'package:shersoft/view/home/homepage.dart';

// class AccountsPage extends StatefulWidget {
//   const AccountsPage({super.key});

//   @override
//   State<AccountsPage> createState() => _AccountsPageState();
// }

// class _AccountsPageState extends State<AccountsPage> {
//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     getData();
//     return Scaffold(
//       body: ValueListenableBuilder(
//         valueListenable: valueNotifier,
//         builder: (context, value, child) {
//           return ListView.builder(
//             itemCount: value.length,
//             itemBuilder: (context, index) {
//               final data = value[index];
//               return ListTile(
//                 onTap: () {
//                   showModalBottomSheet(
//                     context: context,
//                     builder: (context) {
//                       return SizedBox(
//                         width: double.infinity,
//                         height: 160,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             GestureDetector(
//                                 onTap: () {
//                                   Provider.of<UserController>(context,
//                                           listen: false)
//                                       .loginUser(
//                                           email: data.email ?? '',
//                                           password: data.password ?? '')
//                                       .then((value) {
//                                     if (value != null) {
//                                       Navigator.pushReplacement(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => Homepage(),
//                                           ));
//                                     }
//                                   });
//                                 },
//                                 child: accountContainer(
//                                     context, Colors.green, "switch account")),
//                             GestureDetector(
//                               onTap: () async {
//                                 await removedata(index);
//                                 Navigator.pop(context);
//                               },
//                               child: accountContainer(
//                                   context, Colors.red, "remove account"),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//                 title: Text(data.email ?? ""),
//               );
//             },
//           );
//         },
//       ),
//       appBar: AppBar(
//         centerTitle: true,
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: const Color(0XFF0008B4),
//         title: Text(
//           "All Accounts",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
//...............
import 'package:budgetly/controller/localdb.dart';
import 'package:budgetly/controller/login.dart';
import 'package:budgetly/view/home/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: ValueListenableBuilder(
        valueListenable: valueNotifier,
        builder: (context, value, child) {
          if (value.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle_outlined,
                    size: 100,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No accounts found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10),
            itemCount: value.length,
            itemBuilder: (context, index) {
              final data = value[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0XFF0008B4),
                          Color(0XFF0008B4).withOpacity(0.7),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        data.email?.substring(0, 1).toUpperCase() ?? 'A',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    data.email ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  subtitle: Text(
                    'Tap to manage account',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                  trailing: Icon(
                    Icons.more_vert,
                    color: Colors.grey[400],
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 12),
                                height: 4,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Manage Account',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Provider.of<UserController>(context,
                                                listen: false)
                                            .loginUser(
                                                email: data.email ?? '',
                                                password: data.password ?? '')
                                            .then((value) {
                                          if (value != null) {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Homepage(),
                                                ));
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.swap_horiz,
                                              color: Colors.green,
                                              size: 24,
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              'Switch Account',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    InkWell(
                                      onTap: () async {
                                        await removedata(index);
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.delete_outline,
                                              color: Colors.red,
                                              size: 24,
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              'Remove Account',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0XFF0008B4),
        title: Text(
          "All Accounts",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
