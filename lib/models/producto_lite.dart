class ProductoLite {
  final int id;
  final String nombre;
  final double precio;
  final String categoria;
  final bool activo;
  

  ProductoLite({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.categoria,
    required this.activo,
  });

  //precio con 2 decimales
  String get precioFormateado => precio.toStringAsFixed(2);

  factory ProductoLite.fromJson(Map<String, dynamic> json) {
    return ProductoLite(
      id: json['id'],
      nombre: json['nombre'],
      precio: double.parse(json['precio'].toString()),
      categoria: json['categoria'],
      activo: json['activo'],
    );
  }
}