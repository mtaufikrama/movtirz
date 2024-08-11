import 'package:get/get.dart';

import '../modules/detail-movie/bindings/detail_movie_binding.dart';
import '../modules/detail-movie/views/detail_movie_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/see-more/bindings/see_more_binding.dart';
import '../modules/see-more/views/see_more_view.dart';
import '../modules/splash-screen/bindings/splash_screen_binding.dart';
import '../modules/splash-screen/views/splash_screen_view.dart';
import '../modules/user-profile/bindings/user_profile_binding.dart';
import '../modules/user-profile/views/user_profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.USER_PROFILE,
      page: () => const UserProfileView(),
      binding: UserProfileBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_MOVIE,
      page: () => const DetailMovieView(),
      binding: DetailMovieBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SEE_MORE,
      page: () => const SeeMoreView(),
      binding: SeeMoreBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
  ];
}
