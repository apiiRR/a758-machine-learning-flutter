import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_recognition_app/controller/home_provider.dart';
import 'package:text_recognition_app/widget/image_widget.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Result Page'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const _ResultBody(),
        ),
      ),
    );
  }
}

class _ResultBody extends StatefulWidget {
  const _ResultBody();

  @override
  State<_ResultBody> createState() => _ResultBodyState();
}

class _ResultBodyState extends State<_ResultBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ImageWidget(
            imagePath: context.read<HomeProvider>().imagePath,
          ),
        ),
        Expanded(
          child: SizedBox(),
        ),
      ],
    );
  }
}
