import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/core/util/validator.dart';
import 'package:omni_ledger/features/inventory/domain/entities/item.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_bloc.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_event.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_state.dart';
import 'package:omni_ledger/shared/ui/app_text_button.dart';
import 'package:omni_ledger/shared/ui/app_text_form_field.dart';
import 'package:omni_ledger/shared/ui/success_dialog.dart';

class ItemFormPage extends StatefulWidget {
  final Item? item;

  const ItemFormPage({super.key, this.item});

  @override
  State<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController priceController;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item?.name);
    priceController = TextEditingController(
      text: widget.item?.unitPrice.toString(),
    );
  }

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

      if (_isEditing) {
        context.read<ItemBloc>().add(
          UpdateItemEvent(
            itemId: widget.item!.id,
            name: name,
            unitPrice: price,
          ),
        );
      } else {
        context.read<ItemBloc>().add(
          CreateItemEvent(name: name, unitPrice: price),
        );
      }
    }
  }

  void _showCreatedDialog() {
    showAppSuccessDialog(
      context,
      title: "Item Created",
      message: "\"${nameController.text.trim()}\" was added to your catalog.",
      actions: [
        SuccessAction(
          label: "Add Next Item",
          onTap: () {
            nameController.clear();
            priceController.clear();
          },
        ),
        SuccessAction(
          label: "Back to Inventory",
          onTap: () => context.go(AppConstants.mainPageInventory),
        ),
      ],
    );
  }

  void _showUpdatedDialog() {
    showAppSuccessDialog(
      context,
      title: "Item Updated",
      message: "Your item changes have been saved.",
      actions: [
        SuccessAction(
          label: "Back to Inventory",
          onTap: () => context.go(AppConstants.mainPageInventory),
        ),
      ],
    );
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
              context.go(AppConstants.mainPageInventory);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text("Omni Ledger"),
        ),

        body: BlocConsumer<ItemBloc, ItemState>(
          listenWhen: (prev, curr) =>
              curr is ItemCreated || curr is ItemUpdated || curr is ItemError,
          listener: (context, state) {
            if (state is ItemCreated) {
              _showCreatedDialog();
            }

            if (state is ItemUpdated) {
              _showUpdatedDialog();
            }

            if (state is ItemError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.message)));
            }
          },

          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    "CATALOG MANAGEMENT",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    _isEditing ? "Edit Item" : "New Inventory Item",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    _isEditing
                        ? "Update the product details in your ledger."
                        : "Add essential product details to your digital ledger.",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 60),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
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

                          const SizedBox(height: 20),

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

                          const SizedBox(height: 30),
                          AppTextButton(
                            onPressed: state is ItemLoading ? () {} : _submit,
                            text: state is ItemLoading
                                ? "Loading"
                                : _isEditing
                                ? "Update Item"
                                : "Save Item",
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
