import 'package:flutter/material.dart';
import 'package:multiple_image_picker_widget/multiple_image_picker.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _selectImages() {
    Get.to(() => const MultiplePicker());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectImages,
        tooltip: 'Image Select',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MultiplePicker extends StatefulWidget {
  const MultiplePicker({super.key});

  @override
  State<MultiplePicker> createState() => _MultiplePickerState();
}

class _MultiplePickerState extends State<MultiplePicker> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: MultipleImagePicker());
  }
}
