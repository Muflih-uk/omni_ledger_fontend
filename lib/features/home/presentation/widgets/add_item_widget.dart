import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';

class AddItemWidget extends StatelessWidget {
  final BuildContext? context;

  const AddItemWidget({super.key, this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
              color: AppConstants.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(6),
            child: Center(
              child: Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
          SizedBox(height: 10),
          Text("Add Item", style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 10),
          Text(
            "Register new stock into inventory",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  context.go(AppConstants.additemPage);
                },
                icon: Icon(
                  Icons.arrow_forward,
                  color: AppConstants.secondaryColor,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
