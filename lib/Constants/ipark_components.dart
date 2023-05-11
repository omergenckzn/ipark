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
  static Row headlineIconDescriptionWidget(
      String babyName, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 4,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IParkComponents.headlineTextWidget(babyName, TextAlign.start),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: IParkComponents.descriptionTextWidget(
                  description, TextAlign.start),
            )
          ],
        ),
      ],
    );
  }

  static Text headlineTextWidget(String content, TextAlign align) {
    return Text(
      content,
      textAlign: align,
      style: IParkStyles.font32HeadlineTextStyle,
    );
  }

  static Text descriptionTextWidget(String content, TextAlign align) {
    return Text(content,
        textAlign: align, style: IParkStyles.font16DescriptionTextStyle);
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

class DatePickerTextButton extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime date) setDate;
  const DatePickerTextButton(
      {Key? key, required this.initialDate, required this.setDate})
      : super(key: key);

  @override
  State<DatePickerTextButton> createState() => _DatePickerTextButtonState();
}

class _DatePickerTextButtonState extends State<DatePickerTextButton> {
  bool isDatePickerOpen = false;
  late DateTime pickedDate;

  @override
  void initState() {
    pickedDate = widget.initialDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String todayText = "Today";
    bool isToday = isTodayDecider();
    String pickedDateFormattedString =
        "${pickedDate.day}.${pickedDate.month}.${pickedDate.year}";

    return InkWell(
      onTap: () async {
        await datePickerLogic(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isToday ? todayText : pickedDateFormattedString,
            style: IParkStyles.datePickerDateIndicatorStyle,
          ),
          const SizedBox(
            width: 2,
          ),
          Icon(!isDatePickerOpen
              ? FlutterRemix.arrow_down_s_line
              : FlutterRemix.arrow_up_s_line)
        ],
      ),
    );
  }

  Future<void> datePickerLogic(BuildContext context) async {
    setState(() {
      isDatePickerOpen = true;
    });
    DateTime? tempDate = await datePickerModule(context);
    if (tempDate == null) {
      setState(() {
        isDatePickerOpen = false;
      });
    } else {
      setState(() {
        pickedDate = tempDate;
        isDatePickerOpen = false;
        widget.setDate(pickedDate);
      });
    }
  }

  Future<DateTime?> datePickerModule(BuildContext context) async {
    DateTime pickedDateTime = pickedDate;

    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (datePicked == null) {
      return null;
    }
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          pickedDateTime,
        ));
    if (pickedTime == null) {
      return null;
    }
    pickedDateTime = DateTime(
      datePicked.year,
      datePicked.month,
      datePicked.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    return pickedDateTime;
  }

  bool isTodayDecider() {
    DateTime now = DateTime.now();
    if (pickedDate.day == now.day &&
        pickedDate.month == now.month &&
        pickedDate.year == now.year) {
      return true;
    } else {
      return false;
    }
  }
}