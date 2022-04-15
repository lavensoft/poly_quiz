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
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        if (!await launch("https://lavenes.com")) throw 'Could not launch url';
      },
      child: Container(
        margin: const EdgeInsets.only(top: 48, bottom: 0),
        padding: const EdgeInsets.all(24),
        child: const Center(
          child: Text(
            "Designed by Lavenes in Ho Chi Minh city.",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF414141),
              fontWeight: FontWeight.w600
            )
          ),
        )
      ),
    );
  }
}