import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../../../data/function.dart';
import '../../../data/publics.dart';
import '../controllers/user_profile_controller.dart';

class UserProfileView extends GetView<UserProfileController> {
  const UserProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserProfileView'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Text(
              "Favorite Movies",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          MyFx.future(
            future: Publics.controller.tmdbApi.v3.account.getFavoriteMovies(
              Publics.controller.getSession.value,
              Publics.controller.getAccountID,
              language: 'id-ID',
              sortBy: SortBy.createdAtDes,
            ),
            builder: (context, data) {
              final movies = data!['results'] as List;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    movies.length,
                    (index) {
                      final movie = movies[index];
                      return SizedBox(
                        width: context.width / 3.2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: AspectRatio(
                            aspectRatio: 1 / 2,
                            child: MyFx.poster(movie),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Text(
              "Watch List",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          MyFx.future(
            future: Publics.controller.tmdbApi.v3.account.getMovieWatchList(
              Publics.controller.getSession.value,
              Publics.controller.getAccountID,
              language: 'id-ID',
              sortBy: SortBy.createdAtDes,
            ),
            builder: (context, data) {
              final movies = data!['results'] as List;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    movies.length,
                    (index) {
                      final movie = movies[index];
                      return SizedBox(
                        width: context.width / 3.2,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: AspectRatio(
                            aspectRatio: 1 / 2,
                            child: MyFx.poster(movie),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
