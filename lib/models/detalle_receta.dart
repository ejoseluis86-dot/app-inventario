class DetalleReceta {
  final int id; //PK
  final int cantidadTeorica;
  final int insumoId; //FK
  final int productoId; //FK

  DetalleReceta({
    required this.id,
    required this.cantidadTeorica,
    required this.insumoId,
    required this.productoId,
  });
}
