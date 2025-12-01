import 'package:flutter/material.dart';
import 'components/home_header.dart';
import 'components/category_tabs.dart'; // Mudei o nome do import
import 'components/food_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D), // Fundo quase preto total
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ListView(
            padding: EdgeInsets.zero, // Importante para a imagem ir até o topo
            children: [
              // 1. Hero Header
              const HomeHeader(),

              // Espaço para compensar o Card Flutuante (ele tem transform Y de 40px)
              const SizedBox(height: 60),

              // 2. Categorias (Tabs)
              const CategoryTabs(),

              const SizedBox(height: 20),

              // 3. Lista de Pratos
              const FoodCard(
                title: "Ribeye Prime",
                description: "300g aged prime beef, grilled to perfection.",
                price: 89.90,
                imageUrl: "https://images.unsplash.com/photo-1546964124-0cce460f38ef?auto=format&fit=crop&w=800&q=60",
              ),
              const FoodCard(
                title: "Curled Skewers",
                description: "Espetinhos marinados com especiarias da casa.",
                price: 45.00,
                imageUrl: "https://images.unsplash.com/photo-1529042410759-befb1204b468?auto=format&fit=crop&w=800&q=60",
              ),
              const FoodCard(
                title: "T-Bone Master",
                description: "O melhor dos dois mundos: filé e contra-filé.",
                price: 120.00,
                imageUrl: "https://images.unsplash.com/photo-1594041680534-e8c8cdebd659?auto=format&fit=crop&w=800&q=60",
              ),
              
              const SizedBox(height: 40), // Espaço final
            ],
          ),
        ),
      ),
    );
  }
}