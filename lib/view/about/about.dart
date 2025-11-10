// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:provider/provider.dart';
// import 'package:shersoft/controller/dataController.dart';
// import 'package:shersoft/utils/text.dart';

// class DetailedAboutPage extends StatelessWidget {
//   const DetailedAboutPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//         backgroundColor: const Color(0XFF0008B4),
//         title: Text(
//           Appstring.about,
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Consumer<Datacontroller>(builder: (context, value, child) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   Appstring.welcomeapp,
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   Appstring.welcomeprgrf,
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//               const Divider(),
//               const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   Appstring.story,
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   Appstring.storyprgraf,
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   Appstring.team,
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const ListTile(
//                 leading: CircleAvatar(
//                   backgroundImage:
//                       NetworkImage("https://i.postimg.cc/GmRBgZF1/ceo.jpg"),
//                 ),
//                 title: Text(Appstring.ceo),
//                 subtitle: Text(Appstring.ceotext),
//               ),
//               const ListTile(
//                 leading: CircleAvatar(
//                   // backgroundImage: AssetImage('asset/ceo.jpg'),
//                   backgroundImage:
//                       NetworkImage("https://i.postimg.cc/GmRBgZF1/ceo.jpg"),
//                 ),
//                 title: Text(Appstring.ceo),
//                 subtitle: Text(Appstring.ceotext2),
//               ),
//               const Divider(),
//               const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   Appstring.imapct,
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   Appstring.imapcttext,
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   Appstring.contact,
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   value.launchURL(
//                       "mailto:mubashirtc54@gmail.com?subject=Budgetly Support Request&body=Hi Team Budgetly,");
//                 },
//                 child: const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text(
//                     Appstring.email,
//                     style: TextStyle(
//                         color: Colors.blue, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               const Gap(10),

//               // Footer section
//               Container(
//                 height: 250,
//                 color: Colors.black,
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'DOWNLOAD THE BUDGETLY APP',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     InkWell(
//                       onTap: () {
//                         //   _launchURL(
//                         //       'https://play.google.com/store/apps/details?id=your.app.id');
//                         value.launchURL(
//                             'https://play.google.com/store/apps/details?id=your.app.id');
//                       },
//                       child: Row(
//                         children: [
//                           Image.network(
//                             "https://www.gizchina.com/wp-content/uploads/images/2021/12/Play-Store.jpg",
//                             width: 50,
//                             height: 50,
//                             fit: BoxFit.cover,
//                           ),
//                           const SizedBox(width: 8),
//                           const Text(
//                             'Google Play Store',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       "FOLLOW US",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             value.launchURL(
//                                 'https://www.instagram.com/muba_shirr._/?next=%2F');
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Image.asset(
//                               "asset/instagram.png",
//                               height: 40,
//                               width: 40,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         const Gap(30),
//                         InkWell(
//                           onTap: () {
//                             value.launchURL('https://twitter.com/yourtwitter');
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Image.network(
//                               "https://static.vecteezy.com/system/resources/previews/031/737/206/non_2x/twitter-new-logo-twitter-icons-new-twitter-logo-x-2023-x-social-media-icon-free-png.png",
//                               height: 50,
//                               width: 80,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }
//..................
import 'package:budgetly/controller/dataController.dart';
import 'package:budgetly/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';


class DetailedAboutPage extends StatelessWidget {
  const DetailedAboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0XFF0008B4),
        title: Text(
          Appstring.about,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<Datacontroller>(builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section with gradient background
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0XFF0008B4),
                      Color(0XFF0008B4).withOpacity(0.8),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Appstring.welcomeapp,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Gap(16),
                      Text(
                        Appstring.welcomeprgrf,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Story Section
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0XFF0008B4).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.auto_stories,
                            color: Color(0XFF0008B4),
                            size: 28,
                          ),
                        ),
                        Gap(12),
                        Text(
                          Appstring.story,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Gap(16),
                    Text(
                      Appstring.storyprgraf,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              // Team Section
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.groups,
                            color: Colors.orange,
                            size: 28,
                          ),
                        ),
                        Gap(12),
                        Text(
                          Appstring.team,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Gap(16),
                    _buildTeamMember(
                      imageUrl: "https://i.postimg.cc/GmRBgZF1/ceo.jpg",
                      name: Appstring.ceo,
                      role: Appstring.ceotext,
                      color: Colors.blue,
                    ),
                    Gap(12),
                    _buildTeamMember(
                      imageUrl: "https://i.postimg.cc/GmRBgZF1/ceo.jpg",
                      name: Appstring.ceo,
                      role: Appstring.ceotext2,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),

              // Impact Section
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.purple.withOpacity(0.1),
                      Colors.blue.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.purple.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.trending_up,
                            color: Colors.purple,
                            size: 28,
                          ),
                        ),
                        Gap(12),
                        Text(
                          Appstring.imapct,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Gap(16),
                    Text(
                      Appstring.imapcttext,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              // Contact Section
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.mail_outline,
                            color: Colors.green,
                            size: 28,
                          ),
                        ),
                        Gap(12),
                        Text(
                          Appstring.contact,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Gap(16),
                    InkWell(
                      onTap: () {
                        value.launchURL(
                            "mailto:mubashirtc54@gmail.com?subject=Budgetly Support Request&body=Hi Team Budgetly,");
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize
                              .min, // You can remove this line or use max
                          children: [
                            Icon(Icons.email, color: Colors.blue, size: 20),
                            Gap(8),
                            Flexible(
                              // ✅ This prevents overflow
                              child: Text(
                                Appstring.email,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow
                                    .ellipsis, 
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Gap(20),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey[900]!,
                      Colors.black,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DOWNLOAD THE BUDGETLY APP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    Gap(16),
                    InkWell(
                      onTap: () {
                        value.launchURL(
                            'https://play.google.com/store/apps/details?id=your.app.id');
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.network(
                                "https://www.gizchina.com/wp-content/uploads/images/2021/12/Play-Store.jpg",
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Gap(12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Available on',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'Google Play Store',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(30),

                    // Social Media Section
                    Text(
                      "FOLLOW US",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    Gap(16),
                    Row(
                      children: [
                        _buildSocialButton(
                          onTap: () {
                            value.launchURL(
                                'https://www.instagram.com/muba_shirr._/?next=%2F');
                          },
                          icon: Icons.camera_alt,
                          label: 'Instagram',
                          color: Colors.pink,
                        ),
                        Gap(16),
                        _buildSocialButton(
                          onTap: () {
                            value.launchURL('https://twitter.com/yourtwitter');
                          },
                          icon: Icons.close,
                          label: 'X (Twitter)',
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Gap(30),

                    // Copyright
                    Center(
                      child: Text(
                        '© 2024 Budgetly. All rights reserved.',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTeamMember({
    required String imageUrl,
    required String name,
    required String role,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
          Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(4),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withOpacity(0.4),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            Gap(8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
