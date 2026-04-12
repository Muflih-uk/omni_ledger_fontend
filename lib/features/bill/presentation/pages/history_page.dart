import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_bloc.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_event.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_state.dart';
import 'package:omni_ledger/features/bill/presentation/widgets/build_tab.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(FetchBillsEvent("paid"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(18),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppConstants.hintColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      buildTab(
                        context: context,
                        title: "Paid Bills",
                        value: "paid",
                        isSelected: state.currentTab == "paid",
                      ),
                      buildTab(
                        context: context,
                        title: "Unpaid Bills",
                        value: "unpaid",
                        isSelected: state.currentTab == "unpaid",
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          Padding(
            padding: EdgeInsetsGeometry.only(left: 18),
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

                if (state.bills.isEmpty) {
                  return const Center(child: Text("No Data"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.bills.length,
                  itemBuilder: (context, index) {
                    final bill = state.bills[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xFFE0F4FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: AppConstants.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bill.customerName.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${bill.customerPhone}",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFB876),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  bill.paymentStatus.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppConstants.tertiaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "TOTAL AMOUNT",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "₹${bill.totalAmount}",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
