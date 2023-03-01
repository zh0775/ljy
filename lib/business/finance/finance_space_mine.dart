import 'package:cxhighversion2/util/app_default.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class FinanceSpaceMineController extends GetxController {
  final dynamic datas;
  FinanceSpaceMineController({this.datas});
}

class FinanceSpaceMine extends GetView<FinanceSpaceMine> {
  const FinanceSpaceMine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getDefaultAppBar(context, "金融区"),
    );
  }
}
