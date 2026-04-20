import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/core/util/validator.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_bloc.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_event.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_state.dart';
import 'package:omni_ledger/shared/ui/app_text_button.dart';
import 'package:omni_ledger/shared/ui/app_text_field.dart';
import 'package:omni_ledger/shared/ui/app_text_form_field.dart';

import '../../../inventory/presentation/bloc/item_bloc.dart';
import '../../../inventory/presentation/bloc/item_event.dart';
import '../../../inventory/presentation/bloc/item_state.dart';

class CreateBillPage extends StatefulWidget {
  const CreateBillPage({super.key});

  @override
  State<CreateBillPage> createState() => _CreateBillPageState();
}

class _CreateBillPageState extends State<CreateBillPage> {
  final _formKey = GlobalKey<FormState>();

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: BlocConsumer<BillingBloc, BillingState>(
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
              return Padding(
                padding: AppConstants.screenPadding,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                color: AppConstants.containerColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person_search,
                                        color: AppConstants.primaryColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Customer Details",
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: AppConstants.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 20),
                                        AppTextFormField(
                                          hintText: "00000 00000",
                                          controller: phoneController,
                                          keyboardType: TextInputType.number,
                                          validator: Validators.phone,
                                        ),
                                        const SizedBox(height: 16),
                                        AppTextFormField(
                                          hintText: "Enter name",
                                          controller: nameController,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            AppTextField(
                              hintText: "Search item name",
                              onChanged: (value) {
                                context.read<ItemBloc>().add(
                                  SearchItemEvent(value),
                                );
                              },
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppConstants.hintColor,
                              ),
                            ),

                            const SizedBox(height: 10),

                            SizedBox(
                              height: 200,
                              child: BlocBuilder<ItemBloc, ItemState>(
                                builder: (context, state) {
                                  if (state is ItemLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  if (state is ItemLoaded &&
                                      state.filterItems.isNotEmpty) {
                                    return ListView.builder(
                                      itemCount: state.filterItems.length,
                                      itemBuilder: (context, index) {
                                        final item = state.filterItems[index];

                                        return GestureDetector(
                                          onTap: () {
                                            context.read<BillingBloc>().add(
                                              AddItemEvent(item),
                                            );
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              top: 10,
                                            ),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  item.name,
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.labelSmall,
                                                ),
                                                Text(
                                                  "₹${item.unitPrice}",
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.labelMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }

                                  return const SizedBox();
                                },
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// SELECTED ITEMS TITLE
                            if (billState.selectedItems.isNotEmpty)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Selected Items (${billState.selectedItems.length})",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 10),

                            /// SELECTED ITEMS LIST
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                itemCount: billState.selectedItems.length,
                                itemBuilder: (context, index) {
                                  final item = billState.selectedItems[index];

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item["name"],
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.labelSmall,
                                              ),
                                              Text(
                                                "₹${item["price"]}",
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.labelMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove),
                                              onPressed: () {
                                                if (item["quantity"] > 1) {
                                                  context
                                                      .read<BillingBloc>()
                                                      .add(
                                                        UpdateQuantityEvent(
                                                          item["item_id"],
                                                          item["quantity"] - 1,
                                                        ),
                                                      );
                                                }
                                              },
                                            ),
                                            Text(
                                              "${item["quantity"]}",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelSmall,
                                            ),
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
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                context.read<BillingBloc>().add(
                                                  RemoveItemEvent(
                                                    item["item_id"],
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// 🔻 BOTTOM BAR
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          /// TOGGLE
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppConstants.searchBarColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      context.read<BillingBloc>().add(
                                        TogglePaymentEvent(false),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: billState.isPaid
                                            ? Colors.transparent
                                            : const Color(0xFFFFB876),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "NOT PAID",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: billState.isPaid
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      context.read<BillingBloc>().add(
                                        TogglePaymentEvent(true),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: billState.isPaid
                                            ? Colors.green[200]
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "PAID",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: billState.isPaid
                                              ? Colors.black
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// BUTTON
                          AppTextButton(
                            onPressed: billState.isLoading ? () {} : submit,
                            text: billState.isLoading
                                ? "Loading"
                                : "COMPLETE BILL",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
