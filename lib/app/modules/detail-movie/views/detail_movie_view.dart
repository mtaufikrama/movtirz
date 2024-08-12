import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:movtirz/app/data/constant.dart';
import 'package:movtirz/app/data/function.dart';
import 'package:movtirz/app/data/publics.dart';

import '../controllers/detail_movie_controller.dart';

class DetailMovieView extends GetView<DetailMovieController> {
  const DetailMovieView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            MyFx.image(MyCons.pathImage +
                controller.movie['backdrop_path'].toString()),
            ListView(
              children: [
                const AspectRatio(aspectRatio: 16 / 8),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Divider(
                        thickness: 3,
                        endIndent: Get.context!.width / 2.5,
                        indent: Get.context!.width / 2.5,
                      ),
                      Text(
                        controller.movie['original_title'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          controller.movie['overview'].toString(),
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      MyFx.future(
                        future: Publics.controller.tmdbApi.v3.movies
                            .getSimilar(int.parse(controller.movieID ?? "0")),
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
                            itemCount: movies.length,
                            itemBuilder: (context, index) {
                              final movie = movies[index];
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: MyFx.poster(movie),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const BackButton(),
          ],
        ),
      ),
    );
  }
}
