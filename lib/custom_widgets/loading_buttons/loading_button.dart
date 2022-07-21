// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makduman_lib/core/enums/durations_enum.dart';

import '../../core/enums/button_state.dart';
import '../../helpers/helpers.dart';
import '../../providers/provider_data.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton(
      {Key? key,
      required this.buttonTxt,
      required this.bgColor,
      required this.onPressed,
      required this.whenLoaded,
      this.indicatorColor,
      this.width = 200,
      this.height = 60,
      this.smallSize = 50,
      this.doubleClickable = false,
      this.duration})
      : super(key: key);
  final Widget buttonTxt;
  final Color bgColor;
  final Color? indicatorColor;
  final Future Function() onPressed;
  final FutureOr<void> Function(dynamic) whenLoaded;
  final double width, height, smallSize;
  final Duration? duration;
  final bool doubleClickable;

  @override
  Widget build(BuildContext context) {
    final ProviderData data = gData(context);

    return GestureDetector(
      onTap: () async {
        await _onPressed(data);
      },
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: duration == null ? Durations.low.value : duration!,
              decoration: _boxDecoration(data),
              width: data.buttonState != ButtonState.init ? smallSize : width,
              height: data.buttonState != ButtonState.init ? smallSize : height,
              child: Center(
                child: data.buttonState == ButtonState.loading
                    ? Platform.isIOS
                        ? CupertinoActivityIndicator(
                            color: indicatorColor,
                          )
                        : CircularProgressIndicator(
                            color: indicatorColor,
                          )
                    : data.buttonState == ButtonState.error
                        ? const Icon(
                            Icons.warning_rounded,
                            color: Colors.white,
                          )
                        : data.buttonState == ButtonState.completed
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                              )
                            : buttonTxt,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration(ProviderData data) {
    return BoxDecoration(
      color: data.buttonState == ButtonState.completed
          ? Colors.green
          : data.buttonState == ButtonState.error
              ? Colors.redAccent
              : Colors.purple,
      borderRadius: BorderRadius.circular(data.buttonState != ButtonState.init ? 500 : 12),
    );
  }

  void _changeLoading(ProviderData data, ButtonState state) {
    data.buttonState = state;
  }

  Future<void> _onPressed(ProviderData data) async {
    if (!doubleClickable && data.buttonState != ButtonState.init) return;
    _changeLoading(data, ButtonState.loading);
    await onPressed.call().then((value) {
      _changeLoading(data, ButtonState.completed);
      whenLoaded(value);
    }).catchError(
      (e) {
        print(e.toString());
        _changeLoading(data, ButtonState.error);
        Future.delayed(Durations.high.value, () {
          data.buttonState = ButtonState.init;
        });
      },
    );
  }
}
