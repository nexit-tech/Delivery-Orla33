import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import 'product_details_modal.dart'; // Importe o modal que acabamos de criar

class FoodCard extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  const FoodCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  // Função que abre o Modal
void _openProductModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ocupa tela cheia se precisar
      useRootNavigator: true,   // <--- O PULO DO GATO: Abre por cima da BottomNavigationBar
      backgroundColor: Colors.transparent, 
      builder: (context) => const ProductDetailsModal(
        // Passei dados estáticos pra testar, mas mantenha sua lógica de passar o widget.product
        product: {
          'title': "Ribeye Prime",
          'description': "300g aged prime beef, grilled to perfection.",
          'price': 89.90,
          'imageUrl': "https://images.unsplash.com/photo-1546964124-0cce460f38ef?auto=format&fit=crop&w=800&q=60",
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return GestureDetector(
      onTap: () => _openProductModal(context), // <--- O clique mágica acontece aqui
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Imagem
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(description, 
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(currency.format(price), style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),

            // Botão Visual (Apenas visual, pois o clique é no card todo)
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
              child: const Icon(Icons.add, color: Colors.white, size: 24), // Troquei o ícone por + para fazer sentido com "Adicionar"
            ),
          ],
        ),
      ),
    );
  }
}