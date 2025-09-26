// domain/entities/grocery_item.dart
class GroceryItem {
  final int id;
  String name;
  String quantity;
  String category;
  String notes;
  bool isPurchased;

  GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    this.notes = '',
    this.isPurchased = false,
  });
}
