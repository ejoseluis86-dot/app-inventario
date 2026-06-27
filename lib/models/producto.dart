import 'package:mi_app/models/detalle_receta.dart';

class Producto {
  final int? id; //FK
  final String nombre;
  final double precio;
  final String categoria;
  final List<DetalleReceta>?
  detalles; //esta es la lista de detalles que se asocian a este producto

  Producto({
    this.detalles,
    this.id,
    required this.nombre,
    required this.precio,
    required this.categoria,
  }); //el detalle es opcional y por defecto es una lista vacía

  factory Producto.fromJson(Map<String, dynamic> json) {
  return Producto(
    id: json['id'],
    nombre: json['nombre'],
    precio: double.parse(json['precio'].toString()),
    categoria: json['categoria'],
    detalles: json['detalles'] != null
        ? (json['detalles'] as List)
            .map((e) => DetalleReceta.fromJson(e))
            .toList()
        : null,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'precio': precio,
      'categoria': categoria,
      'detalles': detalles?.map((e) => e.toJson()).toList(),
    };
  }
}
