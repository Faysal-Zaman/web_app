import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MySnackBar {
  static error(cntx, String? message) {
    showTopSnackBar(
      cntx,
      CustomSnackBar.error(
        message: message!,
      ),
    );
  }

  static info(cntx, String? message) {
    showTopSnackBar(
      cntx,
      CustomSnackBar.info(
        message: message!,
      ),
    );
  }

  static success(cntx, String? message) {
    showTopSnackBar(
      cntx,
      CustomSnackBar.success(
        message: message!,
      ),
    );
  }
}
