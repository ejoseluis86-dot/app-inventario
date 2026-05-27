import 'package:flutter/material.dart';
import 'package:mi_app/widgets/mi_resumen.dart';
import 'package:mi_app/widgets/my_bar_bottom.dart';
import 'package:mi_app/widgets/my_botonera.dart';
import 'package:mi_app/widgets/my_head_home.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(title: MyHeadHome(), toolbarHeight: 90, titleSpacing: 15),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            MiResumen(),
            const SizedBox(height: 10),
            MyBotonera(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(height: 60, child: MyBottomBar()),
      ),
    );
  }
}
