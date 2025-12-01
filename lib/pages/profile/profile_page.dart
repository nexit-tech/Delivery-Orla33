import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserService.instance,
      builder: (context, child) {
        final user = UserService.instance;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Meu Perfil", style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF252525),
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                
                Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text(user.email, style: const TextStyle(color: Colors.grey)),
                
                const SizedBox(height: 32),

                _buildProfileItem(context, Icons.settings, "Configurações", onTap: () => context.go('/perfil/configuracoes')),
                _buildProfileItem(context, Icons.location_on, "Endereços Salvos", onTap: () => context.go('/perfil/enderecos')),
                _buildProfileItem(context, Icons.help_outline, "Ajuda e Suporte", onTap: () {}),
                
                const SizedBox(height: 20),
                
                // --- AQUI ESTÁ A CORREÇÃO DO BOTÃO SAIR ---
                _buildProfileItem(
                  context, 
                  Icons.logout, 
                  "Sair", 
                  isDestructive: true, 
                  onTap: () {
                    // Reseta a navegação e vai para o Login
                    context.go('/login');
                  }
                ),
                // ------------------------------------------
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileItem(BuildContext context, IconData icon, String label, {bool isDestructive = false, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? Colors.red : Colors.white),
        title: Text(label, style: TextStyle(color: isDestructive ? Colors.red : Colors.white, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}