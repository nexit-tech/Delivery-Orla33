import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;

  void _doLogin() async {
    // Simula um delay de API
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.go('/home'); // Redireciona para o app
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. IMAGEM DE FUNDO (Background Immersive)
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=800&q=80', // Mesma imagem top
              fit: BoxFit.cover,
            ),
          ),
          
          // 2. MÁSCARA ESCURA (Para o texto ler bem)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
                    Colors.black, // Fundo preto sólido embaixo
                  ],
                ),
              ),
            ),
          ),

          // 3. CONTEÚDO (Centralizado para Web)
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400), // Largura controlada
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    
                    // Logo / Título
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 2)
                      ),
                      child: const Icon(Icons.restaurant_menu, size: 40, color: AppTheme.primary),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Orla 33",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 40, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white
                      ),
                    ),
                    Text(
                      "STEAKHOUSE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12, 
                        letterSpacing: 4, 
                        color: Colors.grey[400]
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Inputs
                    _buildInput("E-mail", _emailCtrl, Icons.email_outlined),
                    const SizedBox(height: 16),
                    _buildInput("Senha", _passCtrl, Icons.lock_outline, isPassword: true),

                    const SizedBox(height: 24),

                    // Botão Entrar
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _isLoading ? null : _doLogin,
                        child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Entrar", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Botão Google
                    SizedBox(
                      height: 56,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Colors.white.withOpacity(0.05)
                        ),
                        onPressed: _doLogin,
                        icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.white),
                        label: const Text("Continuar com Google", style: TextStyle(color: Colors.white)),
                      ),
                    ),

                    const Spacer(),

                    // Botão Visitante
                    TextButton(
                      onPressed: () => context.go('/home'),
                      child: Text(
                        "Entrar como Visitante", 
                        style: TextStyle(color: Colors.grey[500], decoration: TextDecoration.underline)
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String hint, TextEditingController ctrl, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: ctrl,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500]),
        prefixIcon: Icon(icon, color: Colors.grey[500]),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primary),
        ),
      ),
    );
  }
}