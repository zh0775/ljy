import 'package:cxhighversion2/util/app_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class ShoppingCartPageController extends GetxController {
  final _carNum = 0.obs;
  int get carNum => _carNum.value;
  set carNum(v) => _carNum.value = v;
}

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: defaultBackButton(context),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: GetX<ShoppingCartPageController>(
          init: ShoppingCartPageController(),
          builder: (controller) {
            return getSimpleText(
                "购物车 ${controller.carNum < 1 ? "" : "(${controller.carNum})"}",
                18,
                AppColor.text,
                isBold: true);
          },
        ),
        actions: [
          SizedBox(
            height: kTextTabBarHeight,
            width: 60.w,
            child: Center(
              child: getSimpleText("编辑", 14, AppColor.text2),
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.amber,
      ),
    );
  }
}
