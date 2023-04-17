import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:ipark/Constants/ipark_constants.dart';

class IParkComponents {

  static AppBar customAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      toolbarHeight: 60,
      leadingWidth: 50,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: IParkComponents.backPopButton(context),
      ),
    );
  }
  static InkWell backPopButton(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Align(
          alignment: Alignment.topLeft,
          child: Icon(
            FlutterRemix.arrow_left_s_line,
            size: 30,
            color: IParkColors.blackHeadlineColor,
          )),
    );
  }
  static Text headlineTextWidget(String content) {
    return Text(
      content,
      style: IParkStyles.font28HeadlineTextStyle,
    );
  }
  
}

class LargeCtaButton extends StatelessWidget with IParkComponents {
  final String textContent;
  final Function()? onPressed;
  const LargeCtaButton(
      {super.key, required this.textContent, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 59,
      width: 220,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: IParkColors.ctaButtonBackgroundColor,
            maximumSize: const Size(220, 60),
            shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Color.fromRGBO(125, 126, 200, 1),
                  width: 220,
                ),
                borderRadius: BorderRadius.circular(20)),
          ),
          child: Text(
            textContent,
            style: const TextStyle(
                fontFamily: IParkConstants.fontFamilyText,
                letterSpacing: IParkConstants.textLetterSpacing,
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.black),
          )),
    );
  }
}

class LargeCtaButtonTransparent extends StatelessWidget
    with IParkComponents {
  final String textContent;
  final Function()? onPressed;
  const LargeCtaButtonTransparent(
      {super.key, required this.textContent, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 59,
      width: 220,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            maximumSize: const Size(220, 60),
            shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.black87,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20)),
          ),
          child: Text(
            textContent,
            style: const TextStyle(
                fontFamily: IParkConstants.fontFamilyText,
                letterSpacing: IParkConstants.textLetterSpacing,
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.black87),
          )),
    );
  }
}

class CustomTextFieldStateful extends StatefulWidget {
  final String placeholderText;
  final TextEditingController controller;
  final bool isPassword;
  const CustomTextFieldStateful(
      {Key? key, required this.controller, required this.placeholderText,required this.isPassword})
      : super(key: key);

  @override
  State<CustomTextFieldStateful> createState() =>
      _CustomTextFieldStatefulState();
}

class _CustomTextFieldStatefulState extends State<CustomTextFieldStateful> {
  late FocusNode focusNode;

  bool isActive = false;
  @override
  void initState() {
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {
        isActive = focusNode.hasFocus;
      });
    });

    if (widget.controller.text.isNotEmpty) {
      setState(() {
        isActive = true;
      });
    } else {
      setState(() {
        isActive = false;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: CupertinoTextField(
        padding: const EdgeInsets.only(left: 24),
        controller: widget.controller,
        obscureText: widget.isPassword,
        placeholder: widget.placeholderText,
        style: IParkStyles.inputTextStyle,
        placeholderStyle: IParkStyles.inputPlaceholderStyle,
        onChanged: (val) {
          if (widget.controller.text.isNotEmpty) {
            setState(() {
              isActive = true;
            });
          } else {
            setState(() {
              isActive = false;
            });
          }
        },
        onTap: () {
          setState(() {
            isActive = true;
          });
        },
        decoration: BoxDecoration(
          border: Border.all(
              color: isActive
                  ? IParkColors.activeInputBorderColor
                  : IParkColors.stableInputBorderColor,
              width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}