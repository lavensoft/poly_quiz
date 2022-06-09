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

export "func.dart";

class Global {
  static bool DEBUG = false;
  //*RANKING
  static List<String> rankBadges = [
    "diamondRank.png",
    "emeraldRank.png",
    "rubyRank.png",
    "goldRank.png",
    "sapphireRank.png",
  ];

  static String getUserRankBadge(int userRank, int total) {
    int rankIndex = ((userRank - 1)/((total - 1)/(rankBadges.length - 1))).ceil();

    return rankBadges[rankIndex];
  }
}