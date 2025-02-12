import 'package:firebase_ml_app/controller/controller.dart';
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
          // todo-03-controller-04: add dependency injection
          child: MultiProvider(
            providers: [
              Provider(
                create: (context) => LiteRtService()..initModel(),
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
  // todo-04-ui-01: add controller and close it in dispose function
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
            // todo-04-ui-02: add callback to run the inference
            final text = controller.text;
            final number = double.tryParse(text) ?? 0.0;

            liteRtController.runInference(number);
          },
          child: Text("Prediksi Stok Bulan Depan"),
        ),
        SizedBox(height: 8),
        // todo-04-ui-03: consume the state using Consumer
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
