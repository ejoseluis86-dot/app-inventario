class DetalleReceta {
  final int? id; //PK
  final int cantidadTeorica;
  final int insumoId; //FK
  final int? productoId; //FK

  DetalleReceta({
    this.id,
    this.productoId,
    required this.cantidadTeorica,
    required this.insumoId,
  });

  factory DetalleReceta.fromJson(Map<String, dynamic> json) {
    return DetalleReceta(
      id: json['id'],
      cantidadTeorica: json['cantidad_teorica'],
      insumoId: json['insumo_id'],
      productoId: json['producto_id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cantidad_teorica': cantidadTeorica,
      'insumo_id': insumoId,
      'producto_id': productoId,
    };
  }
}
