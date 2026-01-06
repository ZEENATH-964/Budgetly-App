import 'package:budgetly/constants/colors.dart';
import 'package:budgetly/controller/dataController.dart';
import 'package:budgetly/controller/login.dart';
import 'package:budgetly/decoration/decoration.dart';
import 'package:budgetly/view/home/homeWidget/dialogue/dilogue.dart';
import 'package:budgetly/view/home/drawer/drawer.dart';
import 'package:budgetly/view/home/homeWidget/header_row.dart';
import 'package:budgetly/view/transitionviewpage/transitionview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSearching = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
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

  void _filterSearch(String query) {
    Provider.of<Datacontroller>(context, listen: false).filterData(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xffF5F5F5),

      // ===================== APP BAR =====================
      appBar: AppBar(
        backgroundColor: Appcolors.backgroundblue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 28),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),

        centerTitle: true,
        title: Consumer<Datacontroller>(
  builder: (context, controller, _) {
    // 🔥 SELECTION MODE
    if (controller.isSelectionMode) {
      return Text(
        "${controller.selectedIds.length} selected",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    // 🔹 NORMAL MODE (search + title)
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _isSearching
          ? SizedBox(
              height: 40,
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Search transactions...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white70,
                    size: 18,
                  ),
                ),
                onChanged: _filterSearch,
              ),
            )
          : text("Cash Book", Colors.white, 22, FontWeight.bold),
    );
  },
),

        // RIGHT ACTION BUTTONS
        actions: [
  IconButton(
    icon: Icon(
      _isSearching ? Icons.close : Icons.search,
      color: Colors.white,
    ),
    onPressed: () {
      setState(() {
        _isSearching = !_isSearching;
        if (!_isSearching) {
          _searchController.clear();
          _filterSearch('');
        }
      });
    },
  ),

  // 🔥 CLEAR ALL BUTTON
  IconButton(
    icon: const Icon(Icons.delete, color: Colors.white),
    tooltip: "Delete all transactions",
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Delete All Transactions"),
          content: const Text(
            "Are you sure? This will permanently delete all transactions.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await Provider.of<Datacontroller>(
                  context,
                  listen: false,
                ).deleteAllTransactions();

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("All transactions deleted"),
                  ),
                );
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    },
  ),
],

      ),

      drawer: Consumer<UserController>(
        builder: (context, value, child) {
          return drawer(
            context: context,
            company: value.companyName ?? '',
            phone: value.phone ?? '',
          );
        },
      ),
      body: RefreshIndicator(
       onRefresh: () async {
  final controller =
      Provider.of<Datacontroller>(context, listen: false);

  if (controller.selected == 'Monthly') {
    await controller.getdata(
      'Monthly',
      controller.selectedMonth,
    );
  } else {
    await controller.getdata(controller.selected);
  }
},

        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // FILTER BUTTONS (Reusable Widget)
              containers(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                shadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2))
                ],
                child: const FilterButtons(),
              ),
              const HeaderRow(),
              const TotalCashCard(),
              Expanded(
                child: Consumer<Datacontroller>(
                  builder: (context, value, child) {
                    if (value.filteredData.isEmpty) {
                      return const Center(
                        child: Text("No Transactions Found",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 18)),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: value.filteredData.length,
                      itemBuilder: (context, index) {
                        final data = value.filteredData[index];

                        return TransactionItem(
                          data: data,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TransactionDetailsPage(data: data),
                              ),
                            );
                          },
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
  duration: const Duration(milliseconds: 300),
  child: FloatingActionButton(
    elevation: 8,
    tooltip: 'Add Transaction',
    backgroundColor: Appcolors.backgroundblue,
    child: Icon(Icons.add, color: Appcolors.whitecolors, size: 28),

    onPressed: () {
     

      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text("Add Transaction", Colors.black, 18, FontWeight.bold),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, size: 20),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ------------ CASH IN & CASH OUT ------------
                  Row(
                    children: [
                     
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.pop(context);
                            showCashDialog(context, 'Cash In',);
                          },
                          child: containers(
                            height: 100,
                            radius: 12,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF30CB76).withOpacity(0.8),
                                const Color(0xFF30CB76),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.arrow_downward,
                                    color: Colors.white, size: 28),
                                const SizedBox(height: 8),
                                text("Cash In", Colors.white, 14, FontWeight.bold),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.pop(context);
                            showCashDialog(context, 'Cash Out',);
                          },
                          child: containers(
                            height: 100,
                            radius: 12,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFF31717).withOpacity(0.8),
                                const Color(0xFFF31717),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.arrow_upward,
                                    color: Colors.white, size: 28),
                                const SizedBox(height: 8),
                                text("Cash Out", Colors.white, 14, FontWeight.bold),
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
),   
    );
  }
}



