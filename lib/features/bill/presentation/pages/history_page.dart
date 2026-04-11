import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_bloc.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_event.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_state.dart';

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
      appBar: AppBar(title: const Text("History")),

      body: Column(
        children: [
          BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              return Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<HistoryBloc>().add(ChangeTabEvent("paid"));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        color: state.currentTab == "paid"
                            ? Colors.blue
                            : Colors.grey[300],
                        child: const Center(child: Text("Paid")),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<HistoryBloc>().add(
                          ChangeTabEvent("unpaid"),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        color: state.currentTab == "unpaid"
                            ? Colors.blue
                            : Colors.grey[300],
                        child: const Center(child: Text("Unpaid")),
                      ),
                    ),
                  ),
                ],
              );
            },
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
                  itemCount: state.bills.length,
                  itemBuilder: (context, index) {
                    final bill = state.bills[index];

                    return ListTile(
                      title: Text(bill.customerName),
                      subtitle: Text(bill.customerPhone),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("₹${bill.totalAmount}"),
                          Text(bill.paymentStatus),
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
