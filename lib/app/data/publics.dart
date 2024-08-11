import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:movtirz/app/data/local_storages.dart';
import 'package:tmdb_api/tmdb_api.dart';

class UniverseController extends GetxController {
  // untuk mengambil session ID
  final getSession = LocalStorages.getSessionID.obs;
  // untuk mengambil account ID
  final getAccountID = 21428137;
  // untuk mengambil data Favourite List
  final getFavouriteList = {}.obs;
  // untuk mengambil data Watch List
  final getWatchList = {}.obs;
  // fetch data TMDB menggunakan library tmdb_api
  final tmdbApi = TMDB(
    ApiKeys(
      'e3aa775baad3ee2386c5b3b5abc6d9dc',
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlM2FhNzc1YmFhZDNlZTIzODZjNWIzYjVhYmM2ZDlkYyIsIm5iZiI6MTcyMzAyMjE5OC44NjA4ODksInN1YiI6IjY2YjMzNDdlMzVkMGMzOGMzMDU5NmZjNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.P5gcTVLIjBhtlAFMqqm9GeMlOS46GUXjQ3tWQbyrul4',
    ),
    dio: Dio(),
    defaultLanguage: 'id-ID',
    logConfig: const ConfigLogger.showAll(),
  );
}

class Publics {
  static var controller = Get.put(UniverseController());
}
