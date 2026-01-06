import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgetly/controller/dataController.dart';
import 'package:budgetly/model/dataModel.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final Datamodel data;
  final VoidCallback onTap;

  const TransactionItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Datacontroller>(
      builder: (context, controller, _) {
        final isSelected =
            data.id != null && controller.selectedIds.contains(data.id);

        return InkWell(
          onLongPress: () {
            if (data.id != null) {
              controller.toggleSelection(data.id!);
            }
          },
          onTap: () {
            if (controller.isSelectionMode) {
              if (data.id != null) {
                controller.toggleSelection(data.id!);
              }
            } else {
              onTap();
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue.withOpacity(0.15)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 2,
              ),
            ),
            child: ListTile(
              leading: controller.isSelectionMode
                  ? Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: Colors.blue,
                    )
                  : null,
              title: Text(data.particular ?? "Transaction"),
              subtitle: Text(
                DateFormat('dd MMM yyyy, hh:mm a')
                    .format(data.createdAt),
              ),
            ),
          ),
        );
      },
    );
  }
}
