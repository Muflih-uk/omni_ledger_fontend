import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text("Add Item")),

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
          return Padding(
            padding: const EdgeInsets.all(16),

            child: Form(
              key: _formKey,

              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Item Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter item name";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Unit Price"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter price";
                      }
                      if (double.tryParse(value) == null) {
                        return "Invalid number";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: state is ItemLoading ? null : _submit,
                    child: state is ItemLoading
                        ? const CircularProgressIndicator()
                        : const Text("Create Item"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
