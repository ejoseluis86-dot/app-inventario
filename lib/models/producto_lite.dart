class ProductoLite {
  final int id;
  final String nombre;
  final double precio;
  final String categoria;

  ProductoLite({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.categoria,
  });

  factory ProductoLite.fromJson(Map<String, dynamic> json) {
    return ProductoLite(
      id: json['id'],
      nombre: json['nombre'],
      precio: double.parse(json['precio'].toString()),
      categoria: json['categoria'],
    );
  }
}