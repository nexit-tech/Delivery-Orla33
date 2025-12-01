import 'package:flutter/material.dart';
import '../../core/models/address_model.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_theme.dart';

class SavedAddressesPage extends StatelessWidget {
  const SavedAddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserService.instance,
      builder: (context, child) {
        final addresses = UserService.instance.savedAddresses;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Endereços Salvos"),
            backgroundColor: Colors.transparent,
            centerTitle: true,
          ),
          body: addresses.isEmpty
              ? const Center(child: Text("Nenhum endereço salvo.", style: TextStyle(color: Colors.grey)))
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: addresses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => _buildAddressCard(addresses[index]),
                ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppTheme.primary,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showAddAddressModal(context),
          ),
        );
      },
    );
  }

  Widget _buildAddressCard(AddressModel address) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[900]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppTheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(address.street, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text("${address.number} - ${address.district}", style: TextStyle(color: Colors.grey[400], fontSize: 13)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => UserService.instance.removeAddress(address),
          )
        ],
      ),
    );
  }

  void _showAddAddressModal(BuildContext context) {
    final streetCtrl = TextEditingController();
    final numCtrl = TextEditingController();
    final distCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Novo Endereço", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(controller: streetCtrl, decoration: const InputDecoration(hintText: "Rua", filled: true, fillColor: Color(0xFF252525)), style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: TextField(controller: numCtrl, decoration: const InputDecoration(hintText: "Número", filled: true, fillColor: Color(0xFF252525)), style: const TextStyle(color: Colors.white))),
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: distCtrl, decoration: const InputDecoration(hintText: "Bairro", filled: true, fillColor: Color(0xFF252525)), style: const TextStyle(color: Colors.white))),
            ]),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                onPressed: () {
                   UserService.instance.addAddress(AddressModel(street: streetCtrl.text, number: numCtrl.text, district: distCtrl.text));
                   Navigator.pop(context);
                },
                child: const Text("Salvar", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}