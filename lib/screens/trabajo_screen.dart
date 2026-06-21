import 'package:flutter/material.dart';
import 'package:mi_app/models/consumo_real_insumo.dart';
import 'package:mi_app/models/detalle_pedido.dart';
import 'package:mi_app/models/detalle_receta.dart';
import 'package:mi_app/models/insumo.dart';
import 'package:mi_app/models/pedido_lite.dart';
import 'package:mi_app/models/producto_lite.dart';

class AreaTrabajo extends StatefulWidget {
  final PedidoLite pedidoLite;

  const AreaTrabajo({super.key, required this.pedidoLite});

  @override
  State<AreaTrabajo> createState() => _AreaTrabajoState();
}

class _AreaTrabajoState extends State<AreaTrabajo> {
  //y traer los detalles que tengan su clave foranea id_pedidos == pedidoLite.id
  //y luego
  //final response = await http.get(...);
  //final List<dynamic> jsonData = jsonDecode(response.body);
  //List<DetallePedido> detalles = jsonData.map((json) => DetallePedido.fromJson(json)).toList();
  //se cargara al iniciar la pantalla con
  List<DetallePedido> detalles = [
    DetallePedido(
      descuento: 0,
      productoId: 5,
      cantidad: 2,
      precioUnitario: 100,
      pedidoId: 1,
    ),
    DetallePedido(
      descuento: 0,
      productoId: 3,
      cantidad: 2,
      precioUnitario: 100,
      pedidoId: 1,
    ),
  ];
  //debo traer tambien TODOS los nombres de los productos con producto litle para dibujar los widgets con el productoId de los detalles
  final List<ProductoLite> productos = [
    ProductoLite(id: 1, nombre: "Producto 1", precio: 10.0),
    ProductoLite(id: 5, nombre: "Producto 2", precio: 20.0),
    ProductoLite(id: 3, nombre: "Producto 3", precio: 30.0),
  ];

  //tambien nesecitare la lista de TODOS los insumos para dibujar el widget mejor traerla desde un principio
  //ya que se usa mucho
  List<Insumo> insumos = [
    Insumo(
      id: 1,
      nombre: "taza",
      categoria: "carton",
      stock: 5,
      ubicacion: "estante1",
    ),
    Insumo(
      id: 2,
      nombre: "hoja",
      categoria: "carton",
      stock: 5,
      ubicacion: "estante1",
    ),
    Insumo(
      id: 3,
      nombre: "tinta",
      categoria: "carton",
      stock: 5,
      ubicacion: "estante1",
    ),
  ];

  //aca se guardara una lista esta sera un lista de los detalle_receta que tengan como clave foranea un idProducto
  //es decir el productoId sera el mismo en todos los detalles se cargara luego en una funcion
  List<DetalleReceta> detallesReceta = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Área de Trabajo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "cliente : ${widget.pedidoLite.cliente}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'Fecha: ${widget.pedidoLite.fecha.day}/${widget.pedidoLite.fecha.month}/${widget.pedidoLite.fecha.year}',
            ),

            const SizedBox(height: 20),

            const Text(
              'Detalles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                //este detalles es el de BD
                itemCount: detalles.length,
                itemBuilder: (context, index) {
                  final detalle = detalles[index];
                  //aca estoy mostrando los Detalles del Pedido DetallePedido
                  return Card(
                    child: InkWell(
                      onTap: () {
                        _mostrarDialogoAreaTrabajo(detalle);
                      },
                      child: ListTile(
                        title: Text(
                          productos
                              .firstWhere((p) => p.id == detalle.productoId)
                              .nombre,
                        ),
                        subtitle: Text('Cantidad: ${detalle.cantidad}'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoAreaTrabajo(DetallePedido detalle) {
    //aca se cargara la lista de detallesReceta con los detalles que tengan como clave foranea
    //es decir traer todos los detalles receta que cumplan
    //que detalleReceta.productoID=detalle.Productoid
    detallesReceta = [
      DetalleReceta(cantidadTeorica: 1, insumoId: 3, productoId: 5, id: 45),
      DetalleReceta(cantidadTeorica: 1, insumoId: 2, productoId: 5, id: 26),
      DetalleReceta(cantidadTeorica: 1, insumoId: 1, productoId: 5, id: 44),
    ];
    Map<int, TextEditingController> stockControllers = {};
    for (var d in detallesReceta) {
      stockControllers[d.insumoId] = TextEditingController();
    }
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Area De Trabajo'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Receta Teorica (Insumos Teoricos)"),
                    //esto muestra la lista detallesReceta
                    ListView.builder(
                      //las dos siguientes lineas son para el error de un listView dentro de un Column
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: detallesReceta.length,
                      itemBuilder: (context, index) {
                        final detalleR = detallesReceta[index];
                        //aca estoy mostrando los Detalles de la receta nuevamente
                        return Card(
                          child: ListTile(
                            title: Text(
                              //esto trae el primer insumo cuyo id coincide con el del insumo en el detalle.nombre
                              insumos
                                  .firstWhere((i) => i.id == detalleR.insumoId)
                                  .nombre,
                            ),
                            subtitle: Text(
                              'Cantidad: ${detalleR.cantidadTeorica * detalle.cantidad}',
                            ),
                          ),
                        );
                      },
                    ),

                    Text("Registro De Consumo Real"),

                    ListView.builder(
                      //las dos siguientes lineas son para el error de un listView dentro de un Column
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: detallesReceta.length,
                      itemBuilder: (context, index) {
                        final detalleR = detallesReceta[index];
                        //aca estoy mostrando los Detalles de la receta
                        return Card(
                          child: ListTile(
                            title: Text(
                              //esto trae el primer insumo cuyo id coincide con el del insumo en el detalle.nombre
                              insumos
                                  .firstWhere((i) => i.id == detalleR.insumoId)
                                  .nombre,
                            ),
                            trailing: SizedBox(
                              width: 30,
                              child: TextField(
                                controller: stockControllers[detalleR.insumoId],
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    //primer corroboro que ninguno este vacio
                    if (stockControllers.values.any(
                      (c) => c.text.trim().isEmpty || c.text.trim() == '0',
                    )) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Complete todos los campos'),
                        ),
                      );
                      return;
                    }
                    // si no Guardar datos
                    //aca recorro los controladores y les saco su clave y valor
                    for (var entry in stockControllers.entries) {
                      int insumoId = entry.key;
                      int valor = int.parse(entry.value.text);
                      //modificar el Stock del insumo con id  igual a insumoId de la calve del controller
                      //se debera restar el stock
                      //y tambien debo crear un consumoReal y guaradarlo en la base
                      ConsumoRealInsumo consumo = ConsumoRealInsumo(
                        cantidadReal: 5,
                        detallePedidoId: detalle.id!,
                        insumoId: insumoId,
                      );
                      print('Insumo: $insumoId');
                      print('Cantidad: $valor');
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
