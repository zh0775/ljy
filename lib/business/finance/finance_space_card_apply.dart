import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/component/custom_input.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FinanceSpaceCardApplyBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<FinanceSpaceCardApplyController>(
        FinanceSpaceCardApplyController(datas: Get.arguments));
  }
}

class FinanceSpaceCardApplyController extends GetxController {
  final dynamic datas;
  FinanceSpaceCardApplyController({this.datas});

  final nameInputCtrl = TextEditingController();
  final noInputCtrl = TextEditingController();
  final phoneInputCtrl = TextEditingController();

  String applyInfoContent =
      "1.均不允许收集客户身份信息，购买复购积分只能用于联聚商城区以及联聚拓客合作  2.考核面签户成本，面签户成本均为250元  ";

  confirmAction() {}

  @override
  void onClose() {
    nameInputCtrl.dispose();
    noInputCtrl.dispose();
    phoneInputCtrl.dispose();
    super.onClose();
  }
}

class FinanceSpaceCardApply extends GetView<FinanceSpaceCardApplyController> {
  const FinanceSpaceCardApply({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => takeBackKeyboard(context),
      child: Scaffold(
        appBar: getDefaultAppBar(context, "在线申请", action: [
          CustomButton(
            onPressed: () {
              pushInfoContent(
                  title: "特别说明", content: controller.applyInfoContent);
            },
            child: SizedBox(
              width: 75.w,
              height: kToolbarHeight,
              child: Center(
                child: getSimpleText("特别说明", 14, AppColor.text2),
              ),
            ),
          )
        ]),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                width: 375.w,
                height: 300.w + 6.w,
                child: Stack(
                  children: [
                    Positioned.fill(
                        bottom: 6.w,
                        child: Image.asset(
                          assetsName("business/finance/bg_shenqing"),
                          width: 375.w,
                          height: 300.w,
                          fit: BoxFit.fill,
                        )),
                    Positioned.fill(
                        top: 271.w,
                        left: 15.w,
                        right: 15.w,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(8.w))),
                          child: sbRow([
                            centRow([
                              Container(
                                width: 3.w,
                                height: 15.w,
                                decoration: BoxDecoration(
                                    color: AppColor.theme,
                                    borderRadius:
                                        BorderRadius.circular(1.25.w)),
                              ),
                              gwb(8),
                              getSimpleText("请完善您的个人信息", 15, AppColor.text,
                                  isBold: true),
                            ]),
                          ], width: 315),
                        ))
                  ],
                ),
              ),
              Container(
                width: 345.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(8.w))),
                child: Column(
                  children: [
                    ghb(15),
                    inputView(0),
                    inputView(1),
                    inputView(2),
                    ghb(5),
                  ],
                ),
              ),
              ghb(30),
              getSubmitBtn(
                "立即申请",
                () {
                  takeBackKeyboard(context);
                  controller.confirmAction();
                },
                fontSize: 15,
                color: AppColor.theme,
                height: 45,
              ),
              ghb(10),
              getWidthText("*请确认以上信息与申请信息完全一致，填写错误将会导致申请无 法通过，或者无法查询办理进度。", 12,
                  AppColor.text3, 345, 2)
            ],
          ),
        ),
      ),
    );
  }

  Widget inputView(int type) {
    return sbhRow([
      getWidthText(
          type == 0
              ? "姓名"
              : type == 1
                  ? "身份证号"
                  : "手机号",
          14,
          AppColor.text2,
          60,
          1,
          textHeight: 1.3),
      CustomInput(
        width: (315 - 60 - 1).w,
        heigth: 50.w,
        textEditCtrl: type == 0
            ? controller.nameInputCtrl
            : type == 1
                ? controller.noInputCtrl
                : controller.phoneInputCtrl,
        placeholder: type == 0
            ? "请输入姓名"
            : type == 1
                ? "请输入身份证号"
                : "请输入手机号",
        keyboardType: type == 2 ? TextInputType.phone : TextInputType.text,
        style: TextStyle(fontSize: 14.w, color: AppColor.text2),
        placeholderStyle: TextStyle(fontSize: 14.w, color: AppColor.assisText),
      )
    ], width: 345 - 15 * 2, height: 50);
  }
}
