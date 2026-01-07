import 'package:budgetly/constants/colors.dart';
import 'package:budgetly/controller/dataController.dart';
import 'package:budgetly/controller/login.dart';
import 'package:budgetly/decoration/decoration.dart';
import 'package:budgetly/view/home/homeWidget/dialogue/dilogue.dart';
import 'package:budgetly/view/home/drawer/drawer.dart';
import 'package:budgetly/view/home/homeWidget/header_row.dart';
import 'package:budgetly/view/home/homeWidget/transaction_item.dart';
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
            if (controller.selectionMode) {
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
              child:
                  _isSearching
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
          Consumer<Datacontroller>(
            builder: (context, controller, _) {
              if (controller.selectionMode) {
                return const SizedBox();
              }
              return IconButton(
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
              );
            },
          ),

          Consumer<Datacontroller>(
            builder: (context, controller, _) {
              if (controller.selectionMode) {
                return IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    if (controller.selectedIds.isEmpty) {
                      controller.clearSelection();
                      return;
                    }
                    showDeleteDialog(
                      context: context,
                      title: "Delete Selected",
                      message:
                          "Delete ${controller.selectedIds.length} selected transactions?",
                      onConfirm: () async {
                        await controller.deleteSelectedTransactions();
                      },
                    );
                  },
                );
              }

              return IconButton(
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  controller.enableSelectionMode();
                },
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
          final controller = Provider.of<Datacontroller>(
            context,
            listen: false,
          );

          if (controller.selected == 'Monthly') {
            await controller.getdata('Monthly', controller.selectedMonth);
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
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                shadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
                child: const FilterButtons(),
              ),
              const HeaderRow(),
              const TotalCashCard(),

              Consumer<Datacontroller>(
                builder: (context, controller, _) {
                  if (!controller.selectionMode) {
                    return const SizedBox(); // ❌ hide normally
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          showDeleteDialog(
                            context: context,
                            title: "Delete All Transactions",
                            message:
                                "This will permanently delete all transactions.",
                            onConfirm: controller.deleteAllTransactions,
                          );
                        },
                        child: const Text(
                          "Delete All",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              Expanded(
                child: Consumer<Datacontroller>(
                  builder: (context, value, child) {
                    if (value.filteredData.isEmpty) {
                      return const Center(
                        child: Text(
                          "No Transactions Found",
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      );
                    }

                    return ListView.builder(
                      key: ValueKey(value.selectionMode),
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
                                builder:
                                    (context) =>
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

      floatingActionButton: FloatingActionButton(
  elevation: 8,
  tooltip: 'Add Transaction',
  backgroundColor: Appcolors.backgroundblue,
  child: Icon(Icons.add, color: Appcolors.whitecolors, size: 28),
  onPressed: () {
    showAddTransactionDialog(context);
  },
),

      );
    
  }
}
