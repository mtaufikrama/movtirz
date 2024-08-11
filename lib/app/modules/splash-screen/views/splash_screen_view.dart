import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movtirz/app/data/function.dart';
import '../../../data/local_storages.dart';
import '../../../data/publics.dart';
import '../../../routes/app_pages.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView>
    with TickerProviderStateMixin {
  double _fontSize = 2;
  double _containerSize = 1.5;
  double _textOpacity = 0.0;
  double _containerOpacity = 0.0;

  late AnimationController _controller;
  late Animation<double> animation1;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    animation1 = Tween<double>(begin: 40, end: 20).animate(CurvedAnimation(
        parent: _controller, curve: Curves.fastLinearToSlowEaseIn))
      ..addListener(() {
        setState(() {
          _textOpacity = 1.0;
        });
      });

    _controller.forward();

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _fontSize = 1.06;
      });
    });

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _containerSize = 2;
        _containerOpacity = 1;
      });
    });

    Timer(
      const Duration(seconds: 2),
      () async {
        await LocalStorages.setSessionID;
        final controller = Publics.controller;
        controller.getFavouriteList.value =
            await Publics.controller.tmdbApi.v3.account.getFavoriteMovies(
                controller.getSession.value, controller.getAccountID);
        controller.getWatchList.value = await controller.tmdbApi.v3.account
            .getMovieWatchList(
                controller.getSession.value, controller.getAccountID);
        Get.offNamed(Routes.HOME);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AnimatedContainer(
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: context.height / _fontSize),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                opacity: _textOpacity,
                child: Text(
                  'MovTirz',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: animation1.value,
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 2000),
              curve: Curves.fastLinearToSlowEaseIn,
              opacity: _containerOpacity,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 2000),
                curve: Curves.fastLinearToSlowEaseIn,
                height: context.width / _containerSize,
                width: context.width / _containerSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: MyFx.image(
                  "assets/logo.png",
                  width: 110.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
