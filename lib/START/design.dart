import 'package:flutter/material.dart';

final primaryColor = Color.fromRGBO(25, 32, 67, 1);
final itemBackgroundColor = Color.fromRGBO(87, 105, 126, 1);

final h1Style = TextStyle(fontSize: 40, fontFamily: 'Helvetica Neue', fontWeight: FontWeight.w300, color: Colors.white);
final h2Style = TextStyle(fontSize: 25, fontFamily: 'Helvetica Neue', fontWeight: FontWeight.w300, height: 1, color: Colors.white);
final h3Style = TextStyle(fontSize: 20, fontFamily: 'Helvetica Neue', fontWeight: FontWeight.w300, color: Colors.white);
final h4Style = TextStyle(fontSize: 20, fontFamily: 'Helvetica Neue', fontWeight: FontWeight.w300, height: 1, color: Colors.white, decoration: TextDecoration.underline);

final productText = TextStyle(fontSize: 15, fontFamily: 'Helvetica Neue', fontWeight: FontWeight.w300, color: Colors.white);

final infoboxStyle = TextStyle(fontSize: 18, fontFamily: 'Helvetica Neue', fontWeight: FontWeight.w300, height: 1, color: const Color.fromARGB(255, 28, 27, 27).withValues(alpha: 100), backgroundColor: Colors.amber);
final infoboxDecoration = BoxDecoration(color: infoboxStyle.backgroundColor!, borderRadius: BorderRadius.circular(10));
final doButtonStyle = TextStyle(fontSize: 20, fontFamily: 'Helvetica Neue', fontWeight: FontWeight.w300, height: 1, color: Colors.white, backgroundColor: itemBackgroundColor);

final noteStyle = TextStyle(fontSize: 15, fontFamily: 'Helvetica Neue', fontWeight: FontWeight.w300, height: 1, color: const Color.fromARGB(255, 28, 27, 27).withValues(alpha: 100));
