import 'package:budgetly/constants/colors.dart';
import 'package:budgetly/controller/dataController.dart';
import 'package:budgetly/decoration/decoration.dart';
import 'package:budgetly/model/dataModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionItem extends StatelessWidget {
  final Datamodel data;
  final VoidCallback onTap;

  const TransactionItem({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Datacontroller>(
      builder: (context, controller, _) {
        final isSelected =
            data.id != null && controller.selectedIds.contains(data.id);

        return containers(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          color: isSelected
              ? Colors.blue.withOpacity(0.12)
              : Colors.white,
          radius: 12,
          shadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),

              /// 🔥 TAP LOGIC
              onTap: () {
                if (controller.selectionMode) {
                  if (data.id != null) {
                    controller.toggleSelection(data.id!);
                  }
                } else {
                  onTap();
                }
              },

              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [

                    /// ✅ CHECKBOX (ONLY selection mode)
                    if (controller.selectionMode)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          isSelected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: Colors.blue,
                        ),
                      ),

                    /// LEFT CONTENT
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(
                            data.particular ?? 'Transaction',
                            Colors.black87,
                            16,
                            FontWeight.w600,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 14, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Flexible(
                                child: text(
                                  DateFormat('dd MMM yyyy')
                                      .format(data.createdAt),
                                  Colors.grey.shade600,
                                  13,
                                  FontWeight.normal,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.access_time,
                                  size: 14, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Flexible(
                                child: text(
                                  DateFormat('hh:mm a')
                                      .format(data.createdAt),
                                  Colors.grey.shade600,
                                  13,
                                  FontWeight.normal,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// CASH IN
                    Expanded(
                      child: Text(
                        '\u20B9${data.cashIn ?? '0'}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Appcolors.greencolors,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    /// CASH OUT
                    Expanded(
                      child: text(
                        '\u20B9${data.cashout ?? '0'}',
                        Appcolors.redcolors,
                        16,
                        FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
