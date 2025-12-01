class CartItem {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;
  final String selectedDoneness; // Ponto da carne

  CartItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    this.selectedDoneness = '',
  });

  // Cálculo do total desse item
  double get total => price * quantity;
}