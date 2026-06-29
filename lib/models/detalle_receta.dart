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
      
      // Busca cantidadTeorica o cantidad_teorica. Si no encuentra ninguna, pone 0
      cantidadTeorica: int.tryParse((json['cantidadTeorica'] ?? json['cantidad_teorica']).toString()) ?? 0,
      
      // Busca insumoId o insumo_id. Si no encuentra, pone 0
      insumoId: json['insumoId'] ?? json['insumo_id'] ?? 0,
      
      // Busca nombreInsumo o nombre_insumo. Si no encuentra, pone "Insumo sin nombre"
      nombreInsumo: json["nombreInsumo"] ?? json["nombre_insumo"] ?? "Insumo sin nombre",
      
      // Busca productoId o producto_id
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
