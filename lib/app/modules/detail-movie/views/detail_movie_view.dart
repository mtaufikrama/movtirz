import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:movtirz/app/data/function.dart';
import 'package:movtirz/app/data/publics.dart';

import '../controllers/detail_movie_controller.dart';

class DetailMovieView extends GetView<DetailMovieController> {
  const DetailMovieView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailMovieView'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          MyFx.future(
            future: Publics.controller.tmdbApi.v3.movies
                .getSimilar(int.parse(controller.movieID ?? "0")),
            builder: (context, data) {
              final movies = data!['results'] as List;
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}
