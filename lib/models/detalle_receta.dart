class DetalleReceta {
  final int? id; //PK
  int cantidadTeorica;
  final String? nombreInsumo;
  final int insumoId; //FK
  final int? productoId; //FK

  DetalleReceta({
    this.id,
    this.productoId,
    required this.cantidadTeorica,
    required this.insumoId,
    this.nombreInsumo,
  });

  factory DetalleReceta.fromJson(Map<String, dynamic> json) {
    return DetalleReceta(
      id: json['id'],
      cantidadTeorica: json['cantidad_teorica'],
      insumoId: json['insumo_id'],
      nombreInsumo: json["nombre_insumo"],
      productoId: json['producto_id'],
    );
  }
  Map<String, dynamic> toJson() {
  return {
    'cantidad_teorica': cantidadTeorica,
    'insumo_id': insumoId,
  };
}
}
