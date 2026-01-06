import 'package:budgetly/constants/colors.dart';
import 'package:budgetly/controller/dataController.dart';
import 'package:budgetly/decoration/decoration.dart';
import 'package:budgetly/view/dashboard/dashboardwidget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

enum SelectedType { none, income, expense, balance }

class _DashboardState extends State<Dashboard> {
  SelectedType selected = SelectedType.none;
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<Datacontroller>(
      builder: (context, provider, _) {
        
        final balance = provider.totalCash();

        return Scaffold(
          backgroundColor: const Color(0xfff5f6fa),
          appBar: AppBar(
            title: text("Dashboard", Colors.white, 23, FontWeight.bold),
            centerTitle: true,
            backgroundColor: Appcolors.backgroundblue,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // -------- PIE CHART --------
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: cardDecoration(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 320,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback: (event, response) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          response == null ||
                                          response.touchedSection == null) {
                                        touchedIndex = -1;
                                        return;
                                      }
                                      touchedIndex =
                                          response
                                              .touchedSection!
                                              .touchedSectionIndex;
                                    });
                                  },
                                ),
                                centerSpaceRadius: 70,
                                sectionsSpace: 4,
                                sections: buildSections(
                                provider.totalIncome(),
                                provider.totalExpense(),
                                ),
                              ),
                            ),

                            // 🔹 CENTER BALANCE
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Balance",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "₹${balance.toStringAsFixed(0)}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        balance <0 ? Colors.red : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // -------- CLICKABLE LEGEND --------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          legendItem(
                            color: Colors.green,
                            text: "Income",
                            onTap:
                                () => setState(
                                  () => selected = SelectedType.income,
                                ),
                          ),
                          legendItem(
                            color: Colors.red,
                            text: "Expense",
                            onTap:
                                () => setState(
                                  () => selected = SelectedType.expense,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // -------- DYNAMIC CONTENT --------
                Expanded(child: 
                
                
                buildDetails(provider)),
              ],
            ),
          ),
        );
      },
    );
  }



Widget buildDetails(Datacontroller provider) {
  
    switch (selected) {
      case SelectedType.income:
        return categoryList(
          "Income Categories",
          provider.incomeCategoryMap(),
          Colors.green,
        );

      case SelectedType.expense:
        return categoryList(
          "Expense Categories",
          provider.expenseCategoryMap(),
          Colors.red,
        );

      case SelectedType.balance:
        return Center(
          child: Text(
            "Balance: ₹${provider.totalCash().toStringAsFixed(0)}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        );

      default:
        return const Center(
          child: Text(
            "Tap a color above to view details",
            style: TextStyle(color: Colors.grey),
          ),
        );
    }
  }

  // ================= PIE SECTIONS =================

  List<PieChartSectionData> buildSections(
    double totalIncome,
    double totalExpense,
  ) {
    final data = [
      ('Income', totalIncome, Colors.green),
      ('Expense', totalExpense, Colors.red),
    ];

    return List.generate(data.length, (index) {
      final isTouched = index == touchedIndex;
      return PieChartSectionData(
        value: data[index].$2,
        color: data[index].$3,
        radius: isTouched ? 65 : 55,
        title:
            isTouched
                ? "₹${data[index].$2.toStringAsFixed(0)}"
                : data[index].$1,
        titleStyle: TextStyle(
          color: Colors.white,
          fontSize: isTouched ? 18 : 13,
          fontWeight: FontWeight.bold,
        ),
      );
    });
  }



  
}
