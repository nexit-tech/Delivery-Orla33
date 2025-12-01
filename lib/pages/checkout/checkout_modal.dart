import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/address_model.dart';
import '../../core/models/order_model.dart';
import '../../core/services/cart_service.dart';
import '../../core/services/order_service.dart';
import '../../core/services/user_service.dart'; // <--- IMPORTANTE
import '../../core/theme/app_theme.dart';

class CheckoutModal extends StatefulWidget {
  const CheckoutModal({super.key});

  @override
  State<CheckoutModal> createState() => _CheckoutModalState();
}

class _CheckoutModalState extends State<CheckoutModal> {
  int _currentStep = 0; 
  final _address = AddressModel();
  final _formKey = GlobalKey<FormState>();
  
  final _streetCtrl = TextEditingController();
  final _numCtrl = TextEditingController();
  final _distCtrl = TextEditingController();
  final _compCtrl = TextEditingController(); // Adicionei controller pro complemento

  void _nextStep() {
    if (_currentStep == 0) {
      if (_formKey.currentState!.validate()) {
        _address.street = _streetCtrl.text;
        _address.number = _numCtrl.text;
        _address.district = _distCtrl.text;
        _address.complement = _compCtrl.text;
        setState(() => _currentStep = 1);
      }
    }
  }

  void _finishOrder(String paymentMethod) {
    final cart = CartService.instance;
    final newOrder = OrderModel(
      id: "#${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
      items: List.from(cart.items),
      total: cart.total,
      address: _address,
      paymentMethod: paymentMethod,
      date: DateTime.now(),
    );

    OrderService.instance.addOrder(newOrder);
    cart.clearCart();
    Navigator.pop(context); 
    context.go('/pedidos'); 
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(backgroundColor: Colors.green, content: Text("Pedido realizado com sucesso!")),
    );
  }

  // Função para preencher formulário ao clicar no endereço salvo
  void _fillAddress(AddressModel savedAddress) {
    setState(() {
      _streetCtrl.text = savedAddress.street;
      _numCtrl.text = savedAddress.number;
      _distCtrl.text = savedAddress.district;
      _compCtrl.text = savedAddress.complement;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90, // Um pouco maior
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              _currentStep == 0 ? "Onde vamos entregar?" : "Como deseja pagar?",
              style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 20),
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          Expanded(
            child: _currentStep == 0 ? _buildAddressForm() : _buildPaymentOptions(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressForm() {
    final savedAddresses = UserService.instance.savedAddresses;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SEÇÃO DE ENDEREÇOS SALVOS ---
            if (savedAddresses.isNotEmpty) ...[
              const Text("Usar endereço salvo:", style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: savedAddresses.length,
                  itemBuilder: (context, index) {
                    final addr = savedAddresses[index];
                    return GestureDetector(
                      onTap: () => _fillAddress(addr),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF252525),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.primary.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.home, color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Text("${addr.street}, ${addr.number}", style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text("Ou preencha um novo:", style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 10),
            ],
            // ---------------------------------

            _inputField("Rua / Avenida", _streetCtrl, Icons.location_on),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _inputField("Número", _numCtrl, Icons.home)),
                const SizedBox(width: 16),
                Expanded(child: _inputField("Bairro", _distCtrl, Icons.map)),
              ],
            ),
            const SizedBox(height: 16),
            _inputField("Complemento (Opcional)", _compCtrl, Icons.notes, required: false),
            
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _nextStep,
                child: const Text("Confirmar Endereço", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController ctrl, IconData icon, {bool required = true}) {
    return TextFormField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      validator: required ? (value) => value!.isEmpty ? 'Campo obrigatório' : null : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: AppTheme.primary),
        filled: true,
        fillColor: const Color(0xFF252525),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildPaymentOptions() {
    final total = NumberFormat.simpleCurrency(locale: 'pt_BR').format(CartService.instance.total);
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF252525),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primary.withOpacity(0.5))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total a pagar:", style: TextStyle(color: Colors.white)),
                Text(total, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _paymentTile("Pix", Icons.pix, () => _finishOrder("Pix")),
          _paymentTile("Cartão de Crédito", Icons.credit_card, () => _finishOrder("Cartão")),
          _paymentTile("Dinheiro", Icons.attach_money, () => _finishOrder("Dinheiro")),
          
          const Spacer(),
          TextButton(
            onPressed: () => setState(() => _currentStep = 0),
            child: const Text("Alterar Endereço", style: TextStyle(color: Colors.grey)),
          )
        ],
      ),
    );
  }

  Widget _paymentTile(String label, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        tileColor: const Color(0xFF252525),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: Colors.white),
        title: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}