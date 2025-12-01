import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'pages/main_wrapper.dart';
import 'pages/home/home_page.dart';
import 'pages/cart/cart_page.dart';
import 'pages/orders/orders_page.dart';
import 'pages/profile/profile_page.dart';
import 'pages/profile/profile_settings_page.dart';
import 'pages/profile/saved_addresses_page.dart';
import 'pages/auth/login_page.dart';

void main() {
  runApp(const Orla33App());
}

final _router = GoRouter(
  // 1. FORÇA O INÍCIO NA TELA DE LOGIN
  initialLocation: '/login', 
  
  routes: [
    // Rota solta de Login (Sem abas em cima/baixo)
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

    // ShellRoute (O App Principal com Navbar)
    ShellRoute(
      builder: (context, state, child) {
        return MainWrapper(child: child);
      },
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomePage()),
        GoRoute(path: '/carrinho', builder: (context, state) => const CartPage()),
        GoRoute(path: '/pedidos', builder: (context, state) => const OrdersPage()),
        GoRoute(
          path: '/perfil',
          builder: (context, state) => const ProfilePage(),
          routes: [
            GoRoute(path: 'configuracoes', builder: (context, state) => const ProfileSettingsPage()),
            GoRoute(path: 'enderecos', builder: (context, state) => const SavedAddressesPage()),
          ],
        ),
      ],
    ),
  ],
);

class Orla33App extends StatelessWidget {
  const Orla33App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Orla 33 Steakhouse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}