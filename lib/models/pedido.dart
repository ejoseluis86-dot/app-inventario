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
}
