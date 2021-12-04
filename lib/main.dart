import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AnimatedWidget Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'AnimatedWidget Demo Home Page'),
      initialBinding: BindingsBuilder.put(() => StateController()),
    );
  }
}

class StateController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final RxInt counter = 0.obs;

  late final AnimationController _animationController;

  @override
  void onInit() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    super.onInit();
  }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }
}

class MyHomePage extends GetView<StateController> {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: SlideSomethingWidget(
          translation: controller._animationController,
          count: controller.counter,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller._animationController.forward(from: 0);
          controller.counter.value++;
        },
        tooltip: 'DropBox',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SlideSomethingWidget extends AnimatedWidget {
  final RxInt count;

  SlideSomethingWidget({
    Key? key,
    required Animation<double> translation,
    required this.count,
  }) : super(
            listenable: Tween<Offset>(
              begin: const Offset(0, 0),
              end: const Offset(0, 1.5),
            ).animate(
              CurvedAnimation(
                parent: translation,
                curve: Curves.bounceOut,
              ),
            ),
            key: key);

  Animation<Offset> get _translation => listenable as Animation<Offset>;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: _translation.value,
      child: Container(
        width: 100,
        height: 100,
        alignment: Alignment.center,
        color: Colors.blue,
        child: Obx(
          () => Text(
            count.value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
