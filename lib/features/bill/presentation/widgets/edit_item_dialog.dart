import 'package:flutter/material.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/core/util/validator.dart';
import 'package:omni_ledger/shared/ui/app_text_form_field.dart';

class ItemEdit {
  final String name;
  final double price;

  const ItemEdit(this.name, this.price);
}

Future<ItemEdit?> showEditItemDialog(
  BuildContext context, {
  required String name,
  required double price,
}) {
  return showDialog<ItemEdit>(
    context: context,
    builder: (_) => EditItemDialog(name: name, price: price),
  );
}

class EditItemDialog extends StatefulWidget {
  final String name;
  final double price;

  const EditItemDialog({
    super.key,
    required this.name,
    required this.price,
  });

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _priceController = TextEditingController(
      text: widget.price == widget.price.roundToDouble()
          ? widget.price.toStringAsFixed(0)
          : widget.price.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _confirm() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    Navigator.of(context).pop(
      ItemEdit(
        _nameController.text.trim(),
        double.parse(_priceController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        "Edit Item",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Item Name", style: Theme.of(context).textTheme.labelLarge),
            AppTextFormField(
              controller: _nameController,
              hintText: "Enter item name",
              validator: Validators.itemName,
            ),
            const SizedBox(height: 12),
            Text("Price", style: Theme.of(context).textTheme.labelLarge),
            AppTextFormField(
              controller: _priceController,
              hintText: "Enter price",
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                final parsed = double.tryParse(value?.trim() ?? '');
                if (parsed == null || parsed < 0) {
                  return "Enter valid price";
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            "Cancel",
            style: TextStyle(color: AppConstants.secondaryColor),
          ),
        ),
        FilledButton(
          onPressed: _confirm,
          style: FilledButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            "Save",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}