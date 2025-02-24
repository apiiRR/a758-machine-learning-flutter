import 'package:house_price_predictor_app/controller/house_detail_provider.dart';
import 'package:house_price_predictor_app/widget/form_field_counter.dart';
import 'package:house_price_predictor_app/widget/form_field_free_number.dart';
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
              ChangeNotifierProvider(create: (context) => BedroomsProvider()),
              ChangeNotifierProvider(create: (context) => BathroomsProvider()),
              ChangeNotifierProvider(create: (context) => FloorsProvider()),
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
  late final sqftController = TextEditingController();

  @override
  void dispose() {
    sqftController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        Text(
          'House Price Predictor',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 8),
        FormFieldCounter(
          titleField: "Floors",
          number: context
              .select<FloorsProvider, double>((provider) => provider.value),
          onIncrement: () => context.read<FloorsProvider>().increment(),
          onDecrement: () => context.read<FloorsProvider>().decrement(),
        ),
        FormFieldCounter(
          titleField: "Bedrooms",
          number: context
              .select<BedroomsProvider, double>((provider) => provider.value),
          onIncrement: () => context.read<BedroomsProvider>().increment(),
          onDecrement: () => context.read<BedroomsProvider>().decrement(),
        ),
        FormFieldCounter(
          titleField: "Bathrooms",
          number: context
              .select<BathroomsProvider, double>((provider) => provider.value),
          onIncrement: () => context.read<BathroomsProvider>().increment(),
          onDecrement: () => context.read<BathroomsProvider>().decrement(),
        ),
        FormFieldFreeNumber(
          titleField: "Square Feet Lot",
          controller: sqftController,
        ),
        SizedBox(height: 8),
        FilledButton(
          onPressed: () {},
          child: Text("Prediksi Harga Rumah"),
        ),
        SizedBox(height: 8),
        Text(
          "\$0",
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ],
    );
  }
}
