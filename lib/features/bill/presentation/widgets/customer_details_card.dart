import 'package:flutter/material.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/core/util/validator.dart';
import 'package:omni_ledger/shared/ui/app_text_form_field.dart';

class CustomerDetailsCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const CustomerDetailsCard({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F4FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: AppConstants.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Customer Details",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text("Phone Number", style: Theme.of(context).textTheme.labelLarge),
            AppTextFormField(
              controller: phoneController,
              hintText: "00000 00000",
              keyboardType: TextInputType.number,
              validator: Validators.phone,
            ),
            const SizedBox(height: 16),
            Text(
              "Customer Name",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            AppTextFormField(
              controller: nameController,
              hintText: "Enter customer name",
              keyboardType: TextInputType.text,
              validator: Validators.name,
            ),
          ],
        ),
      ),
    );
  }
}