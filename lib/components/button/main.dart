import 'package:flutter/material.dart';
import "../../global/func.dart";

class PrimaryButton extends StatefulWidget {
  PrimaryButton({Key? key, required this.label, required this.onPressed, this.width = 0, this.height = 0}) : super(key: key);

  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    String title = widget.label;
   
    return UnconstrainedBox(
      child: Container(
      height: isMobile(context) ? 50 : 46,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          transform: GradientRotation(0),
          colors: <Color>[Color(0xFFfbe20f), Color(0xFFf68a0d)],
        ), 
        boxShadow: const [
          BoxShadow(
            color: Color(0x69ef8000),
            offset: Offset(0, 0),
            blurRadius: 12,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashFactory: InkRipple.splashFactory,
          borderRadius: BorderRadius.circular(11),
          onTap: widget.onPressed,
          child: Center(
            child: Container(
              padding: EdgeInsets.only(left: isMobile(context) ? 48 : 96, right: isMobile(context) ? 48 : 96),
              child: Text(title, style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w600
              ))
            ),
          )),
      ),
    ),
    );
  }
}

class QButtonSecond extends StatefulWidget {
  QButtonSecond({Key? key, required this.label, required this.onPressed, this.width = 0, this.height = 0}) : super(key: key);

  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;

  @override
  _QButtonSecondState createState() => _QButtonSecondState();
}

class _QButtonSecondState extends State<QButtonSecond> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    String title = widget.label;
    double btnWidth = widget.width != 0 ? widget.width : title.length > 20 ? title.length * 13 : title.length * 20;

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 9),
          width: btnWidth,
          height: widget.height != 0 ? widget.height : 46,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E5E5),
            borderRadius: BorderRadius.circular(16)
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: isTapped ? 3 : 0),
          width: btnWidth,
          child: GestureDetector(
              onTapDown: (e) {
                setState(() {
                  isTapped = true;
                });

                widget.onPressed();
              }, 
              onTapUp: (e) {
                setState(() {
                  isTapped = false;
                });
              },
              child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xFFFFFFFF)
                  ),
                  child: Text(title, textAlign: TextAlign.center, style: const TextStyle(
                    color: Color(0xFF4B4B4B),
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ),
        )
      ],
    );
  }
}