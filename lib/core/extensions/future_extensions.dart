import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

extension FutureExtension<T> on Future {
  Widget toBuild<T>({
    required Widget Function(T data) onSuccess,
    Widget? onError,
  }) {
    return FutureBuilder(
      future: this,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _networkNotFound;
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: _loading,
            );
          case ConnectionState.done:
            if (snapshot.hasData) {
              return onSuccess(snapshot.data as T);
            } else {
              if (onError != null) return onError;
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
        }
      },
    );
  }

  LottieBuilder get _networkNotFound => Lottie.network(LottieItems.noNetwork.lottiePath);
  LottieBuilder get _loading => Lottie.network(LottieItems.loading.lottiePath);
}

enum LottieItems { loading, noNetwork }

extension LottieItemsExtension on LottieItems {
  String _path() {
    switch (this) {
      case LottieItems.loading:
        return "https://assets2.lottiefiles.com/private_files/lf30_vut4pyyx.json";
      case LottieItems.noNetwork:
        return "https://assets7.lottiefiles.com/packages/lf20_nTfkVR.json";
    }
  }

  String get lottiePath => _path();
}
