import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_bloc.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_event.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_state.dart';
import 'package:omni_ledger/injection_container.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/shared/ui/app_text_field.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ItemBloc>()..add(FetchItemEvent()),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: AppTextField(
              hintText: "Find items",
              prefixIcon: Icon(Icons.search, color: AppConstants.hintColor),
              onChanged: (value) {
                context.read<ItemBloc>().add(SearchItemEvent(value));
              },
            ),
          ),

          Expanded(
            child: BlocBuilder<ItemBloc, ItemState>(
              builder: (context, state) {
                if (state is ItemLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppConstants.primaryColor,
                    ),
                  );
                }

                if (state is ItemLoaded) {
                  return ListView.builder(
                    itemCount: state.filterItems.length,
                    itemBuilder: (context, index) {
                      final item = state.filterItems[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Row(
                                //   children: const [
                                //     Icon(
                                //       Icons.edit,
                                //       size: 16,
                                //       color: Colors.black54,
                                //     ),
                                //     SizedBox(width: 4),
                                //     Text(
                                //       "Edit",
                                //       style: TextStyle(color: Colors.black54),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),

                            Text(
                              "₹${item.unitPrice}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppConstants.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                if (state is ItemError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
