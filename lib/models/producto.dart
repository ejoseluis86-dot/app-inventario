class Producto {
  final int id; //FK
  final String nombre;
  final double precio;

  Producto({required this.id, required this.nombre, required this.precio});

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      precio: json['precio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'precio': precio};
  }
}
