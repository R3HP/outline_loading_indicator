import 'dart:async';

import 'package:flutter/material.dart';

import 'package:outline_loading_indicator/circular_radial_gradient.dart';
import 'package:outline_loading_indicator/controll_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final AnimationController firstController;
  late final AnimationController secondController;
  late final AnimationController thirdController;
  late final Animation<double> firstAnimation;
  late final Animation<double> secondAnimation;
  late final Animation<double> thirdAnimation;
  late ColorTween colorTween;
  static const animationDuration = 900;

  static const loadingColor = Colors.blue;
  static const idleColor = Colors.blueGrey;
  static const successColor = Colors.green;
  static const failColor = Colors.red;

  Timer? loadingTimer;

  @override
  void initState() {
    super.initState();
    initAnimations();
    colorTween = ColorTween(begin: Colors.black, end: Colors.blueGrey);
  }

  void initAnimations() {
    firstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: animationDuration),
    );
    secondController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: animationDuration),
    );
    thirdController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: animationDuration),
    );
    firstAnimation = CurvedAnimation(
        parent: Tween<double>(begin: 0.0, end: 1).animate(firstController),
        curve: Curves.easeOut);
    secondAnimation = CurvedAnimation(
        parent: Tween<double>(begin: 0.0, end: 1).animate(secondController),
        curve: Curves.easeOut);
    thirdAnimation = CurvedAnimation(
        parent: Tween<double>(begin: 0.0, end: 1).animate(thirdController),
        curve: Curves.easeOut);
  }

  Future<void> startLoading() async {
    firstAnimation.addListener(() {
      if (firstAnimation.value >= firstController.upperBound / 2) {
        secondController.forward().then((value) => secondController.reset());
      }
    });
    secondAnimation.addListener(() {
      if (secondAnimation.value >= secondController.upperBound / 3) {
        thirdController.forward().then((value) => thirdController.reset());
      }
    });
    firstController.forward().then((value) => firstController.reset());
  }

  @override
  Widget build(BuildContext context) {
    const size = 200.0;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Outline Loading Indiator'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SizedBox(
                width: size,
                height: size,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularRadialGradient(
                      size: size,
                      rotateAnimation: thirdAnimation,
                      colorTween: colorTween,
                    ),
                    CircularRadialGradient(
                      size: size - 40,
                      rotateAnimation: secondAnimation,
                      colorTween: colorTween,
                    ),
                    CircularRadialGradient(
                      size: size - 100,
                      rotateAnimation: firstAnimation,
                      colorTween: colorTween,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ControllButton(
                  label: 'Loading',
                  callback: loadingTimer?.isActive ?? false ? null : () {
                    setState(() {
                      colorTween =
                          ColorTween(begin: idleColor, end: loadingColor);
                      loadingTimer =
                          Timer.periodic(thirdController.duration!, (timer) {
                        startLoading();
                      });
                    });
                  },
                  color: loadingColor),
              ControllButton(
                label: 'Stop',
                callback: loadingTimer == null
                    ? null
                    : () {
                        if (loadingTimer!.isActive) {
                          loadingTimer!.cancel();
                          setState(() {
                            colorTween =
                                ColorTween(begin: loadingColor, end: idleColor);
                            loadingTimer = null;
                          });
                        }
                      },
                color: idleColor,
              ),
              ControllButton(
                  label: 'Fail',
                  callback: loadingTimer == null
                      ? null
                      : () {
                          if (loadingTimer!.isActive) {
                            loadingTimer!.cancel();
                            loadingTimer = null;
                            colorTween =
                                ColorTween(begin: loadingColor, end: failColor);
                            setState(() {});
                          }
                        },
                  color: failColor),
              ControllButton(
                  label: 'Success',
                  callback: loadingTimer == null
                      ? null
                      : () {
                          if (loadingTimer!.isActive) {
                            loadingTimer!.cancel();
                            loadingTimer = null;
                            colorTween = ColorTween(
                                begin: loadingColor, end: successColor);
                            setState(() {});
                          }
                        },
                  color: successColor),
            ],
          )
        ],
      ),
    );
  }
}

