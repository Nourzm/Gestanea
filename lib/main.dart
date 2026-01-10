// lib/main.dart
import 'package:flutter/material.dart';
import 'app.dart';
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() {
  runApp(const MyApp());
}
