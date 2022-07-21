import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/enums/button_state.dart';



class ProviderData extends ChangeNotifier {
  ButtonState _buttonState = ButtonState.init;
  ButtonState get buttonState => _buttonState;

  set buttonState(ButtonState value) {
    _buttonState = value;
    notifyListeners();
  }


}

