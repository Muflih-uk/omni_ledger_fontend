import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/features/main/presentation/bloc/bloc.dart';
import 'package:omni_ledger/features/main/presentation/bloc/event.dart';

class NewBillWidget extends StatelessWidget {
  final BuildContext? context;

  const NewBillWidget({super.key, this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),

      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(6),
            child: Center(
              child: Icon(
                Icons.receipt,
                color: AppConstants.primaryColor,
                size: 30,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text("New Bill", style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: 10),
          Text(
            "Start a quick checkout for a customer",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  context.read<NavigationBloc>().add(MainChangeTabEvent(1));
                },
                child: Text(
                  "START BILLING",
                  style: TextStyle(color: AppConstants.primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
