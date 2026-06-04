class ConsumoRealInsumo {
  final int id; //PK
  final int cantidadReal;
  final int detallePedidoId; //FK
  final int insumoId; //FK

  ConsumoRealInsumo({
    required this.id,
    required this.cantidadReal,
    required this.detallePedidoId,
    required this.insumoId,
  });
}
