import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/features/bill/presentation/pages/create_bill_page.dart';
import 'package:omni_ledger/features/inventory/presentation/pages/inventory_page.dart';
import 'package:omni_ledger/features/main/presentation/bloc/bloc.dart';
import 'package:omni_ledger/features/main/presentation/bloc/event.dart';
import 'package:omni_ledger/features/main/presentation/bloc/state.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  final List<Widget> pages = const [
    Center(child: Text("Home Page")),
    CreateBillPage(),
    Center(child: Text("History Page")),
    InventoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBloc(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text("Omni Ledger")),
            body: pages[state.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: state.currentIndex,
              onTap: (index) {
                context.read<NavigationBloc>().add(ChangeTabEvent(index));
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt),
                  label: "Billing",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: "History",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.inventory),
                  label: "Inventory",
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.go(AppConstants.additemPage);
              },
              child: Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
