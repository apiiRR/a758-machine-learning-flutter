import 'package:house_price_predictor_app/controller/controller.dart';
import 'package:house_price_predictor_app/controller/house_detail_provider.dart';
import 'package:house_price_predictor_app/model/house_detail.dart';
import 'package:house_price_predictor_app/service/service.dart';
import 'package:house_price_predictor_app/widget/form_field_counter.dart';
import 'package:house_price_predictor_app/widget/form_field_free_number.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
              ChangeNotifierProvider(create: (context) => BedroomsProvider()),
              ChangeNotifierProvider(create: (context) => BathroomsProvider()),
              ChangeNotifierProvider(create: (context) => FloorsProvider()),
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
  late final sqftController = TextEditingController();
  // todo-04-ui-01: add controller and close it in dispose function
  late final liteRtController = context.read<LiteRtController>();

  @override
  void dispose() {
    sqftController.dispose();
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
          onPressed: () {
            // todo-04-ui-02: add callback to run the inference
            final houseDetail = HouseDetail(
              floors: context.read<FloorsProvider>().value,
              bedrooms: context.read<BedroomsProvider>().value,
              bathrooms: context.read<BathroomsProvider>().value,
              sqftLot: double.tryParse(sqftController.text) ?? 0,
            );

            liteRtController.runInference(houseDetail);
          },
          child: Text("Prediksi Harga Rumah"),
        ),
        SizedBox(height: 8),
        // todo-04-ui-03: consume the state using Consumer
        Consumer<LiteRtController>(
          builder: (_, value, __) {
            final price = NumberFormat().format(value.number);
            return Text(
              "\$$price",
              style: Theme.of(context).textTheme.displaySmall,
            );
          },
        ),
      ],
    );
  }
}
