import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/core/util/validator.dart';
import 'package:omni_ledger/shared/ui/app_text_button.dart';
import 'package:omni_ledger/shared/ui/app_text_form_field.dart';

import '../bloc/item_bloc.dart';
import '../bloc/item_event.dart';
import '../bloc/item_state.dart';

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = nameController.text.trim();
      final price = double.parse(priceController.text.trim());

      context.read<ItemBloc>().add(
        CreateItemEvent(name: name, unitPrice: price),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppConstants.screenPadding,
      decoration: BoxDecoration(gradient: AppConstants.bgGradient),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.go(AppConstants.mainPage);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: const Text("Omni Ledger"),
        ),

        body: BlocConsumer<ItemBloc, ItemState>(
          listener: (context, state) {
            if (state is ItemCreated) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Item Created")));
              nameController.clear();
              priceController.clear();
            }

            if (state is ItemError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },

          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Text(
                    "CATALOG MANAGEMENT",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    "New Inventory Item",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "Add essential product details to your digital ledger.",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(height: 60),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Item Name",
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              AppTextFormField(
                                controller: nameController,
                                hintText: "e.g Premium Silk Scarf",
                                keyboardType: TextInputType.text,
                                validator: Validators.itemName,
                              ),

                              SizedBox(height: 20),

                              Text(
                                "Unit Price",
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              AppTextFormField(
                                controller: priceController,
                                hintText: "0.00",
                                keyboardType: TextInputType.number,
                                validator: Validators.itemPrice,
                              ),

                              SizedBox(height: 30),
                              AppTextButton(
                                onPressed: state is ItemLoading
                                    ? () {}
                                    : () => _submit(),
                                text: state is ItemLoading
                                    ? "Loading"
                                    : "Save Item",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Padding(
//   padding: const EdgeInsets.all(16),

//   child: Form(
//     key: _formKey,

//     child: Column(
//       children: [
//         TextFormField(
//           controller: nameController,
//           decoration: const InputDecoration(labelText: "Item Name"),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return "Enter item name";
//             }
//             return null;
//           },
//         ),

//         const SizedBox(height: 12),

//         TextFormField(
//           controller: priceController,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(
//             labelText: "Unit Price",
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return "Enter price";
//             }
//             if (double.tryParse(value) == null) {
//               return "Invalid number";
//             }
//             return null;
//           },
//         ),

//         const SizedBox(height: 20),

//         ElevatedButton(
//           onPressed: state is ItemLoading ? null : _submit,
//           child: state is ItemLoading
//               ? const CircularProgressIndicator()
//               : const Text("Create Item"),
//         ),
//       ],
//     ),
//   ),
// );
