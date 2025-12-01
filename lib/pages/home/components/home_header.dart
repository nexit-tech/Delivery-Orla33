import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // 1. Imagem de Fundo (Limpa, sem ícones)
        Container(
          height: 220,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=800&q=60'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
            ),
          ),
        ),

        // 2. Card Flutuante com Logo
        Container(
          height: 160,
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          transform: Matrix4.translationValues(0, 40, 0),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[800]!, width: 1.5)
                ),
                child: Column(
                  children: [
                    Text("Orla33", style: TextStyle(fontFamily: 'Playfair Display', color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 20)),
                    const Text("STEAKHOUSE", style: TextStyle(color: Colors.white, fontSize: 8, letterSpacing: 2)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Informações
              Text(
                "Aberto • 15-20 min • Min R\$ 80,00",
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}