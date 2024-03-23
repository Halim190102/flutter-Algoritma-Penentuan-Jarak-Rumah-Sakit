import 'package:flutter/material.dart';
import 'package:rumkit/useable_widget/color.dart';
import 'package:rumkit/view/view_algoritma.dart';

snackBar(Widget content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: content,
    ),
  );
}

showModal(BuildContext context, Size size, String datas) {
  return showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    context: context,
    builder: (_) => Container(
      color: white,
      padding: EdgeInsets.only(top: size.height * 0.01),
      height: size.height * 0.68,
      child: BottomSheetData(
        datas: datas,
      ),
    ),
  );
}
