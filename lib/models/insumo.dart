class Insumo {
  final int id;
  final String nombre;
  final String categoria;
  final int stock;
  final String ubicacion;
  //no usamos sucursalId por el momento, pero si lo necesitamos despues lo agregamos

  Insumo({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.stock,
    required this.ubicacion,
  });

  factory Insumo.fromJson(Map<String, dynamic> json) {
    return Insumo(
      id: json['id'],
      nombre: json['nombre'],
      categoria: json['categoria'],
      stock: json['stock'],
      ubicacion: json['ubicacion'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'categoria': categoria,
      'stock': stock,
      'ubicacion': ubicacion,
    };
  }
}
