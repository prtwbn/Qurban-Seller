class ProductVariation {
  String name;
  double price;

  ProductVariation({required this.name, required this.price});

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
  };

  ProductVariation.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        price = json['price'];
}
