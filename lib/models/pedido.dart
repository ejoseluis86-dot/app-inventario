import 'package:mi_app/models/detalle_pedido.dart';

class Pedido {
  final int? id;
  final DateTime fecha;
  final String cliente;
  final int usuarioId;
  List<DetallePedido> detalles =
      []; //se crea al momento de crear el pedido con todo y sus detalles no pude ser nulo
  //por el momento sacamos sucursalId porque no lo vamos a usar, pero si lo necesitamos despues lo agregamos

  Pedido({
    this.id, //PK
    required this.fecha,
    required this.cliente,
    required this.usuarioId, //FK
    required this.detalles,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      fecha: DateTime.parse(json['fecha']),
      cliente: json['cliente'],
      usuarioId: json['usuarioId'],
      detalles: (json['detalles'] as List)
          .map((detalle) => DetallePedido.fromJson(detalle))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha': fecha.toIso8601String(),
      'cliente': cliente,
      'usuarioId': usuarioId,
      'detalles': detalles.map((detalle) => detalle.toJson()).toList(),
    };
  }
}
