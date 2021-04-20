import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

loadProgressIndicator(BuildContext context, String message) {
  ProgressDialog pr;
  pr = new ProgressDialog(context);
  pr.style(
      message: message,
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF321833))),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w700),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600));
  return pr;
}
