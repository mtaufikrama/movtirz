import 'dart:convert';
import 'dart:io' as io;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gif/gif.dart';
import 'package:movtirz/app/data/constant.dart';
import 'package:movtirz/app/modules/detail-movie/controllers/detail_movie_controller.dart';
import 'package:movtirz/app/routes/app_pages.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:url_launcher/url_launcher.dart';

import 'publics.dart';

class MyFx {
  // function untuk loading pada tampilan poster
  static shimmerPoster({
    bool isPoster = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: Container(
                color: Colors.grey,
              ),
            ),
            isPoster
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Container(
                        height: 15,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 15,
                        width: 50,
                        color: Colors.grey,
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  // fuction untuk tampilan poster
  static GestureDetector poster(
    dynamic movie, {
    bool isPoster = false,
  }) {
    final controller = Publics.controller;
    return GestureDetector(
      onTap: () {
        Get.delete<DetailMovieController>();
        Get.toNamed(
          Routes.DETAIL_MOVIE,
          parameters: {
            "movie_id": movie['id'].toString(),
          },
          arguments: movie,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            fit: StackFit.passthrough,
            children: [
              image(MyCons.pathImage + (movie['poster_path'] ?? '')),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: CircleAvatar(
                            backgroundColor: Colors.black87,
                            child: Text(
                              "${(movie['vote_average'] * 10 as double).round()}%",
                              style: const TextStyle(
                                color: Color(0xFF00FF08),
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: LikeButton(
                          size: 20,
                          bubblesColor: const BubblesColor(
                            dotPrimaryColor: Colors.pink,
                            dotSecondaryColor: Colors.blue,
                          ),
                          likeCountAnimationType: LikeCountAnimationType.part,
                          bubblesSize: 200,
                          isLiked:
                              (controller.getFavouriteList['results'] as List)
                                      .singleWhere(
                                        (element) =>
                                            element['id'] == movie['id'],
                                        orElse: () => '',
                                      )
                                      .isNotEmpty
                                  ? true
                                  : false,
                          circleColor: const CircleColor(
                            start: Colors.pink,
                            end: Colors.blue,
                          ),
                          onTap: (boolean) async {
                            await controller.tmdbApi.v3.account.markAsFavorite(
                              controller.getSession.value,
                              controller.getAccountID,
                              movie['id'],
                              MediaType.movie,
                              isFavorite: !boolean,
                            );
                            // print("Favourite : ${!boolean}");
                            controller.getFavouriteList.value = await controller
                                .tmdbApi.v3.account
                                .getFavoriteMovies(controller.getSession.value,
                                    controller.getAccountID);
                            return !boolean;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: LikeButton(
                          size: 20,
                          bubblesColor: const BubblesColor(
                            dotPrimaryColor: Colors.pink,
                            dotSecondaryColor: Colors.blue,
                          ),
                          likeBuilder: (isLiked) => isLiked
                              ? const Icon(
                                  Icons.bookmark,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.bookmark,
                                  color: Colors.grey,
                                ),
                          likeCountAnimationType: LikeCountAnimationType.part,
                          bubblesSize: 200,
                          isLiked: (controller.getWatchList['results'] as List)
                                  .singleWhere(
                                    (element) => element['id'] == movie['id'],
                                    orElse: () => '',
                                  )
                                  .isNotEmpty
                              ? true
                              : false,
                          circleColor: const CircleColor(
                            start: Colors.pink,
                            end: Colors.blue,
                          ),
                          onTap: (boolean) async {
                            await controller.tmdbApi.v3.account.addToWatchList(
                              controller.getSession.value,
                              controller.getAccountID,
                              movie['id'],
                              MediaType.movie,
                              shouldAdd: boolean,
                            );
                            // print("Watch List : ${!boolean}");
                            controller.getWatchList.value = await controller
                                .tmdbApi.v3.account
                                .getMovieWatchList(controller.getSession.value,
                                    controller.getAccountID);
                            return !boolean;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          isPoster
              ? Container()
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      movie['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // function untuk men simple kan future builder
  static FutureBuilder<T> future<T>({
    required Future<T>? future,
    required Widget Function(BuildContext context, T? data) builder,
    Widget Function(BuildContext context, T? data)? failedBuilder,
  }) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState != ConnectionState.waiting &&
            snapshot.data != null) {
          return builder(context, snapshot.data);
        } else {
          return failedBuilder != null
              ? failedBuilder(context, snapshot.data)
              : const Center(
                  child: CircularProgressIndicator(),
                );
        }
      },
    );
  }

  // untuk ngelaunch ke web yang kita tuju
  static Future<void> launch(String url, {bool isNewTab = false}) async {
    if (!await launchUrl(
      Uri.parse(url),
      webOnlyWindowName: isNewTab ? '_blank' : '_self',
    )) {
      throw Exception('Could not launch $url');
    }
  }

  // function agar image dalam asset/network/dll bisa dijalankan dalam satu function
  static Widget image(
    String image, {
    Color? color,
    BoxFit? fit,
    double? height,
    double? width,
    double aspectRatio = 3 / 4,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    if (image.startsWith('assets')) {
      final ext = image.substring(image.length - 4);
      if (ext == '.svg') {
        return SvgPicture.asset(
          image,
          fit: fit ?? BoxFit.contain,
          height: height,
          width: width,
        );
      } else if (ext == '.gif') {
        return Gif(
          image: AssetImage(image),
          color: color,
          fit: fit,
          height: height,
          width: width,
          autostart: Autostart.loop,
        );
      } else {
        return Image.asset(
          image,
          color: color,
          fit: fit,
          height: height,
          width: width,
          filterQuality: filterQuality,
        );
      }
    }
    if (!GetPlatform.isWeb) {
      if (io.File(image).existsSync()) {
        final ext = image.substring(image.length - 4);
        if (ext == '.svg') {
          return SvgPicture.file(
            io.File(image),
            fit: fit ?? BoxFit.contain,
            height: height,
            width: width,
          );
        } else if (ext == '.gif') {
          return Gif(
            image: FileImage(io.File(image)),
            color: color,
            fit: fit,
            height: height,
            width: width,
            autostart: Autostart.loop,
          );
        } else {
          return Image.file(
            io.File(image),
            color: color,
            fit: fit,
            height: height,
            width: width,
            filterQuality: filterQuality,
          );
        }
      }
    }
    if (image.startsWith('http')) {
      final ext = image.substring(image.length - 4);
      if (ext == '.svg') {
        return SvgPicture.network(
          image,
          fit: fit ?? BoxFit.contain,
          height: height,
          width: width,
        );
      } else if (ext == '.gif') {
        return Gif(
          image: NetworkImage(image),
          color: color,
          fit: fit,
          height: height,
          width: width,
          autostart: Autostart.loop,
        );
      } else {
        return CachedNetworkImage(
          imageUrl: image,
          placeholder: (context, url) => AspectRatio(
            aspectRatio: aspectRatio,
            child: const Icon(Icons.image),
          ),
          useOldImageOnUrlChange: true,
          errorWidget: (context, url, error) => AspectRatio(
            aspectRatio: aspectRatio,
            child: const Center(
              child: Icon(
                Icons.error,
              ),
            ),
          ),
        );
      }
    }
    return Image.memory(
      base64Decode(image),
      color: color,
      fit: fit,
      height: height,
      width: width,
      filterQuality: filterQuality,
    );
  }
}
