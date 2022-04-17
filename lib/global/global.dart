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

import "package:flutter/material.dart";

export "api.dart";
export "func.dart";

class Global {
  static final bool DEBUG = false;
  //*RANKING
  static List<String> rankBadges = [
    "diamondRank.svg",
    "emeraldRank.svg",
    "rubyRank.svg",
    "goldRank.svg",
    "sapphireRank.svg",
  ];

  static String getUserRankBadge(int userRank, int total) {
    double rank = userRank / total * rankBadges.length;

    if(userRank <= 1) {
      return rankBadges[0];
    }

    return rankBadges[rank.ceil() - 1];
  }
}