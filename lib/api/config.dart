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

import "../../global/global.dart";

class APIConfig {
  static final Map<String, String> HEADERS = {
    "Content-Type": "application/json",
    //"w_api_key" : "wNp9EytjOb2WG7YqzqXQJxMqSQBWD8Zh8eRJf7Zo",
    "api_key" : "wNp9EytjOb2WG7YqzqXQJxMqSQBWD8Zh8eRJf7Zo",
    "app_id" : "625453bc7b3cbb43d51602a3",
  };

  static String API = Global.DEBUG ? "http://localhost:8085/api/v1" : "https://server.lavenes.com:8085/api/v1";
}