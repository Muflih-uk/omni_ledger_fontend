import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_bloc.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_event.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_state.dart';
import 'package:omni_ledger/features/bill/presentation/widgets/history_bill_card.dart';
import 'package:omni_ledger/features/bill/presentation/widgets/history_status_tabs.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(FetchBillsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HistoryBloc, HistoryState>(
      listenWhen: (prev, curr) =>
          prev.error != curr.error && curr.error != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(state.error!),
              behavior: SnackBarBehavior.floating,
            ),
          );
      },
      child: Container(
        decoration: BoxDecoration(gradient: AppConstants.bgGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HistoryStatusTabs(),
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Text(
                  "RECENT TRANSACTION",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Expanded(
                child: BlocBuilder<HistoryBloc, HistoryState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final bills = state.filteredBills;

                    if (state.error != null && bills.isEmpty) {
                      return _buildError(context);
                    }

                    if (bills.isEmpty) {
                      return _buildEmpty(context, state.currentTab);
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<HistoryBloc>().add(FetchBillsEvent());
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: bills.length,
                        itemBuilder: (context, index) {
                          final bill = bills[index];

                          return HistoryBillCard(
                            bill: bill,
                            isToggling: state.togglingIds.contains(bill.id),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HistoryBloc>().add(FetchBillsEvent());
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_off,
                  color: AppConstants.neutralColor,
                  size: 56,
                ),
                const SizedBox(height: 12),
                Text(
                  "Failed to load bills",
                  style: TextStyle(
                    color: AppConstants.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, String currentTab) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HistoryBloc>().add(FetchBillsEvent());
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  color: AppConstants.hintColor,
                  size: 56,
                ),
                const SizedBox(height: 12),
                Text(
                  currentTab == "paid"
                      ? "No paid bills yet"
                      : "No unpaid bills yet",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppConstants.neutralColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
