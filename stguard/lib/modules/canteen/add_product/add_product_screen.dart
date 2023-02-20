import 'package:flutter/material.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [Text('Add Product')],
          ),
        ),
      ),
    );
  }
}
