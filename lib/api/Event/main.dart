/*
 * COPYRIGHT (c) 2022 Lavenes.
 * COPYRIGHT (c) 2022 Nhats Devil.
 *
 * This document is the property of Lavenes.
 * It is considered confidential and proprietary.
 *
 * This document may not be reproduced or transmitted in any form,
 * in whole or in part, without the express written permission of
 * Lavenes.
 */

import 'package:http/http.dart';
import "dart:convert";
import "package:shared_preferences/shared_preferences.dart";
import 'dart:math';
import '../config.dart';

class EventAPI {
  static Future checkin(String eventId) async {
    Response response = await post(Uri.parse("${APIConfig.API}/events/checkin"), body: utf8.encode(jsonEncode({
      "event" : eventId
    })), headers: await APIConfig.getHeaders());

    return json.decode(response.body);
  }
}
