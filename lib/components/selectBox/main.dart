import 'package:flutter/material.dart';
import "../../global/func.dart";

class TextSelectBox extends StatefulWidget {
  TextSelectBox({Key? key, required this.label, required this.onPressed, this.isEmoji = false, this.wrong = false, this.correct = false , this.selected = false}) : super(key: key);

  final String label;
  final VoidCallback onPressed;
  final bool selected;
  final bool correct;
  final bool wrong;
  final bool isEmoji;

  @override
  _TextSelectBoxState createState() => _TextSelectBoxState();
}

class _TextSelectBoxState extends State<TextSelectBox> {
  @override
  Widget build(BuildContext context) {
    String title = widget.label;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: widget.selected || widget.correct || widget.wrong ? LinearGradient(
          begin: widget.correct || widget.wrong ? Alignment.topCenter : const Alignment(-1,-1),
          end: widget.correct || widget.wrong ? Alignment.bottomCenter :Alignment.bottomRight,
          colors: <Color>[
            Color(
              widget.correct ? 0xFFc5ff73 : (widget.wrong ? 0xFFff9797 : widget.selected ? 0xFFfbe20f : 0xFFFFFFFF)), 
            Color(
              widget.correct ? 0xFF04d700 : (widget.wrong ? 0xFFff424f : widget.selected ? 0xFFf68a0d : 0xFFFFFFFF)
            )],
        ) : null, 
        boxShadow: [
          BoxShadow(
            color: Color(widget.selected ? (widget.correct ? 0x54008b2f : (widget.wrong ? 0x69ef0000 : 0x69ef8000)) : 0x15000000),
            offset: const Offset(0, 0),
            blurRadius: 16,
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
              padding: EdgeInsets.only(
                left: widget.isEmoji ? (isMobile(context) ? 24 : 24) : (isMobile(context) ? 24 : 48), 
                right: widget.isEmoji ? (isMobile(context) ? 24 : 24) : (isMobile(context) ? 24 : 48), 
                top: widget.isEmoji ? (isMobile(context) ? 24 : 24) : (isMobile(context) ? 20 : 16), 
                bottom: widget.isEmoji ? (isMobile(context) ? 24 : 24) : (isMobile(context) ? 20 : 16)
              ),
              child: Text(title, style: TextStyle(
                fontSize: widget.isEmoji ? 20 : 15,
                color: widget.selected || widget.correct || widget.wrong ? Colors.white : const Color(0xFF06b5d8),
                fontWeight: FontWeight.w600,
                shadows: widget.selected ? [
                  const Shadow(
                    color: Color(0x60000000),
                    offset: Offset(0, 0),
                    blurRadius: 9,
                  )
                ] : null
              ))
            ),
          )),
      ),
    );
  }
}

class ImageSelectBox extends StatefulWidget {
  ImageSelectBox({Key? key, required this.image, required this.label, required this.onPressed, this.selected = false, this.width = 0, this.height = 0}) : super(key: key);

  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final bool selected;
  final AssetImage image;

  @override
  _ImageSelectBoxState createState() => _ImageSelectBoxState();
}

class _ImageSelectBoxState extends State<ImageSelectBox> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    String title = widget.label;
    double btnWidth = widget.width != 0 ? widget.width : 188;
    double btnHeight = widget.height != 0 ? widget.height : 163;

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 9),
          width: btnWidth,
          height: btnHeight - 6,
          decoration: BoxDecoration(
            color: Color(widget.selected ? 0xFF84D8FF : 0xFFE5E5E5),
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
                  height: btnHeight,
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(widget.selected ? 0xFF84D8FF: 0xFFE5E5E5), width: 2),
                    borderRadius: BorderRadius.circular(16),
                    color: Color(widget.selected ? 0xFFDCF3FF : 0xFFFFFFFF)
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: btnWidth,
                        height: btnHeight - 64,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: widget.image,
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      Text(title, textAlign: TextAlign.center, style: TextStyle(
                        color: Color(widget.selected ? 0xFF1899D6 : 0xFF4B4B4B),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      )
                    )
                  ],
                ),
              )
            ),
        )
      ],
    );
  }
}