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
import "package:flutter/cupertino.dart";
import "package:quizz/lavenes.dart";
import "package:flutter_svg/svg.dart";

class CongrasScreen extends StatefulWidget {
  CongrasScreen({Key? key, required this.endScreenVisible, required this.onContinue, required this.gemsAfterAnswer, required this.gems, this.loading = false}) : super(key: key);

  final Function? onContinue;
  final int gemsAfterAnswer;
  final int gems;
  final bool endScreenVisible;
  final bool loading;

  @override
  _CongrasScreenState createState() => _CongrasScreenState();
}

class _CongrasScreenState extends State<CongrasScreen> {
  @override
  Widget build(BuildContext) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: !widget.loading ? [
        //* TITLE
        Text(
          widget.endScreenVisible ? (widget.gems > 0 ? "Bạn đã hoàn thành bài Quiz 🚀" : "Bạn đã thua cuộc vì đã hết số điểm 😭") :
          (widget.gemsAfterAnswer > 0 ? "Chúc Mừng 🎉" : "Bạn Đã Trả Lời Sai 🙁"),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Color(0x40000000),
                blurRadius: 12,
                offset: Offset(0, 0),
              )
            ]
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.endScreenVisible ? (widget.gems > 0 ? "Bạn đã nhận được ${widget.gems} gems sau khi hoàn thành bài quiz này!" : "Bạn đã mất hết gems vì đã trả lời sai!" ) :
          "Bạn đã ${widget.gemsAfterAnswer > 0 ? "thắng" : "mất"} ${widget.gemsAfterAnswer} gems!",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Color(0x40000000),
                blurRadius: 12,
                offset: Offset(0, 0),
              )
            ]
          ),
        ),

        //*GEMS COUNT
        UnconstrainedBox(
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
            margin: const EdgeInsets.fromLTRB(64, 24, 64, 24),
            decoration: BoxDecoration(
              color: const Color(0x45FFFFFF),
              borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              children: [
                Container( //*Gems icon
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    "assets/icons/gems.svg"
                  ),
                ),

                //*Gems count
                const SizedBox(width: 12),
                AnimatedFlipCounter(
                  //thousandSeparator: ".",
                  duration: const Duration(milliseconds: 2000),
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    // shadows: [
                    //   Shadow(
                    //     color: Color(0x40000000),
                    //     blurRadius: 12,
                    //     offset: Offset(0, 0),
                    //   )
                    // ]
                  ),
                  value: widget.gems, // pass in a value like 2014
                ),
              ],
            ),
          )
        ),

        //*CONTINUE BTN
        const SizedBox(height: 40),
        PrimaryButton(
          label: widget.endScreenVisible ? "Trở về trang chủ" : "Tiếp tục", 
          onPressed: () {
            widget.onContinue!();
          }
        )
      ] : [
        //*LOADING
        const CupertinoActivityIndicator(
          animating: true,
          radius: 14,
        ),
        const SizedBox(height: 20),
        const Text(
          "Bạn đợi một chút xíu nhe 🥳🥳",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Color(0x40000000),
                blurRadius: 12,
                offset: Offset(0, 0),
              )
            ]
          ),
        ),
      ],  
    );
  }
}