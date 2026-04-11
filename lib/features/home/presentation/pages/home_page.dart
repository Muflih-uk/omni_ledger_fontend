import 'package:flutter/material.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/features/home/presentation/widgets/add_item_widget.dart';
import 'package:omni_ledger/features/home/presentation/widgets/new_bill_widget.dart';
import 'package:omni_ledger/features/home/presentation/widgets/view_history_widget..dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text("Welcome", style: Theme.of(context).textTheme.headlineLarge),
              Text(
                "Your retail floor is active today.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 20),
              NewBillWidget(context: context),
              SizedBox(height: 10),
              AddItemWidget(context: context),
              SizedBox(height: 10),
              ViewHistoryWidget(context: context),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
