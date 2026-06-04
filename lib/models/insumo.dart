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
}
