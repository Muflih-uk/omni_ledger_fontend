import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_bloc.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_event.dart';

Widget buildTab({
  required BuildContext context,
  required String title,
  required String value,
  required bool isSelected,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        context.read<HistoryBloc>().add(ChangeTabEvent(value));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? AppConstants.primaryColor
                  : AppConstants.secondaryColor,
            ),
          ),
        ),
      ),
    ),
  );
}
