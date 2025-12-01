import 'package:flutter/material.dart';
import '../models/order_model.dart'; // Agora ele vai encontrar esse arquivo

class OrderService extends ChangeNotifier {
  static final OrderService instance = OrderService._();
  OrderService._();

  final List<OrderModel> _orders = [];
  List<OrderModel> get orders => List.unmodifiable(_orders);

  void addOrder(OrderModel order) {
    _orders.insert(0, order); // Adiciona no topo da lista
    notifyListeners();
  }
}