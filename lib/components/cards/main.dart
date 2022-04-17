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

//* FEATURE QUIZ CARD
class FeatureQuizCard extends StatefulWidget {
  FeatureQuizCard({Key? key, required 
    this.title, 
    required this.subtitle, 
    required this.image, 
    required this.onTap, 
    this.purple = false, 
    this.orange = false}) : super(key: key);

  final String title;
  final String subtitle;
  final String image;
  final VoidCallback onTap;
  final bool purple;
  final bool orange;

  @override
  _FeatureQuizCardState createState() => _FeatureQuizCardState();
}

class _FeatureQuizCardState extends State<FeatureQuizCard> {
  bool onHover = false;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container( //*CARD
        width: 256,
        height: 348,
        //padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(widget.purple ? 0xFF9707f6 : 
                    widget.orange ? 0xFFf9c49c : 0xFF00dfef),
              Color(widget.purple ? 0xFF5f02e6 : 
                    widget.orange ? 0xFFff9c00 : 0xFF0ea0d4),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(widget.purple ? 0x4D5f02e6 :
                           widget.orange ? 0x4Dff5c00 : 0x4D0d9ed3),
              offset: const Offset(0, 12),
              blurRadius: 16,
            )
          ]
        ),
        child: Stack(
          children: [
            AnimatedSlide(
              offset: onHover ? const Offset(0, -.15) : const Offset(0, -.1), 
              curve: Curves.elasticOut,
              duration: const Duration(milliseconds: 1500),
              child: Center(
                  child: Container(
                  width: 200,
                  child: Image.network(widget.image),
                ),
              )
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  //*INFORMATION
                  AnimatedSlide(
                    offset: onHover ? const Offset(0, 0) : const Offset(0, 1.2), 
                    curve: Curves.elasticOut,
                    duration: const Duration(milliseconds: 1500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //*TITLE
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan( //*TITLE
                            text: widget.title,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),

                        //*SUBTITLE
                        const SizedBox(height: 5),
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan( //*SUBTITLE
                            text: widget.subtitle,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xEAFFFFFF),
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        
                      ],
                    )
                  ),
                
                  //*PLAY BUTTON
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    opacity: onHover ? 1 : 0, 
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.linear,
                    child: AnimatedSlide(
                      offset: onHover ? Offset(0, 0) : Offset(0, 1), 
                      curve: Curves.elasticOut,
                      duration: const Duration(milliseconds: 1500),
                        child: Container( //*PLAY BUTTON
                        padding: const EdgeInsets.fromLTRB(32, 12, 32, 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [ 
                              Color(widget.purple ? 0xFFfcfbfe : 
                                    widget.orange ? 0xFFfff9dc : 0xFFf0feff), 
                              Color(widget.purple ? 0xFFbb93f4 : 
                                    widget.orange ? 0xFFfab884 : 0xFFa0ddef) ],
                            begin: const Alignment(0.5, -1),
                            end: const Alignment(0.5, 1),
                          ),
                          borderRadius: BorderRadius.circular(25)
                        ),
                        child: Text(
                          "PLAY",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(widget.purple ? 0xFF6106e6 : 
                                         widget.orange ? 0xFFff9050 : 0xFF0ea2d5),
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ),
                    ),
                  )
                ],
              ),
            ),
            //*ON TAP
            Positioned(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: widget.onTap,
                  onHover: (value) {
                    setState(() {
                      onHover = value;
                    });
                  },
                ),
              ),
            ),
          ],
        )
      )
    );
  }
}

//* DETAIL QUIZ CARD
class DetailQuizCard extends StatefulWidget {
  DetailQuizCard({Key? key, required 
    this.title, 
    required this.subtitle, 
    required this.image, 
    required this.onTap, 
    this.purple = false, 
    this.orange = false}) : super(key: key);

  final String title;
  final String subtitle;
  final String image;
  final VoidCallback onTap;
  final bool purple;
  final bool orange;

  @override
  _DetailQuizCardState createState() => _DetailQuizCardState();
}

class _DetailQuizCardState extends State<DetailQuizCard> {
  bool onHover = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: const Alignment(0.5, -1),
          end: const Alignment(0.5, 1),
          colors: [
            Color(widget.purple ? 0xFF9707f6 : 
                  widget.orange ? 0xFFf9c49c : 0xFF00dfef),
            Color(widget.purple ? 0xFF5f02e6 : 
                  widget.orange ? 0xFFff9c00 : 0xFF0ea0d4),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(widget.purple ? 0x4D5f02e6 :
                         widget.orange ? 0x4Dff5c00 : 0x4D0d9ed3),
            offset: const Offset(0, 12),
            blurRadius: 16,
          )
        ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: widget.onTap,
          onHover: (value) {
            setState(() {
              onHover = value;
            });
          },
          child: Row(
            children: [
              //*IMAGE
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white.withOpacity(.25)
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Image.network(
                        widget.image,
                    ),
                )
              ),
              //*INFORMATION
              const SizedBox(width: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xAAFFFFFF)
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      )
    );
  }
}