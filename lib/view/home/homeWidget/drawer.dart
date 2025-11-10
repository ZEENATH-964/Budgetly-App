import 'package:budgetly/backup/backup.dart';
import 'package:budgetly/constants/colors.dart';
import 'package:budgetly/controller/dataController.dart';
import 'package:budgetly/controller/login.dart';
import 'package:budgetly/view/Monthlydata/printmonth.dart';
import 'package:budgetly/view/Settings/settingss.dart';
import 'package:budgetly/view/about/about.dart';
import 'package:budgetly/view/account/accounts.dart';
import 'package:budgetly/view/privacypoli.dart/privacy.dart';
import 'package:budgetly/view/totelscreentime/screentime.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Drawer drawer({BuildContext? context, String? company, String? phone}) {
  return Drawer(
    backgroundColor: Colors.white,
    child: SingleChildScrollView(
      child: Column(
        children: [
          // Enhanced Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Appcolors.backgroundblue,
                  Appcolors.backgroundblue.withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Appcolors.backgroundblue.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            height: 220,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Company Logo/Avatar
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.business,
                      size: 40,
                      color: Appcolors.backgroundblue,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  company ?? 'Company Name',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    phone ?? '+91 0000000000',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
      
          // Menu Items
          Padding(
           padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
             
              
              children: [
                _buildDrawerItem(
                  icon: Icons.groups_outlined,
                  title: "Accounts",
                  onTap: () => Navigator.push(context!,
                      MaterialPageRoute(builder: (context) => AccountsPage())),
                  iconColor: Colors.blue,
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: "Settings",
                  onTap: () {
                    Navigator.push(context!,
                        MaterialPageRoute(builder: (context) => SettingsPage()));
                  },
                  iconColor: Colors.grey[700],
                ),
                _buildDrawerItem(
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  onTap: () {
                    Navigator.push(
                        context!,
                        MaterialPageRoute(
                            builder: (context) => PrivacyPolicyPage()));
                  },
                  iconColor: Colors.green,
                ),
                _buildDrawerItem(
                  icon: Icons.picture_as_pdf,
                  title: "Monthly Report PDF",
                  onTap: () async {
                    final selectedMonth = await showDialog<String>(
                      context: context!,
                      builder: (BuildContext context) {
                        String? dropdownValue;
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size: 50,
                                  color: Appcolors.backgroundblue,
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Select Month',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                StatefulBuilder(
                                  builder: (context, setState) {
                                    return Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.grey[300]!),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: DropdownButton<String>(
                                        hint: const Text("Choose Month"),
                                        value: dropdownValue,
                                        isExpanded: true,
                                        underline: SizedBox(height: 0,),
                                        icon: Icon(Icons.arrow_drop_down,
                                            color: Appcolors.backgroundblue),
                                        items: [
                                          'January',
                                          'February',
                                          'March',
                                          'April',
                                          'May',
                                          'June',
                                          'July',
                                          'August',
                                          'September',
                                          'October',
                                          'November',
                                          'December',
                                        ].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            dropdownValue = newValue;
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, null),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Appcolors.backgroundblue,
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                      ),
                                      onPressed: () =>
                                          Navigator.pop(context, dropdownValue),
                                      child: Text(
                                        "Generate",
                                        style: TextStyle(
                                          color: Appcolors.whitecolors,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  
                    if (selectedMonth != null) {
                      final datacontroller =
                          Provider.of<Datacontroller>(context!, listen: false);
                  
                      await datacontroller.getdata('Monthly', selectedMonth);
                  
                      generateMonthlyPdfReport(
                        context,
                        company: 'Budgetly',
                        selectedMonth: selectedMonth,
                      );
                    }
                  },
                  iconColor: Colors.red,
                ),
                _buildDrawerItem(
                  icon: Icons.screen_lock_portrait,
                  title: 'Screen Time',
                  onTap: () => Navigator.push(
                    context!,
                    MaterialPageRoute(builder: (context) => AppUsageStatsPage()),
                  ),
                  iconColor: Colors.purple,
                ),
                _buildDrawerItem(
                  icon: Icons.cloud_upload,
                  title: 'Cloud Backup',
                  onTap: () => Navigator.push(
                    context!,
                    MaterialPageRoute(builder: (context) => CloudBackupPage()),
                  ),
                  iconColor: Colors.teal,
                ),
                _buildDrawerItem(
                  icon: Icons.info_outline,
                  title: "About",
                  onTap: () {
                    Navigator.push(
                        context!,
                        MaterialPageRoute(
                            builder: (context) => DetailedAboutPage()));
                  },
                  iconColor: Colors.orange,
                ),
                Divider(
                  thickness: 1,
                  height: 30,
                  color: Colors.grey[300],
                  indent: 20,
                  endIndent: 20,
                ),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: "Logout",
                  onTap: () {
                    // Show confirmation dialog
                    showDialog(
                      context: context!,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: Row(
                            children: [
                              Icon(Icons.logout, color: Colors.red),
                              SizedBox(width: 10),
                              Text("Logout"),
                            ],
                          ),
                          content: Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Provider.of<UserController>(context,
                                        listen: false)
                                    .logoutUser(context);
                              },
                              child: Text("Logout",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  iconColor: Colors.red,
                  showTrailing: false,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildDrawerItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  Color? iconColor,
  bool showTrailing = true,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (iconColor ?? Colors.grey).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: iconColor ?? Colors.grey[700],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              if (showTrailing)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
