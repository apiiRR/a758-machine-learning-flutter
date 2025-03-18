import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_recognition_app/controller/home_provider.dart';
import 'package:text_recognition_app/controller/result_provider.dart';
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
      // todo-08: cover the ResultProvider in the page
      body: ChangeNotifierProvider(
        create: (context) => ResultProvider(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const _ResultBody(),
          ),
        ),
      ),
    );
  }
}

// todo-09: change into statefulwidget
class _ResultBody extends StatefulWidget {
  const _ResultBody();

  @override
  State<_ResultBody> createState() => _ResultBodyState();
}

class _ResultBodyState extends State<_ResultBody> {
  // todo-10: run the recognition service via initState
  @override
  void initState() {
    super.initState();

    final homeProvider = context.read<HomeProvider>();
    final resultProvider = context.read<ResultProvider>();

    Future.microtask(() {
      resultProvider.runTextRecognition(homeProvider.imagePath!);
    });
  }

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
        // todo-14: add a widget to copy text
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () => context.read<ResultProvider>().copyText(context),
            icon: const Icon(Icons.copy),
          ),
        ),
        Expanded(
          // todo-11: Consume the widget
          child: Consumer<ResultProvider>(
            builder: (context, value, child) {
              // todo-12: show the progress indicator and the text
              final isProcessing = value.isProcessing;
              if (isProcessing) {
                return Center(child: CircularProgressIndicator());
              }

              final detectedText = value.detectedText;

              return SingleChildScrollView(
                child: Text(detectedText ?? ""),
              );
            },
          ),
        ),
      ],
    );
  }
}
