import 'package:flutter/material.dart';

const themeColor = Color(0xFF2C2C2C);
const primaryColor = Color.fromRGBO(245, 158, 11, 1);
const secondaryColor = Color.fromARGB(255, 110, 108, 105);
const contentColorLightTheme = Color(0xFF1D1D35);
const contentColor = Color(0xFFF5FCF9);
const warninngColor = Color(0xFFF3BB1C);
const errorColor = Color(0xFFF03738);

const defaultPadding = 20.0;

// const String BaseUrl = '';

String baseUrl = 'http://127.0.0.1:8000/api';

Map<String, String> headers = {};

const focusBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(10)),
  borderSide: BorderSide(color: primaryColor),
);
