import 'package:budgetly/constants/colors.dart';
import 'package:budgetly/controller/dataController.dart';
import 'package:budgetly/controller/login.dart';
import 'package:budgetly/model/dataModel.dart';
import 'package:budgetly/view/Profile/userprofile.dart';
import 'package:budgetly/view/home/homeWidget/drawer.dart';
import 'package:budgetly/view/transitionviewpage/transitionview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _cashin = TextEditingController();
  final TextEditingController _cashout = TextEditingController();
  final TextEditingController _particular = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isSearching = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserController>(context, listen: false).getUserMetaData();
      Provider.of<Datacontroller>(context, listen: false).getdata();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _filterSearchResults(String query) {
    Provider.of<Datacontroller>(context, listen: false).filterData(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0XFFF5F5F5),
        drawer: Consumer<UserController>(
          builder: (context, value, child) => drawer(
            context: context,
            company: value.companyName ?? '',
            phone: value.phone ?? '',
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: Appcolors.whitecolors,
              size: 28,
            ),
          ),
          centerTitle: true,
          title: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _isSearching
                ? Container(
                    height: 40,
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search transactions...',
                        hintStyle:
                            TextStyle(color: Colors.white70, fontSize: 16),
                        border: InputBorder.none,
                        prefixIcon:
                            Icon(Icons.search, color: Colors.white70, size: 20),
                      ),
                      style:
                          TextStyle(color: Appcolors.whitecolors, fontSize: 16),
                      onChanged: _filterSearchResults,
                    ),
                  )
                : Text(
                    "Cash Book",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Appcolors.whitecolors,
                      fontSize: 22,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
          backgroundColor: Appcolors.backgroundblue,
          actions: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              child: IconButton(
                icon: Icon(
                  _isSearching ? Icons.close : Icons.search,
                  color: Appcolors.whitecolors,
                  size: 26,
                ),
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      _searchController.clear();
                      _filterSearchResults('');
                    }
                  });
                },
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Userprofile(),
                  ),
                );
              },
              icon: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Icon(
                  Icons.person,
                  color: Appcolors.whitecolors,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Provider.of<Datacontroller>(context, listen: false).getdata();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Data refreshed successfully"),
                backgroundColor: Appcolors.backgroundblue,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Filter Buttons
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Consumer<Datacontroller>(
                    builder: (context, value, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          ['All', 'Daily', 'Weekly', 'Monthly'].map((filter) {
                        bool isSelected = value.selected == filter;
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          child: SizedBox(
                            height: 35,
                            child: ElevatedButton(
                              onPressed: () {
                                value.selectedColor(filter);
                                value.getdata(filter);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: isSelected
                                    ? Appcolors.whitecolors
                                    : Appcolors.backgroundblue,
                                backgroundColor: isSelected
                                    ? Appcolors.backgroundblue
                                    : Appcolors.whitecolors,
                                elevation: isSelected ? 3 : 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: Appcolors.backgroundblue,
                                    width: isSelected ? 0 : 1,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Header Row
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0XFFFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Date",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(width: 50),
                          Text(
                            "Cash in",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Appcolors.greencolors,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "Cash out",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Appcolors.redcolors,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                // Total Cash Display
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Appcolors.backgroundblue,
                        Appcolors.backgroundblue.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Appcolors.backgroundblue.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Consumer<Datacontroller>(
                    builder: (context, dataController, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_balance_wallet,
                              color: Colors.white, size: 24),
                          SizedBox(width: 10),
                          Text(
                            "Total Balance: ₹${dataController.totalCash.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Transaction List
                Expanded(
                  child: Consumer<Datacontroller>(
                    builder: (context, value, child) {
                      if (value.filteredData.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.receipt_long,
                                size: 80,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No transactions found",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: EdgeInsets.only(bottom: 80),
                        itemCount: value.filteredData.length,
                        itemBuilder: (context, index) {
                          final data = value.filteredData[index];
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TransactionDetailsPage(data: data),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0XFFFFFFFF),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TransactionDetailsPage(
                                                  data: data),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data.particular ??
                                                      'Transaction',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    color: Colors.black87,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4),
                                                // Option 1: Using Flexible widgets
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.calendar_today,
                                                      size: 14,
                                                      color: Colors.grey[500],
                                                    ),
                                                    SizedBox(width: 4),
                                                    Flexible(
                                                      child: Text(
                                                        "${data.date}",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    SizedBox(width: 12),
                                                    Icon(
                                                      Icons.access_time,
                                                      size: 14,
                                                      color: Colors.grey[500],
                                                    ),
                                                    SizedBox(width: 4),
                                                    Flexible(
                                                      child: Text(
                                                        "${data.time}",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "₹${data.cashIn ?? '0'}",
                                              style: TextStyle(
                                                color: Appcolors.greencolors,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "₹${data.cashout ?? '0'}",
                                              style: TextStyle(
                                                color: Appcolors.redcolors,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          child: FloatingActionButton(
            elevation: 8,
            tooltip: 'Add Transaction',
            backgroundColor: Appcolors.backgroundblue,
            child: Icon(
              Icons.add,
              color: Appcolors.whitecolors,
              size: 28,
            ),
            onPressed: () {
              DateTime datetime = DateTime.now();
              final date = DateFormat('dd/MM/yyyy').format(datetime);
              final day = DateFormat('EEEE').format(datetime);
              final time = DateFormat('hh:mm:a').format(datetime);
              _cashin.clear();
              _cashout.clear();
              _particular.clear();
              _date.clear();

              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Add Transaction",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.close, size: 20),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Transaction Type Buttons
                          Row(
                            children: [
                              // Cash In
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    _showCashDialog(
                                        context, 'Cash In', date, day, time);
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFF30CB76)
                                              .withOpacity(0.8),
                                          const Color(0xFF30CB76),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.arrow_downward,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          "Cash In",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Cash Out
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    _showCashDialog(
                                        context, 'Cash Out', date, day, time);
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFFF31717)
                                              .withOpacity(0.8),
                                          const Color(0xFFF31717),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.arrow_upward,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          "Cash Out",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
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
            },
          ),
        ));
  }

  void _showCashDialog(BuildContext context, String transactionType,
      String date, String day, String time) {
    final TextEditingController controller = TextEditingController();
    final TextEditingController particularController = TextEditingController();
    final TextEditingController dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: transactionType == 'Cash In'
                          ? [const Color(0xFF30CB76), const Color(0xFF26A65B)]
                          : [const Color(0xFFF31717), const Color(0xFFD32F2F)],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          transactionType == 'Cash In'
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "$transactionType Details",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Amount Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Text(
                                '₹',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            hintText: '0.00',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Particular Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: TextField(
                          controller: particularController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.description_outlined,
                              color: Colors.grey[600],
                            ),
                            hintText: 'Add description',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Date Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: TextField(
                          controller: dateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.grey[600],
                            ),
                            hintText: 'Select date',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: transactionType == 'Cash In'
                                          ? const Color(0xFF30CB76)
                                          : const Color(0xFFF31717),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
                              dateController.text = formattedDate;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: transactionType == 'Cash In'
                                  ? [
                                      const Color(0xFF30CB76),
                                      const Color(0xFF26A65B)
                                    ]
                                  : [
                                      const Color(0xFFF31717),
                                      const Color(0xFFD32F2F)
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: (transactionType == 'Cash In'
                                        ? const Color(0xFF30CB76)
                                        : const Color(0xFFF31717))
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                final amount = controller.text.trim();
                                final particular =
                                    particularController.text.trim();
                                final selectedDate = dateController.text.trim();

                                if (amount.isNotEmpty) {
                                  final data = Datamodel(
                                    cashIn: transactionType == 'Cash In'
                                        ? amount
                                        : '0',
                                    cashout: transactionType == 'Cash Out'
                                        ? amount
                                        : '0',
                                    date: selectedDate.isNotEmpty
                                        ? selectedDate
                                        : date,
                                    particular:
                                        particular.isNotEmpty ? particular : '',
                                    day: day,
                                    uid: Provider.of<UserController>(context,
                                            listen: false)
                                        .uid,
                                    time: time,
                                  );
                                  Provider.of<Datacontroller>(context,
                                          listen: false)
                                      .addDatafireBase(data: data);
                                  Navigator.pop(context);
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: const Center(
                                  child: Text(
                                    "Add Transaction",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
