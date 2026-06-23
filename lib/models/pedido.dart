import 'package:mi_app/models/detalle_pedido.dart';

class Pedido {
  final int? id;
  final DateTime fecha;
  final String cliente;
  final int usuario;
  final bool terminado;
  List<DetallePedido> detalles =
      []; //se crea al momento de crear el pedido con todo y sus detalles no pude ser nulo
  //por el momento sacamos sucursalId porque no lo vamos a usar, pero si lo necesitamos despues lo agregamos

  Pedido({
    this.id, //PK
    required this.terminado,
    required this.fecha,
    required this.cliente,
    required this.usuario, //FK
    required this.detalles,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      fecha: DateTime.parse(json['fecha']),
      cliente: json['cliente'],
      usuario: json['usuario'],
      detalles: (json['detalles'] as List)
          .map((detalle) => DetallePedido.fromJson(detalle))
          .toList(),
      terminado: json['terminado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fecha': fecha.toIso8601String(),
      'cliente': cliente,
      'usuario': usuario,
      'detalles': detalles.map((detalle) => detalle.toJson()).toList(),
    };
  }
}
