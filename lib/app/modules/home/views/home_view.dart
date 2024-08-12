import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:movtirz/app/data/constant.dart';
import 'package:movtirz/app/data/function.dart';
import 'package:movtirz/app/data/local_storages.dart';
import 'package:movtirz/app/data/publics.dart';
import 'package:movtirz/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MyFx.image('assets/logo.png'),
        title: const Text(
          "MovTirz",
          style: TextStyle(
            color: MyCons.warnaPrimer,
          ),
        ),
        actions: [
          Obx(
            () {
              return controller.sessionID.value.isNotEmpty
                  ? IconButton(
                      onPressed: () => Get.toNamed(Routes.USER_PROFILE),
                      icon: const Icon(
                        Icons.person,
                      ),
                    )
                  : Container();
            },
          ),
        ],
      ),
      body: Obx(
        () {
          return controller.sessionID.value.isNotEmpty
              ? ListView(
                  children: [
                    Container(
                      color: MyCons.warnaSekunder,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Now Playing",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          MyFx.future(
                            future: Publics.controller.tmdbApi.v3.movies
                                .getNowPlaying(language: 'id-ID'),
                            builder: (context, data) {
                              final movies = data!['results'] as List;
                              return CarouselSlider.builder(
                                itemCount: movies.length,
                                itemBuilder: (context, index, realIndex) {
                                  final movie = movies[index];
                                  return MyFx.poster(movie, isPoster: true);
                                },
                                options: CarouselOptions(
                                  aspectRatio: 4 / 3,
                                  viewportFraction: 0.5,
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  disableCenter: true,
                                  pauseAutoPlayInFiniteScroll: true,
                                  // padEnds: false,
                                  // enableInfiniteScroll: false,
                                ),
                              );
                            },
                            failedBuilder: (context, data) {
                              return CarouselSlider.builder(
                                itemCount: 3,
                                itemBuilder: (context, index, realIndex) {
                                  return MyFx.shimmerPoster(isPoster: true);
                                },
                                options: CarouselOptions(
                                  aspectRatio: 4 / 3,
                                  viewportFraction: 0.5,
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  disableCenter: true,
                                  pauseAutoPlayInFiniteScroll: true,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Popular",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    MyFx.future(
                      future: Publics.controller.tmdbApi.v3.movies
                          .getPopular(language: 'id-ID'),
                      builder: (context, data) {
                        final movies = data!['results'] as List;
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1 / 2,
                          ),
                          itemCount:
                              (movies.length > 20 ? 20 : movies.length) + 1,
                          itemBuilder: (context, index) {
                            if ((index + 1) ==
                                ((movies.length > 20 ? 20 : movies.length) +
                                    1)) {
                              return IconButton(
                                onPressed: () => Get.toNamed(Routes.SEE_MORE),
                                icon: const Icon(
                                  Icons.arrow_forward,
                                ),
                              );
                            } else {
                              final movie = movies[index];
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: MyFx.poster(movie),
                              );
                            }
                          },
                        );
                      },
                      failedBuilder: (context, data) {
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1 / 2,
                          ),
                          itemCount: 9,
                          itemBuilder: (context, index) {
                            return MyFx.shimmerPoster();
                          },
                        );
                      },
                    ),
                  ],
                )
              : Center(
                  child: TextButton(
                    onPressed: () async {
                      await LocalStorages.setSessionID;
                      Publics.controller.getFavouriteList.value = await Publics
                          .controller.tmdbApi.v3.account
                          .getFavoriteMovies(
                        Publics.controller.getSession.value,
                        Publics.controller.getAccountID,
                      );
                      Publics.controller.getWatchList.value = await Publics
                          .controller.tmdbApi.v3.account
                          .getMovieWatchList(
                        Publics.controller.getSession.value,
                        Publics.controller.getAccountID,
                      );
                      controller.sessionID.value = LocalStorages.getSessionID;
                    },
                    child: const Icon(
                      Icons.confirmation_num_rounded,
                    ),
                  ),
                );
        },
      ),
    );
  }
}
