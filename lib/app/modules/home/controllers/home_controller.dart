import 'package:get/get.dart';
import 'package:movtirz/app/data/local_storages.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final sessionID = LocalStorages.getSessionID.obs;
}
