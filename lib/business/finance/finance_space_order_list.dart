import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FinanceSpaceOrderListBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<FinanceSpaceOrderListController>(FinanceSpaceOrderListController());
  }
}

class FinanceSpaceOrderListController extends GetxController {
  final dynamic datas;
  FinanceSpaceOrderListController({this.datas});

  final _topIdx = 0.obs;
  int get topIdx => _topIdx.value;
  set topIdx(v) => _topIdx.value = v;

  int type = 0;
  @override
  void onInit() {
    type = (datas ?? {})["type"] ?? 0;
    super.onInit();
  }
}

class FinanceSpaceOrderList extends GetView<FinanceSpaceOrderListController> {
  const FinanceSpaceOrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getDefaultAppBar(
        context,
        "",
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: centRow(List.generate(
              2,
              (index) => GetX<FinanceSpaceOrderListController>(
                    builder: (_) {
                      return CustomButton(
                        onPressed: () {
                          controller.topIdx = index;
                        },
                        child: SizedBox(
                          height: kToolbarHeight,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: getSimpleText(
                                  index == 0 ? "我的订单" : "推广订单",
                                  18,
                                  controller.topIdx == index
                                      ? AppColor.text
                                      : AppColor.text3,
                                  isBold: true),
                            ),
                          ),
                        ),
                      );
                    },
                  ))),
        ),
      ),
    );
  }
}
