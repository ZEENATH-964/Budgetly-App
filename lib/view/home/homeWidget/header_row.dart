import 'package:budgetly/controller/dataController.dart';
import 'package:budgetly/decoration/decoration.dart';
import 'package:budgetly/model/dataModel.dart';
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





class TransactionItem extends StatelessWidget {
  final Datamodel data;
  final VoidCallback onTap;
  const TransactionItem({Key? key, required this.data, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return containers(
      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      color: Colors.white,
      radius: 12,
      shadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 4, offset: Offset(0, 2))],
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(data.particular ?? 'Transaction', Colors.black87, 16, FontWeight.w600, maxLines: 1, overflow: TextOverflow.ellipsis),
                      SizedBox(height: 4),
                      Row(children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                        SizedBox(width: 4),
                        Flexible(child: text(DateFormat('dd MMM yyyy').format(data.createdAt), Colors.grey.shade600, 13, FontWeight.normal, overflow: TextOverflow.ellipsis)),
                        SizedBox(width: 12),
                        Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                        SizedBox(width: 4),
                        Flexible(child: text(  DateFormat('hh:mm a').format(data.createdAt), Colors.grey.shade600, 13, FontWeight.normal, overflow: TextOverflow.ellipsis)),
                      ]),
                    ],
                  ),
                ),
                Expanded(child: Text('\u20B9${data.cashIn ?? '0'}', textAlign: TextAlign.center, style: TextStyle(color: Appcolors.greencolors, fontSize: 16, fontWeight: FontWeight.bold))),
                Expanded(child: text('\u20B9${data.cashout ?? '0'}', Appcolors.redcolors, 16, FontWeight.bold, textAlign: TextAlign.center)),
              ],
            ),
          ),
        ),
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