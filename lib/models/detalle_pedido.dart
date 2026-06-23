class DetallePedido {
  final int? id; //PK
  final int cantidad;
  final double precioUnitario;
  final double descuento;
  final int? pedidoId; //FK
  final int productoId; //FK

  DetallePedido({
    required this.descuento,
    this.id,
    this.pedidoId,
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario,
  });

  //esto es para convertir el json del backend a un objeto DetallePedido
  factory DetallePedido.fromJson(Map<String, dynamic> json) {
    return DetallePedido(
      descuento: json['descuento']?.toDouble() ?? 0.0,
      id: json['id'],
      pedidoId: json['pedido_id'],
      productoId: json['producto_id'],
      cantidad: json['cantidad'],
      precioUnitario: json['precio'].toDouble(),
    );
  }

  //esto es para convertir el objeto a json para enviarlo al backend
  //no se manda el id porque es null al crear en el back
  Map<String, dynamic> toJson() {
    return {
      'cantidad': cantidad,
      'precio': precioUnitario,
      'descuento': descuento,
      'producto_id': productoId,
    };
  }
}
