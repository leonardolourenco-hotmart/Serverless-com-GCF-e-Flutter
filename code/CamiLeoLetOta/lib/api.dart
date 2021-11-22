import 'dart:async';
import 'package:CamiLeoLetOta/main.dart';

class Api {
  String url(String path) => 'API_URL';

  Map<String, String> buildJsonHeader() => {
        "content-type": "application/json; charset=utf-8",
      };
}
