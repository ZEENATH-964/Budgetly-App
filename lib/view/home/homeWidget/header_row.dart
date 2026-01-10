import 'package:budgetly/controller/dataController.dart';
import 'package:budgetly/decoration/decoration.dart';
import 'package:budgetly/view/home/homeWidget/dialogue/dilogue.dart';
import 'package:flutter/material.dart';

import 'package:budgetly/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HeaderRow extends StatelessWidget {
  const HeaderRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: containers(
        height: 40,
        color: Colors.white,
        radius: 12,
        shadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: Offset(0, 1)),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text('Date', Colors.grey, 15, FontWeight.w600),
              SizedBox(width: 50),
              text('Cash in', Appcolors.greencolors, 15, FontWeight.w600),
              text('Cash out', Appcolors.redcolors, 15, FontWeight.w600),
            ],
          ),
        ),
      ),
    );
  }
}




class TotalCashCard extends StatelessWidget {
  const TotalCashCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return containers(
      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      radius: 15,
      shadow: [BoxShadow(color: Appcolors.backgroundblue.withOpacity(0.3), spreadRadius: 1, blurRadius: 8, offset: Offset(0, 3))],
      gradient: LinearGradient(colors: [Appcolors.backgroundblue, Appcolors.backgroundblue.withOpacity(0.8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      child: Consumer<Datacontroller>(
        builder: (context, dataController, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.white, size: 24),
              SizedBox(width: 10),
              text('Total Balance: ₹${dataController.totalCash().toStringAsFixed(2)}', Colors.white, 18, FontWeight.bold),
            ],
          );
        },
      ),
    );
  }
}







class FilterButtons extends StatelessWidget {
  const FilterButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Datacontroller>(
      builder: (context, value, child) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['All', 'Daily', 'Weekly', 'Monthly'].map((filter) {
              bool isSelected = value.selected == filter;
              return SizedBox(
                height: 35,
                child: ElevatedButton(
                  onPressed: () {
                    value.selectedColor(filter);
                    if (filter == 'Monthly') {
                      String currentMonth = DateFormat('MMMM').format(DateTime.now());
                      value.getdata('Monthly', currentMonth);
                    } else {
                      value.getdata(filter);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: isSelected ? Appcolors.whitecolors : Appcolors.backgroundblue,
                    backgroundColor: isSelected ? Appcolors.greycolors.shade400 : Appcolors.whitecolors,
                    elevation: isSelected ? 3 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Appcolors.backgroundblue, width: isSelected ? 0 : 1),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: text(filter, Colors.black, 14, isSelected ? FontWeight.bold : FontWeight.normal),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          if (value.selected == 'Monthly')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: containers(
                padding: EdgeInsets.symmetric(horizontal: 12),
                radius: 12,
                color: Colors.white,
                border: Border.all(color: Colors.blue.shade200),
                child: DropdownButton<String>(
                 value: value.selectedMonth,
                  isExpanded: true,
                  underline: SizedBox.shrink(),
                  items: List.generate(12, (i) {
                    String month = DateFormat('MMMM').format(DateTime(DateTime.now().year, i + 1, 1));
                    return DropdownMenuItem(value: month, child: Text(month));
                  }),
                  onChanged: (selectedMonth) {
  if (selectedMonth != null) {
    value.getdata("Monthly", selectedMonth);
  }
},

                ),
              ),
            ),
        ],
      ),
    );
  }
}




void showAddTransactionDialog(BuildContext context) {
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
              // 🔹 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text(
                    "Add Transaction",
                    Colors.black,
                    18,
                    FontWeight.bold,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 20),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 🔹 CASH IN / CASH OUT
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.pop(context);
                        showCashDialog(context, 'Cash In');
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
                            const Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            text(
                              "Cash In",
                              Colors.white,
                              14,
                              FontWeight.bold,
                            ),
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
                        showCashDialog(context, 'Cash Out');
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
                            const Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            text(
                              "Cash Out",
                              Colors.white,
                              14,
                              FontWeight.bold,
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
}
