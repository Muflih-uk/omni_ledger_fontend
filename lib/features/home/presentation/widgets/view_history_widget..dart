import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/features/main/presentation/bloc/bloc.dart';
import 'package:omni_ledger/features/main/presentation/bloc/event.dart';

class ViewHistoryWidget extends StatelessWidget {
  final BuildContext? context;

  const ViewHistoryWidget({super.key, this.context});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<NavigationBloc>().add(MainChangeTabEvent(2));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white54,
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
                color: Colors.white54,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(6),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: AppConstants.primaryColor,
                  size: 30,
                ),
              ),
            ),
            SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "View History",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
