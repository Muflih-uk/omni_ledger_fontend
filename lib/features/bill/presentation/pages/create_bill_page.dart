import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_bloc.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_event.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_state.dart';

import '../../../inventory/presentation/bloc/item_bloc.dart';
import '../../../inventory/presentation/bloc/item_event.dart';
import '../../../inventory/presentation/bloc/item_state.dart';

class CreateBillPage extends StatefulWidget {
  const CreateBillPage({super.key});

  @override
  State<CreateBillPage> createState() => _CreateBillPageState();
}

class _CreateBillPageState extends State<CreateBillPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ItemBloc>().add(FetchItemEvent());
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void submit() {
    context.read<BillingBloc>().add(
      CreateBillEvent(name: nameController.text, phone: phoneController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Bill")),

      body: BlocConsumer<BillingBloc, BillingState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }

          if (!state.isLoading && state.selectedItems.isEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Bill Created")));
          }
        },

        builder: (context, billState) {
          return Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Customer Name"),
              ),

              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
              ),

              SwitchListTile(
                title: const Text("Paid"),
                value: billState.isPaid,
                onChanged: (val) {
                  context.read<BillingBloc>().add(TogglePaymentEvent(val));
                },
              ),

              TextField(
                decoration: const InputDecoration(
                  hintText: "Search items...",
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  context.read<ItemBloc>().add(SearchItemEvent(value));
                },
              ),

              const Divider(),

              Expanded(
                child: BlocBuilder<ItemBloc, ItemState>(
                  builder: (context, state) {
                    if (state is ItemLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is ItemLoaded) {
                      return ListView.builder(
                        itemCount: state.filterItems.length,
                        itemBuilder: (context, index) {
                          final item = state.filterItems[index];

                          return ListTile(
                            title: Text(item.name),
                            trailing: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                context.read<BillingBloc>().add(
                                  AddItemEvent(item),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),

              const Divider(),

              Expanded(
                child: ListView.builder(
                  itemCount: billState.selectedItems.length,
                  itemBuilder: (context, index) {
                    final item = billState.selectedItems[index];

                    return ListTile(
                      title: Text(item["name"]),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ➖
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (item["quantity"] > 1) {
                                context.read<BillingBloc>().add(
                                  UpdateQuantityEvent(
                                    item["item_id"],
                                    item["quantity"] - 1,
                                  ),
                                );
                              }
                            },
                          ),

                          Text("${item["quantity"]}"),

                          // ➕
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              context.read<BillingBloc>().add(
                                UpdateQuantityEvent(
                                  item["item_id"],
                                  item["quantity"] + 1,
                                ),
                              );
                            },
                          ),

                          // ❌
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<BillingBloc>().add(
                                RemoveItemEvent(item["item_id"]),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              ElevatedButton(
                onPressed: billState.isLoading ? null : submit,
                child: billState.isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Create Bill"),
              ),
            ],
          );
        },
      ),
    );
  }
}
