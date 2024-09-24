import 'package:flutter/material.dart';
import 'package:socially/core/common/widgets/loading/loading_indicator.dart';

Future<dynamic> loadingDialog(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => const LoadingIndicator(),
  );
}
