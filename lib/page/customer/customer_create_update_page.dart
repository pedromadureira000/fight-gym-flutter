import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomerCreateOrUpdatePage extends HookConsumerWidget {
  CustomerCreateOrUpdatePage({super.key, this.params = const {}});
  final Map params;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(text: params['name'] ?? '');
    final emailController = useTextEditingController(text: params['email'] ?? '');
    final phoneController = useTextEditingController(text: params['phone'] ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text(params.isEmpty ?  tr("Create customer"): tr("Update customer")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: tr('Name')),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: tr('Email')),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: tr('Phone')),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newCustomer = {
                  'name': nameController.text,
                  'email': emailController.text,
                  'phone': phoneController.text,
                };
                if (params.isEmpty) {
                  // Handle customer creation
                  print('Creating customer: $newCustomer');
                } else {
                  // Handle customer update
                  print('Updating customer: $newCustomer');
                }
              },
              child: Text(params.isEmpty ? tr("Create") : tr("Update")),
            ),
          ],
        ),
      ),
    );
  }
}
