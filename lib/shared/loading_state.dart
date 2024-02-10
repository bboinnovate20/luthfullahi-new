import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingNotifier {
  // LoadingNotifier() : super(false);
  bool state = false;

  void setLoading(bool isLoading) {
    state = isLoading;
  }
}