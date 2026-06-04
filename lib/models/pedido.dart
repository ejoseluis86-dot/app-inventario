class Pedido {
  final int id;
  final DateTime fecha;
  final String cliente;
  final int usuarioId;
  //por el momento sacamos sucursalId porque no lo vamos a usar, pero si lo necesitamos despues lo agregamos

  Pedido({
    required this.id, //PK
    required this.fecha,
    required this.cliente,
    required this.usuarioId, //FK
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      fecha: DateTime.parse(json['fecha']),
      cliente: json['cliente'],
      usuarioId: json['usuarioId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha': fecha.toIso8601String(),
      'cliente': cliente,
      'usuarioId': usuarioId,
    };
  }
}
