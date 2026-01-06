 import 'package:budgetly/decoration/decoration.dart';
import 'package:budgetly/service/import_file_service.dart';
import 'package:budgetly/view/home/homeWidget/dialogue/date_import_dropdown.dart';
import 'package:flutter/material.dart';



void showCashDialog(
  BuildContext context,
  String transactionType,
  
) {
  final TextEditingController amountController  = TextEditingController();
  final TextEditingController particularController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
String? selectedCategory; 
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          
          return Dialog(
            backgroundColor: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: containers(
                color: Colors.white,

                shadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],

                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      containers(
                        padding: const EdgeInsets.all(20),

                        gradient: LinearGradient(
                          colors:
                              transactionType == 'Cash In'
                                  ? [
                                    const Color(0xFF30CB76),
                                    const Color(0xFF26A65B),
                                  ]
                                  : [
                                    const Color(0xFFF31717),
                                    const Color(0xFFD32F2F),
                                  ],
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
                            text(
                              "$transactionType Details",
                              Colors.white,
                              20,
                              FontWeight.bold,
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
                            containers(
                              color: Colors.grey[50]!,
                              radius: 12,
                              border: Border.all(color: Colors.grey[200]!),

                              child: TextField(
                                controller: amountController ,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  prefixIcon: Container(
                                    padding: const EdgeInsets.all(12),
                                    child: text(
                                      '₹',
                                      Colors.grey,
                                      24,
                                      FontWeight.bold,
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
                            containers(
                              color: Colors.grey[50]!,
                              radius: 12,
                              border: Border.all(color: Colors.grey[200]!),

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

                            datePickerField(
                              context: context,
                              controller: dateController,
                              transactionType: transactionType,
                            ),

                            // Source Dropdown
                            const SizedBox(height: 20),

                            categoryDropdown(
                              transactionType: transactionType,
                              value: selectedCategory,
                              onChanged: (val) {
                                setState(() {
                                  selectedCategory = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      importExcelButton(
  onTap: () async {
    await ImportTransactionFileService().pickAndImportFile();

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Transactions imported successfully"),
      ),
    );
  },
),


                      const SizedBox(height: 20),
                        actionButtons(
  context: context,
  transactionType: transactionType,
  amountController: amountController,
  particularController: particularController,
  dateController: dateController,
  selectedCategory: selectedCategory,
),

                     
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
