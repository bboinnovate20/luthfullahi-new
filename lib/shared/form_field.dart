// ignore_for_file: avoid_unnecessary_containers
import 'package:flutter/material.dart';

bool emailValidation(String email) {
  final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
  return emailRegex.hasMatch(email);
}

bool passwordValidation(password) {
  final RegExp passwordRegex = RegExp(r'^(?=.*[0-9])[\w\W]{8,}$');
  return passwordRegex.hasMatch(password);
}

bool phoneValidator(password) {
  final RegExp passwordRegex = RegExp(r'^[0-9]{9,}$');
  return passwordRegex.hasMatch(password);
}

// ignore: must_be_immutable
class InputCustom extends StatelessWidget {
  Function validate;
  String placeholder;
  bool obscure;
  TextInputType keyboard;
  int maxLines;
  String helperText;
  TextEditingController controller;

  InputCustom(
      {super.key,
      required this.validate,
      required this.placeholder,
      required this.obscure,
      required this.keyboard,
      required this.helperText,
      required this.controller,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              placeholder,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.right,
            ),
          ),
          TextFormField(
            cursorColor: Colors.black,
            style: const TextStyle(fontWeight: FontWeight.normal),
            obscureText: obscure,
            autocorrect: true,
            controller: controller,
            validator: (value) {
              return validate(value);
            },
            // controller: controller,
            keyboardType: keyboard,
            maxLines: maxLines,
            decoration: InputDecoration(
              helperText: helperText,
              helperStyle: const TextStyle(fontSize: 11, color: Colors.red),
              contentPadding: const EdgeInsets.all(17),
              alignLabelWithHint: true,
              labelText: null,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      width: 1.5, color: Color.fromRGBO(232, 232, 232, 1))),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              labelStyle: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }
}

class InputCustomDate extends StatefulWidget {
  Function validate;
  String placeholder;
  bool obscure;
  VoidCallback action;
  TextEditingController dateinput = TextEditingController();
  InputCustomDate(
      {super.key,
      required this.action,
      required this.validate,
      required this.placeholder,
      required this.obscure,
      required this.dateinput});

  @override
  State<InputCustomDate> createState() => _InputCustomDateState();
}

class _InputCustomDateState extends State<InputCustomDate> {
  //text editing controller for text field

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              widget.placeholder,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.right,
            ),
          ),
          TextFormField(
            controller: widget.dateinput, //editing controller of this TextField
            obscureText: widget.obscure,
            autocorrect: true,
            readOnly: true,
            keyboardType: TextInputType.datetime,
            onTap: () => widget.action(),

            validator: (value) {
              widget.validate(value);
              return null;
            },

            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(17),
              alignLabelWithHint: true,
              labelText: null,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      width: 1.5, color: Color.fromRGBO(232, 232, 232, 1))),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(10),
              ),
              labelStyle: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }
}
