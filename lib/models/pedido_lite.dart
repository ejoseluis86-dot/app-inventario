class PedidoLite {
  final int id;
  final String cliente;
  final DateTime fecha;

  PedidoLite({required this.id, required this.cliente, required this.fecha});

  factory PedidoLite.fromJson(Map<String, dynamic> json) {
    return PedidoLite(
      id: json['id'],
      cliente: json['nombre'],
      fecha: DateTime.parse(json['fecha']),
    );
  }
}
