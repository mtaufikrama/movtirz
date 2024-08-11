import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:movtirz/app/data/constant.dart';
import 'package:movtirz/app/data/function.dart';

import 'publics.dart';

class LocalStorages {
  static GetStorage boxSessionID = GetStorage('session_movtirz');

  // untuk menambahkan sessionID kedalam local storage
  static Future<void> get setSessionID async {
    String sessionID = getSessionID;
    String expiredDate = getExpSessionID;
    String requestToken = getRequestToken;
    if (DateTime.parse(getExpSessionID).isBefore(DateTime.now())) {
      try {
        sessionID = await Publics.controller.tmdbApi.v3.auth
            .createSession(requestToken);
      } on DioException catch (e) {
        await Get.defaultDialog(
          title: e.error.toString(),
          content: Text(e.message.toString()),
          onConfirm: () async {
            await MyFx.launch(
              MyCons.pathSession + LocalStorages.getRequestToken,
            );
          },
        );
        return;
      }
      expiredDate = DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(DateTime.now().add(const Duration(days: 1)));
    }
    await boxSessionID.write('session_id', sessionID);
    await boxSessionID.write('exp_session_id', expiredDate);
    Publics.controller.getSession.value = LocalStorages.getSessionID;
    return;
  }

  // untuk menambahkan sessionID kedalam local storage
  static Future<void> get setRequestToken async {
    String expiredDate = getExpRequestToken;
    String requestToken = getRequestToken;
    if (DateTime.parse(getExpRequestToken).isBefore(DateTime.now())) {
      requestToken =
          await Publics.controller.tmdbApi.v3.auth.createRequestToken();
      expiredDate = DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(DateTime.now().add(const Duration(days: 1)));
    }
    await boxSessionID.write('request_token', requestToken);
    await boxSessionID.write('exp_request_token', expiredDate);
    Publics.controller.getSession.value = LocalStorages.getSessionID;
    return;
  }

  // mengambil session ID dalam local storage
  static String get getSessionID =>
      boxSessionID.listenable.value['session_id'] ?? '';

  // mengambil Request Token dalam local storage
  static String get getRequestToken =>
      boxSessionID.listenable.value['request_token'] ?? '';

  // mengambil Data Expired Date Session ID dalam local storage
  static String get getExpSessionID =>
      boxSessionID.listenable.value['exp_session_id'] ??
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  // mengambil Data Expired Date Request Token dalam local storage
  static String get getExpRequestToken =>
      boxSessionID.listenable.value['exp_request_token'] ??
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
}
