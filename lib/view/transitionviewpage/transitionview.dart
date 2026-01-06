

import 'package:budgetly/model/dataModel.dart';
import 'package:budgetly/view/transitionviewpage/detailrow.dart';
import 'package:budgetly/view/transitionviewpage/editingdialogue.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionDetailsPage extends StatefulWidget {
  final Datamodel data;

  const TransactionDetailsPage({Key? key, required this.data})
      : super(key: key);

  @override
  _TransactionDetailsPageState createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  late TextEditingController amountController;
  late TextEditingController particularController;
  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(
        text: widget.data.cashIn != '0'
            ? widget.data.cashIn
            : widget.data.cashout);
    particularController = TextEditingController(text: widget.data.particular);
    dateController = TextEditingController(
  text: DateFormat('dd-MM-yyyy').format(widget.data.createdAt),
);

  }

  @override
  void dispose() {
    amountController.dispose();
    particularController.dispose();
    dateController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final bool isCashIn = data.cashIn != '0';
    final String amount = isCashIn ? data.cashIn ?? "0" : data.cashout ?? "0";

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0XFF0008B4),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Transaction Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed:(){
                   generateAndSharePdf(context, data);
              } ,
              icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
              tooltip: 'Generate PDF',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed:(){
                 shareViaWhatsApp(context,data);
              } ,
              icon: const Icon(Icons.share, color: Colors.white),
              tooltip: 'Share',
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Amount
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0XFF0008B4), Color(0XFF000490)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCashIn ? Icons.arrow_downward : Icons.arrow_upward,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isCashIn ? "Cash In" : "Cash Out",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "₹ $amount",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Transaction Details Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Transaction Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      detailRow(
  "Date",
  DateFormat('dd MMM yyyy').format(data.createdAt),
  Icons.calendar_today,
),
const Divider(height: 1),

detailRow(
  "Time",
  DateFormat('hh:mm a').format(data.createdAt),
  Icons.access_time,
),
const Divider(height: 1),

detailRow(
  "Day",
  DateFormat('EEEE').format(data.createdAt),
  Icons.today,
),

                      const Divider(height: 1),
                      detailRow("Particular", data.particular ?? "",
                          Icons.description),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isCashIn
                              ? const Color(0XFF30CB76).withOpacity(0.1)
                              : const Color(0XFFF31717).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isCashIn
                                      ? Icons.arrow_circle_down
                                      : Icons.arrow_circle_up,
                                  color: isCashIn
                                      ? const Color(0XFF30CB76)
                                      : const Color(0XFFF31717),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  isCashIn ? "Cash In" : "Cash Out",
                                  style: TextStyle(
                                    color: isCashIn
                                        ? const Color(0XFF30CB76)
                                        : const Color(0XFFF31717),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "₹ $amount",
                              style: TextStyle(
                                color: isCashIn
                                    ? const Color(0XFF30CB76)
                                    : const Color(0XFFF31717),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                        showEditDialog(context: context,
                         oldData: data, 
                         amountController: amountController, 
                         particularController: particularController,
                          dateController: dateController);
},

                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.edit, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  "Edit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (){
                            confirmDelete(context: context, id: data.id!);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
