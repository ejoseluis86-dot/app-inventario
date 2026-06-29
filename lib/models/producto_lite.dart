class ProductoLite {
  final int? id; // agregamos el '?' para que coincida con Producto
  final String nombre;
  final double precio;
  final String categoria;
  final bool activo; // 

  ProductoLite({
    this.id,
    required this.nombre,
    required this.precio,
    required this.categoria,
    required this.activo,
  });

  factory ProductoLite.fromJson(Map<String, dynamic> json) {
    return ProductoLite(
      id: json['id'],
      nombre: json['nombre'],
      precio: double.parse(json['precio'].toString()),
      categoria: json['categoria'],
      activo: json['activo'] ?? true, // 🔥 IMPORTANTE
    );
  }
}