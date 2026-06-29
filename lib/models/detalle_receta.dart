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
      id: json['id'], // Puede ser null
      // 1. Buscamos 'cantidadTeorica' (camelCase) y usamos tryParse por seguridad
      cantidadTeorica: int.tryParse(json['cantidadTeorica'].toString()) ?? 0,
      
      // 2. Buscamos 'insumoId' (camelCase) y si no existe le ponemos 0 para que no sea Null
      insumoId: json['insumoId'] ?? 0,
      
      // 3. Buscamos 'nombreInsumo' (camelCase)
      nombreInsumo: json["nombreInsumo"],
      
      // 4. El productoId no viene en el listado general, mapea lo que venga o null
      productoId: json['productoId'] ?? json['producto_id'],
    );
  }
  Map<String, dynamic> toJson() {
  return {
    'cantidad_teorica': cantidadTeorica,
    'insumo_id': insumoId,
  };
}
}
