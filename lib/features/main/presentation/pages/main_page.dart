import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/features/bill/presentation/pages/create_bill_page.dart';
import 'package:omni_ledger/features/bill/presentation/pages/history_page.dart';
import 'package:omni_ledger/features/home/presentation/pages/home_page.dart';
import 'package:omni_ledger/features/inventory/presentation/pages/inventory_page.dart';
import 'package:omni_ledger/features/main/presentation/bloc/bloc.dart';
import 'package:omni_ledger/features/main/presentation/bloc/event.dart';
import 'package:omni_ledger/features/main/presentation/bloc/state.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  final List<Widget> pages = const [
    HomePage(),
    CreateBillPage(),
    HistoryPage(),
    InventoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBloc(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(gradient: AppConstants.bgGradient),
            child: Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: const Text("Omni Ledger"),
              ),
              body: pages[state.currentIndex],
              bottomNavigationBar: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(4, (index) {
                    final isSelected = state.currentIndex == index;

                    final icons = [
                      Icons.home,
                      Icons.receipt,
                      Icons.history,
                      Icons.inventory,
                    ];

                    final labels = ["Home", "Billing", "History", "Inventory"];

                    return GestureDetector(
                      onTap: () {
                        context.read<NavigationBloc>().add(
                          MainChangeTabEvent(index),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppConstants.primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icons[index],
                              color: isSelected
                                  ? Colors.white
                                  : AppConstants.neutralColor,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              labels[index],
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppConstants.neutralColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  context.go(AppConstants.additemPage);
                },
                child: Icon(Icons.add),
              ),
            ),
          );
        },
      ),
    );
  }
}
