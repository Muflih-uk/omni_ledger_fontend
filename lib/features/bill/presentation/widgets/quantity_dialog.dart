import 'package:flutter/material.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';

Future<int?> showQuantityDialog(
  BuildContext context, {
  required String itemName,
  required int initial,
}) {
  return showDialog<int>(
    context: context,
    builder: (_) => QuantityDialog(itemName: itemName, initial: initial),
  );
}

class QuantityDialog extends StatefulWidget {
  final String itemName;
  final int initial;

  const QuantityDialog({
    super.key,
    required this.itemName,
    required this.initial,
  });

  @override
  State<QuantityDialog> createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<QuantityDialog> {
  final ValueNotifier<int> _quantity = ValueNotifier<int>(1);
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _quantity.value = widget.initial < 1 ? 1 : widget.initial;
    _controller = TextEditingController(text: '${_quantity.value}');
  }

  @override
  void dispose() {
    _controller.dispose();
    _quantity.dispose();
    super.dispose();
  }

  void _set(int value) {
    _quantity.value = value < 1 ? 1 : value;
    _controller.text = '${_quantity.value}';
    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length,
    );
  }

  void _applyText(String value) {
    final parsed = int.tryParse(value.trim());
    if (parsed != null) {
      _quantity.value = parsed < 1 ? 1 : parsed;
    }
  }

  void _confirm() {
    final parsed = int.tryParse(_controller.text.trim());
    Navigator.of(context).pop(parsed == null || parsed < 1 ? 1 : parsed);
  }

  @override
  Widget build(BuildContext context) {
    Widget stepperButton(IconData icon, VoidCallback onPressed) {
      return IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: AppConstants.primaryColor,
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFFE0F4FF),
          minimumSize: const Size(44, 44),
        ),
      );
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        "Select Quantity",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.itemName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          ValueListenableBuilder<int>(
            valueListenable: _quantity,
            builder: (context, quantity, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  stepperButton(Icons.remove, () => _set(quantity - 1)),
                  const SizedBox(width: 14),
                  SizedBox(
                    width: 70,
                    child: TextField(
                      controller: _controller,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppConstants.searchBarColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: _applyText,
                    ),
                  ),
                  const SizedBox(width: 14),
                  stepperButton(Icons.add, () => _set(quantity + 1)),
                ],
              );
            },
          ),
        ],
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
            "Confirm",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}