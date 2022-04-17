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
import "package:jsqr/scanner.dart";

void qrScan(BuildContext context) async {
  var code = await showDialog(
  context: context,
  builder: (BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return AlertDialog(
      insetPadding: const EdgeInsets.all(5),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      title: const Text('Quét QR Code'),
      content: Container(
        color: Colors.white,
        height: height - 100 ,
        width: width - 72,
        child: Scanner()
        ),
    );
  });

  if(code.indexOf("gift_exchange") > -1) { //GIFT EXCHANGE
    Navigator.pushNamedAndRemoveUntil(
      context, 
      "/gems_exchange", 
      (route) => false,
      arguments: {
        "gems": int.parse(code.split("/")[2])
      }
    );
  }  
}