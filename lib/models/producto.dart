import 'package:mi_app/models/detalle_receta.dart';

class Producto {
  final int? id;
  final String nombre;
  final double precio;
  final String categoria;
  final List<DetalleReceta>? detalles;
  final bool activo;

  Producto({
    this.detalles,
    this.id,
    required this.nombre,
    required this.precio,
    required this.categoria,
    required this.activo,
  });

  //precio con 2 decimales
  String get precioFormateado => precio.toStringAsFixed(2);

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      precio: double.parse(json['precio'].toString()),
      categoria: json['categoria'],
      detalles: (json['detalles'] as List?)
          ?.map((e) => DetalleReceta.fromJson(e))
          .toList()
          ?? [],
      activo: json['activo'] ?? true,    
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'precio': precio,
      'categoria': categoria,
      'detalles': detalles?.map((e) => e.toJson()).toList(),
      'activo': activo,
    };
  }
}