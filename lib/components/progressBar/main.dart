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

//!TODO COMPLETE THIS

class ProgressBar extends StatefulWidget {
  ProgressBar({Key? key, required this.percentage}) : super(key: key);

  final double percentage;

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container( //*THUMB
          width: double.infinity,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E5E5),
            borderRadius: BorderRadius.circular(16)
          ),
        ),
        Positioned(//*THUMB BAR
          child: FractionallySizedBox(
            widthFactor: widget.percentage,
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFF58cc02),
                borderRadius: BorderRadius.circular(16)
              ),
            ),
          )
        ),
        Positioned( //*LIGHT BAR
          child: FractionallySizedBox(
            widthFactor: widget.percentage,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 3.2),
              child: Container(
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFF7ed651),
                  borderRadius: BorderRadius.circular(16)
                ),
              ),
            ),
          )
        ),
      ],
    );
  }
}