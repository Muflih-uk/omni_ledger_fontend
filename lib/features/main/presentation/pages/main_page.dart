import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/features/ads/presentation/widgets/banner_ad_widget.dart';
import 'package:omni_ledger/features/bill/presentation/pages/billing_page.dart';
import 'package:omni_ledger/features/bill/presentation/pages/history_page.dart';
import 'package:omni_ledger/features/home/presentation/pages/home_page.dart';
import 'package:omni_ledger/features/inventory/presentation/pages/inventory_page.dart';
import 'package:omni_ledger/features/main/presentation/bloc/bloc.dart';
import 'package:omni_ledger/features/main/presentation/bloc/event.dart';
import 'package:omni_ledger/features/main/presentation/bloc/state.dart';
import 'package:omni_ledger/features/main/presentation/widgets/main_navigation_bar.dart';

class MainPage extends StatelessWidget {
  final int initialIndex;
  const MainPage({super.key, this.initialIndex = 0});

  final List<Widget> pages = const [
    HomePage(),
    BillingPage(),
    HistoryPage(),
    InventoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBloc(initialIndex: initialIndex),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(gradient: AppConstants.bgGradient),
            child: Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: const Text("Omni Ledger"),
              ),
              body: Column(
                children: [
                  const BannerAdWidget(),
                  Expanded(child: pages[state.currentIndex]),
                ],
              ),
              bottomNavigationBar: MainNavigationBar(
                currentIndex: state.currentIndex,
                onTabSelected: (index) {
                  context.read<NavigationBloc>().add(MainChangeTabEvent(index));
                },
              ),
              floatingActionButton: state.currentIndex == 3
                  ? FloatingActionButton(
                      onPressed: () {
                        context.go(AppConstants.additemPage);
                      },
                      child: Icon(Icons.add),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}