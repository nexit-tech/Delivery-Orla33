import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/cart_service.dart'; // Importante: Importar o serviço do carrinho
import '../../../core/models/cart_item.dart'; // <--- ADICIONE ESSA LINHA

class ProductDetailsModal extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsModal({super.key, required this.product});

  @override
  State<ProductDetailsModal> createState() => _ProductDetailsModalState();
}

class _ProductDetailsModalState extends State<ProductDetailsModal> {
  int quantity = 1;
  String selectedDoneness = "Ao Ponto"; 

  final donenessOptions = [
    "Selada (Blue)", 
    "Ao Ponto Menos", 
    "Ao Ponto", 
    "Bem Passada"
  ];

  double get totalPrice => (widget.product['price'] * quantity);

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Container(
      height: MediaQuery.of(context).size.height * 0.92, // Ocupa 92% da altura
      decoration: const BoxDecoration(
        color: Color(0xFF141414), // Fundo Dark
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 1. CONTEÚDO COM SCROLL (Imagem + Texto)
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // --- HEADER COM GESTO DE FECHAR ---
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      // Detecta se o usuário está puxando para baixo com intenção
                      if (details.primaryDelta! > 7) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Stack(
                      children: [
                        // A Imagem do Produto
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          child: Image.network(
                            widget.product['imageUrl'],
                            height: 260,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        
                        // Gradiente no topo (para destacar a barrinha branca)
                        Positioned(
                          top: 0, left: 0, right: 0, height: 80,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.black.withOpacity(0.7), Colors.transparent]
                              )
                            ),
                          ),
                        ),

                        // A "HANDLE BAR" (Indicador visual de deslizar)
                        Positioned(
                          top: 12, left: 0, right: 0,
                          child: Center(
                            child: Container(
                              width: 50, height: 5,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))]
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ----------------------------------

                  // CORPO DO TEXTO
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product['title'],
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product['description'],
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[400], 
                            height: 1.4
                          ),
                        ),
                        
                        const SizedBox(height: 32),

                        // Título da Seção + Badge Obrigatório
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Escolha o Ponto", style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 18)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(4)),
                              child: const Text("OBRIGATÓRIO", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                            )
                          ],
                        ),
                        
                        const SizedBox(height: 16),

                        // Lista de Opções (Ponto da Carne)
                        ...donenessOptions.map((option) => _buildRadioItem(option)),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. FOOTER FIXO (Controles de Quantidade e Botão Adicionar)
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, -5))]
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Seletor de Quantidade [- 1 +]
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF252525),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[800]!)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => setState(() { if(quantity > 1) quantity--; }), 
                          icon: const Icon(Icons.remove, color: Colors.white, size: 20)
                        ),
                        Text("$quantity", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        IconButton(
                          onPressed: () => setState(() => quantity++), 
                          icon: const Icon(Icons.add, color: AppTheme.primary, size: 20)
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Botão Adicionar ao Carrinho
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        // --- A LÓGICA DO CARRINHO ESTÁ AQUI ---
                        onPressed: () {
                          // 1. Criar o objeto do item
                          final newItem = CartItem(
                            id: DateTime.now().toString(), // ID único
                            title: widget.product['title'],
                            imageUrl: widget.product['imageUrl'],
                            price: widget.product['price'],
                            quantity: quantity,
                            selectedDoneness: selectedDoneness,
                          );

                          // 2. Adicionar ao Singleton do Serviço
                          CartService.instance.addToCart(newItem);

                          // 3. Fechar o modal
                          Navigator.pop(context);

                          // 4. Feedback visual (SnackBar)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              content: Row(
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.white),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text("${widget.product['title']} adicionado!", style: const TextStyle(fontWeight: FontWeight.bold))),
                                ],
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        // --------------------------------------
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Adicionar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(currency.format(totalPrice), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Componente Auxiliar para o Radio Button Customizado
  Widget _buildRadioItem(String value) {
    final isSelected = selectedDoneness == value;
    
    return GestureDetector(
      onTap: () => setState(() => selectedDoneness = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        color: Colors.transparent, // Área de toque expandida
        child: Row(
          children: [
            // Bolinha Customizada
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppTheme.primary : Colors.grey[600]!,
                  width: 2
                ),
              ),
              child: isSelected 
                ? Center(child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle))) 
                : null,
            ),
            const SizedBox(width: 16),
            // Texto
            Text(value, 
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontFamily: 'Montserrat'
              )
            ),
          ],
        ),
      ),
    );
  }
}