import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

bool oneTimeCheck(BuildContext context){
  final bool hasConnection = Provider.of<InternetConnectionStatus>(context, listen: false) ==
      InternetConnectionStatus.connected;
  return hasConnection;
}

bool continuesCheck(BuildContext context){
  bool hasConnection = Provider.of<InternetConnectionStatus>(context) ==
      InternetConnectionStatus.connected;
  return hasConnection;
}