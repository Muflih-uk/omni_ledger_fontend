import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_bloc.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_event.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_state.dart';
import 'package:omni_ledger/injection_container.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';

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
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search items...",
                prefixIcon: Icon(Icons.search),
              ),
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

                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text("₹${item.price}"),
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
