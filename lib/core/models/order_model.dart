import 'cart_item.dart';     // Precisa existir na mesma pasta (models)
import 'address_model.dart'; // Precisa existir na mesma pasta (models)

enum OrderStatus { preparing, delivery, completed }

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double total;
  final AddressModel address;
  final String paymentMethod;
  final DateTime date;
  OrderStatus status;

  OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.address,
    required this.paymentMethod,
    required this.date,
    this.status = OrderStatus.preparing,
  });
}