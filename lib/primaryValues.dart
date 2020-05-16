import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme {
  static const TextStyle title = TextStyle(
    fontFamily: 'WorkSans',
    color: Colors.black,
    fontSize: 26,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5
  );
  static const TextStyle display_group_1 = TextStyle(
    fontFamily: 'WorkSans',
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5
  );

  static final TextStyle display_group_2 = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0.5
  );

  // static const TextStyle display2 = TextStyle(
  //   fontFamily: 'WorkSans',
  //   color: Colors.black,
  //   fontSize: 32,
  //   fontWeight: FontWeight.normal,
  //   letterSpacing: 1.1
  // );

  static const TextStyle notesTitle = TextStyle(
    fontFamily: 'WorkSans',
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5
  );

  static const TextStyle notesDescription = TextStyle(
    fontFamily: 'WorkSans',
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5
  );

  static const TextStyle notesDate = TextStyle(
    fontFamily: 'WorkSans',
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0
  );

  static final TextStyle heading = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static final TextStyle subHeading = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 20,
    fontWeight: FontWeight.w300,
    color: Colors.black,
    letterSpacing: 0.5
  );
}