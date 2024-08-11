import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'publics.dart';

class LocalStorages {
  static GetStorage boxSessionID = GetStorage('session_movtirz');

  // untuk menambahkan sessionID kedalam local storage
  static Future<void> get setSessionID async {
    String sessionID = getSessionID;
    String expiredDate = getExpDateSession;
    String requestToken = getRequestToken;
    if (DateTime.parse(getExpDateSession).isBefore(DateTime.now())) {
      requestToken = '0efdf5337981652a38cd1b5b2ad5146313f5c0a8';
      // requestToken =
      //     await Publics.controller.tmdbApi.v3.auth.createRequestToken();
      sessionID =
          await Publics.controller.tmdbApi.v3.auth.createSession(requestToken);
      expiredDate = DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(DateTime.now().add(const Duration(days: 1)));
    }
    await boxSessionID.write('session_id', sessionID);
    await boxSessionID.write('expired_date', expiredDate);
    await boxSessionID.write('request_token', requestToken);
    Publics.controller.getSession.value = LocalStorages.getSessionID;
    return;
  }

  // mengambil session ID dalam local storage
  static String get getSessionID =>
      boxSessionID.listenable.value['session_id'] ?? '';

  // mengambil Request Token dalam local storage
  static String get getRequestToken =>
      boxSessionID.listenable.value['request_token'] ?? '';

  // mengambil Data Expired dalam local storage
  static String get getExpDateSession =>
      boxSessionID.listenable.value['expired_date'] ??
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
}
