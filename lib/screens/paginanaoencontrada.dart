import 'package:flutter/material.dart';

class Paginanaoencontrada extends StatelessWidget {
  const Paginanaoencontrada({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('404 - Página Não Encontrada'),
      ),
      body: const Center(
        child: Text(
          'A página que você está procurando não foi encontrada.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}