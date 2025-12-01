import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/models/order_model.dart';
import '../../core/services/order_service.dart';
import '../../core/theme/app_theme.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder faz a tela atualizar sozinha quando entra um pedido novo
    return ListenableBuilder(
      listenable: OrderService.instance,
      builder: (context, child) {
        final orders = OrderService.instance.orders;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Meus Pedidos", style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false, // Importante: Remove a seta de voltar pois é uma aba
          ),
          body: orders.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) => _buildOrderCard(context, orders[index]),
                ),
        );
      },
    );
  }

  // Tela Vazia
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey[800]),
          const SizedBox(height: 16),
          Text("Nenhum pedido ainda", style: TextStyle(color: Colors.grey[500], fontSize: 16)),
        ],
      ),
    );
  }

  // Card do Pedido
  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    final currency = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    // Lógica visual do Status
    Color statusColor = AppTheme.primary;
    String statusText = "Preparando";
    
    if (order.status == OrderStatus.delivery) {
      statusText = "Saiu para entrega";
      statusColor = Colors.orange;
    }
    if (order.status == OrderStatus.completed) {
      statusText = "Entregue";
      statusColor = Colors.green;
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Fundo do Card
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[900]!),
      ),
      child: Column(
        children: [
          // Cabeçalho (ID e Data)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Pedido ${order.id}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(dateFormat.format(order.date), style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
                // Badge de Status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withOpacity(0.5)),
                  ),
                  child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          
          // Lista de Itens (Resumida)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(4)),
                        child: Text("${item.quantity}x", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(item.title, style: const TextStyle(color: Colors.white70))),
                    ],
                  ),
                )),
                
                const SizedBox(height: 16),
                
                // Endereço Pequeno
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(order.address.toString(), 
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          
          // Rodapé (Total)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF252525), // Fundo mais claro
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total", style: TextStyle(color: Colors.grey[400])),
                Text(currency.format(order.total), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          )
        ],
      ),
    );
  }
}