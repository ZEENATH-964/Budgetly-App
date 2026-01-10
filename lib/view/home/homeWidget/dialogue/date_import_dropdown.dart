import 'package:budgetly/controller/dataController.dart';
import 'package:budgetly/controller/login.dart';
import 'package:budgetly/model/dataModel.dart';
import 'package:budgetly/model/import_transactiondb.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//dropdown

Widget categoryDropdown({
  required String transactionType,
  required String? value,
  required Function(String?) onChanged,
}) {
  final List<String> expenseCategories = [
    'Food',
    'Travel',
    'Shopping',
    'Others',
  ];

  final List<String> incomeSources = [
    'Salary',
    'Business',
    'Others',
  ];

  final items =
      transactionType == 'Cash In' ? incomeSources : expenseCategories;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        hint: Text(
          transactionType == 'Cash In'
              ? 'Select income source'
              : 'Select expense category',
          style: TextStyle(color: Colors.grey[400]),
        ),
        isExpanded: true,
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );
}

//date

Widget datePickerField({
  required BuildContext context,
  required TextEditingController controller,
  required String transactionType,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: TextField(
      controller: controller,
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
          controller.text =
              DateFormat('dd-MM-yyyy').format(pickedDate);
        }
      },
    ),
  );
}

//import

Widget importExcelButton({
  required VoidCallback onTap,
}) {
  return Align(
    alignment: Alignment.centerRight,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: 150,
        margin: const EdgeInsets.only(top: 16, right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.upload_file,
              color: Colors.blueGrey,
              size: 20,
            ),
            SizedBox(width: 6),
            Text(
              "Import file",
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

//acton button

Widget actionButtons({
  required BuildContext context,
  required String transactionType,
  required TextEditingController amountController,
  required TextEditingController particularController,
  required TextEditingController dateController,
  required String? selectedCategory,
}) {
  return Container(
    padding: const EdgeInsets.all(24),
    color: Colors.grey[50],
    child: Row(
      children: [
        // -------- CANCEL --------
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // -------- ADD TRANSACTION --------
        Expanded(
          child: ElevatedButton(
      onPressed: () async {
  final dataController =
      Provider.of<Datacontroller>(context, listen: false);

  final importBox =
      Hive.box<ImportTransactiondb>('import_transactions');

  final uid =
      Provider.of<UserController>(context, listen: false).uid;

  if (uid == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User not logged in")),
    );
    return;
  }

  // 🔹 CASE 1: IMPORT DATA EXISTS → COMMIT IMPORT
  if (importBox.isNotEmpty) {
    await dataController.syncImportedTransactionsFromHive();

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Imported transactions added"),
      ),
    );
    return;
  }

  // 🔹 CASE 2: MANUAL ADD
  final amount = amountController.text.trim();

  if (amount.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Enter amount")),
    );
    return;
  }

  DateTime now = DateTime.now();
  DateTime finalDate;

  if (dateController.text.isNotEmpty) {
    final pickedDate =
        DateFormat('dd-MM-yyyy').parse(dateController.text);

    finalDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      now.hour,
      now.minute,
      now.second,
    );
  } else {
    finalDate = now;
  }

  final data = Datamodel(
    cashIn: transactionType == 'Cash In' ? amount : '0',
    cashout: transactionType == 'Cash Out' ? amount : '0',
    createdAt: finalDate,
    particular: particularController.text.trim(),
    category: selectedCategory ?? 'Others',
    uid: uid,
  );

  await dataController.addDatafireBase(data: data);

  Navigator.pop(context);
},


            style: ElevatedButton.styleFrom(
              backgroundColor: transactionType == 'Cash In'
                  ? const Color(0xFF30CB76)
                  : const Color(0xFFF31717),
              padding:
                  const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Add Transaction",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),   
      ],
    ),
  );
}


