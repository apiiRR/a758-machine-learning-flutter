import 'package:firebase_ml_app/controller/controller.dart';
import 'package:firebase_ml_app/service/firebase_ml_service.dart';
import 'package:firebase_ml_app/service/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: MultiProvider(
            providers: [
              // todo-07: add and inject FirebaseMlService to LiteRtService
              Provider(
                create: (context) => FirebaseMlService(),
              ),
              Provider(
                create: (context) => LiteRtService(
                  context.read(),
                )..initModel(),
              ),
              ChangeNotifierProvider(
                create: (context) => LiteRtController(
                  context.read(),
                ),
              )
            ],
            child: _HomeBody(),
          ),
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

  late final liteRtController = context.read<LiteRtController>();

  @override
  void dispose() {
    controller.dispose();
    liteRtController.close();

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
            final text = controller.text;
            final number = double.tryParse(text) ?? 0.0;

            liteRtController.runInference(number);
          },
          child: Text("Prediksi Stok Bulan Depan"),
        ),
        SizedBox(height: 8),
        Consumer<LiteRtController>(
          builder: (_, value, __) {
            final text = value.number.toStringAsFixed(1);
            return Text(
              text,
              style: Theme.of(context).textTheme.headlineSmall,
            );
          },
        ),
      ],
    );
  }
}
