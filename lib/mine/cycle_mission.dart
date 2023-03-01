import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class CycleMissionBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CycleMissionController>(
        CycleMissionController(datas: Get.arguments));
  }
}

class CycleMissionController extends GetxController {
  final dynamic datas;
  CycleMissionController({this.datas});

  final _haveNotify = true.obs;
  bool get haveNotify => _haveNotify.value;
  set haveNotify(v) => _haveNotify.value = v;
}

class CycleMission extends GetView<CycleMissionController> {
  const CycleMission({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getDefaultAppBar(context, "周期续约奖励"),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          GetX<CycleMissionController>(
            builder: (_) {
              return !controller.haveNotify
                  ? ghb(0)
                  : Container(
                      width: 375.w,
                      height: 28.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: const Color(0xFFFBFAE6)),
                      child: sbhRow([
                        Padding(
                          padding: EdgeInsets.only(left: 20.w),
                          child: Image.asset(
                            assetsName("mine/icon_notify_orange"),
                            width: 16.w,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: getWidthText(
                              "续货有效期：2022-07-01 00:00:00至2022-07-08 23:59:59",
                              10,
                              const Color(0xFFFF881E),
                              375 - 36 - 40 - 5,
                              1,
                              textHeight: 1.25),
                        ),
                        CustomButton(
                          onPressed: () {
                            controller.haveNotify = false;
                          },
                          child: SizedBox(
                            height: 28.w,
                            width: 40.w,
                            child: Center(
                              child: Image.asset(
                                assetsName("mine/icon_close_orange"),
                                width: 12.w,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        )
                      ], width: 375),
                    );
            },
          ),
          Container(
            width: 375.w,
            height: 255.w,
            color: AppColor.theme,
            child: Stack(children: [
              Positioned.fill(
                  child: Column(
                children: [
                  ghb(54),
                  centRow(List.generate(3, (index) {
                    return index == 1
                        ? gwb(40)
                        : centClm([
                            getSimpleText(index == 0 ? "本周期应续(台)" : "本周期实续(台)",
                                14, Colors.white),
                            ghb(10),
                            getSimpleText(
                                index == 0 ? "500" : "0", 30, Colors.white,
                                isBold: true),
                          ], crossAxisAlignment: CrossAxisAlignment.start);
                  })),
                  ghb(35),
                  centRow(List.generate(3, (index) {
                    return index == 1
                        ? Container(
                            width: 345.w - 12.w * 2,
                            height: 3.w,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3)),
                            child: Stack(
                              children: [
                                Positioned(
                                    top: 0,
                                    bottom: 0,
                                    left: 0,
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      height: 3.w,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7),
                                          borderRadius: BorderRadius.horizontal(
                                              right: Radius.circular(1.5.w))),
                                      width: (345.w - 12.w * 2) * 0.3,
                                    ))
                              ],
                            ),
                          )
                        : Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.w)),
                          );
                  })),
                  ghb(8),
                  sbRow([
                    getSimpleText("2022-07-01 00:00:00", 10,
                        Colors.white.withOpacity(0.5)),
                    getSimpleText("2022-07-01 00:00:00", 10,
                        Colors.white.withOpacity(0.5)),
                  ], width: 345),
                ],
              )),
              Positioned(
                  left: 15.w,
                  right: 15.w,
                  bottom: 0,
                  height: 60.w,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(8.w))),
                    child: getWidthText("本周期已完成续货任务,可获得续约奖励", 15, AppColor.text,
                        345 - 20 * 2, 1,
                        isBold: true),
                  )),
            ]),
          ),
          Container(
            width: 345.w,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.vertical(
                  bottom: Radius.circular(8.w),
                )),
            child: Column(
              children: [
                cellTitle("周期续约奖励"),
                ghb(15),
                getWidthText(
                    "    自升级运营中心日起，12个月后开始进入续约奖励周期，每6个月为1个周期，请于周期日起后的7天内通过“续约奖励采购单”一次性补齐300台设备(类型自由组合)，如续约成功，您本周期内可正常获得相应的积分奖励；如续约失败，您本周期内将无法获得相应的积分奖励。分润贡献2毛到平台。",
                    14,
                    AppColor.text2,
                    315,
                    1000),
                getWidthText(
                    "注：此奖励周期续约成功与否都不影响相应的分润结算。", 14, AppColor.red, 315, 1000),
                ghb(20),
                cellTitle("等级成长"),
                ghb(15),
                getWidthText("2022年01月08日成为高级运营中心\n2021年03月12日成为初级运营中心 ", 14,
                    AppColor.text2, 315, 1000),
                ghb(22),
              ],
            ),
          ),
          ghb(31),
          getSubmitBtn(
            "查看补货记录",
            () {},
            height: 45,
            color: AppColor.theme,
            fontSize: 15,
          ),
          ghb(10)
        ]),
      ),
    );
  }

  Widget cellTitle(String title) {
    return sbRow([
      centRow([
        Container(
          width: 3.w,
          height: 15.w,
          decoration: BoxDecoration(
              color: AppColor.theme,
              borderRadius: BorderRadius.circular(1.5.w)),
        ),
        gwb(10),
        getSimpleText(title, 15, AppColor.text, isBold: true),
      ])
    ], width: 345 - 15 * 2);
  }
}
