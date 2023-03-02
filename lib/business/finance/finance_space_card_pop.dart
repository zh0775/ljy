import 'package:cxhighversion2/util/app_default.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinanceSpaceCardPopBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<FinanceSpaceCardPopController>(
        FinanceSpaceCardPopController(datas: Get.arguments));
  }
}

class FinanceSpaceCardPopController extends GetxController {
  final dynamic datas;
  FinanceSpaceCardPopController({this.datas});
}

class FinanceSpaceCardPop extends GetView<FinanceSpaceCardPopController> {
  const FinanceSpaceCardPop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getDefaultAppBar(context, "我要推广"),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
                image: AssetImage(assetsName("business/finance/bg_tuiguang")))),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [gwb(375), ghb(45)],
          ),
        ),
      ),
    );
  }
}
