import 'package:flutter/material.dart';

class ViewModelProvider extends ChangeNotifier {
  bool isLoop = false;

  setIsLoop(loop) {
    isLoop = loop;
    notifyListeners();
  }
}
