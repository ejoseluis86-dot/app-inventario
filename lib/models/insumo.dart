  class Insumo {
  final int id;
  final String nombre;
  final String categoria;
  final String ubicacion;
  final int stock;
  //no usamos sucursalId por el momento, pero si lo necesitamos despues lo agregamos


  Insumo({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.ubicacion,
    required this.stock,
  });

  factory Insumo.fromJson(Map<String, dynamic> json) {
    return Insumo(
      id: json['id'],
      nombre: json['nombre'],
      categoria: json['categoria'],
      ubicacion: json['ubicacion'],
      stock: int.parse(json['stock'].toString()),
    );
  }
}