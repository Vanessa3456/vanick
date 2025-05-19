import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TextForm extends StatelessWidget {
  // final text;
  final containerWidth;
  final hintText;
  // final maxLine;
  final filter;
  final controller;
  final validator;
  final bool obsecure;
  final keyboardType;
  const TextForm({
    Key? key,
    // @required this.text,
    @required this.containerWidth,
    @required this.hintText,
    required this.obsecure,
    // @required this.filter,
    // this.maxLine,
    this.controller,
    this.validator,
    this.filter,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 5,
        ),
        SizedBox(
            width: containerWidth,
            child: TextFormField(
              validator: validator, //checks if the text meeets our condition
              controller: controller,
              inputFormatters: filter,
              // inputFormatters: [
              //   LengthLimitingTextInputFormatter(10),
              //   FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
              // ],
              // maxLines: maxLine == null ? null : maxLine,
              decoration: InputDecoration(
                  errorBorder: OutlineInputBorder(
                    borderSide: //outline preferences
                        BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: //outline preferences
                        BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: //outline preferences
                        BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  hintText: hintText,
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey)

                  // hintStyle: GoogleFonts.poppins(fontSize: 14),
                  ),
              obscureText: obsecure,
              keyboardType: keyboardType,

              // validator: (text) {
              //   if (RegExp("\\bpaulina\\b", caseSensitive: false)
              //       .hasMatch(text.toString())) return 'Match found';
              // },
              // autovalidateMode: AutovalidateMode.onUserInteraction,
            )),
      ],
    );
  }
}

class Space extends StatelessWidget {
  const Space(
      {super.key, this.containerWidth = 0.0, this.containerHeight = 0.0});
  final double containerWidth;
  final double containerHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: containerHeight,
      width: containerWidth,
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.text, required this.onTap});
  final String text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class OutlineButtons extends StatefulWidget {
  const OutlineButtons({super.key, required this.route, required this.text});
  final String route;
  final String text;

  @override
  State<OutlineButtons> createState() => _OutlineButtonsState();
}

class _OutlineButtonsState extends State<OutlineButtons> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.pushNamed(context, widget.route);
      },
      child: Text(widget.text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )),
      style: OutlinedButton.styleFrom(
          side: BorderSide(
            width: 2,
          ),
          backgroundColor: Colors.grey.shade300),
    );
  }
}

void showToast({required String message}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0);
}
