class ConsumoRealInsumo {
  final int? id; //PK
  final int cantidadReal;
  final int detallePedidoId; //FK
  final int insumoId; //FK

  ConsumoRealInsumo({
    this.id,
    required this.cantidadReal,
    required this.detallePedidoId,
    required this.insumoId,
  });

  factory ConsumoRealInsumo.fromJson(Map<String, dynamic> json) {
    return ConsumoRealInsumo(
      id: json['id'],
      cantidadReal: json['cantidad_real'],
      detallePedidoId: json['detalle_pedido_id'],
      insumoId: json['insumo_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cantidad_real': cantidadReal,
      'detalle_pedido_id': detallePedidoId,
      'insumo_id': insumoId,
    };
  }
}
