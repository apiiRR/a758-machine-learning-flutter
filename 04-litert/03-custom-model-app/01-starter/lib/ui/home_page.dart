import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: _HomeBody(),
        ),
      ),
    );
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  late final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        Text(
          'Rice Stock Predictor',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text("Isi penjualan bulan ini (dalam kg)"),
        SizedBox(
          width: 150,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18,
                ),
          ),
        ),
        SizedBox(height: 8),
        FilledButton(
          onPressed: () {
            
          },
          child: Text("Prediksi Stok Bulan Depan"),
        ),
        SizedBox(height: 8),
       Text(
              "0.0",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
      ],
    );
  }
}
