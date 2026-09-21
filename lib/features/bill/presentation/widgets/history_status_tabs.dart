import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_bloc.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_event.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_state.dart';

class HistoryStatusTabs extends StatelessWidget {
  const HistoryStatusTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(18),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppConstants.searchBarColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                _buildTab(
                  context,
                  state,
                  value: "paid",
                  title: "Paid (${state.paidCount})",
                ),
                _buildTab(
                  context,
                  state,
                  value: "unpaid",
                  title: "Unpaid (${state.unpaidCount})",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTab(
    BuildContext context,
    HistoryState state, {
    required String value,
    required String title,
  }) {
    final isSelected = state.currentTab == value;

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
                : const [],
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
}