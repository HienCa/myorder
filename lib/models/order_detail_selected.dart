// ignore_for_file: non_constant_identifier_names

class OrderDetailSelected {
  int quantity;
  String food_id;
  bool isSelected = false;
  OrderDetailSelected(this.quantity, this.food_id, this.isSelected);

  OrderDetailSelected.empty()
      : quantity = 1,
        isSelected = false,
        food_id = '';
}
