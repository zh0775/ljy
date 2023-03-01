import 'dart:async';
import 'dart:typed_data';

import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/component/custom_network_image.dart';
import 'package:cxhighversion2/home/home.dart';
import 'package:cxhighversion2/home/redpacket/redpacket_history.dart';
import 'package:cxhighversion2/service/urls.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:cxhighversion2/util/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:screenshot/screenshot.dart';

class RedPacketBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<RedPacketController>(RedPacketController());
  }
}

class RedPacketController extends GetxController {
  RefreshController pullCtrl = RefreshController();
  ScreenshotController screenshotCtrl = ScreenshotController();

  PageController? topScrollPageCtrl;
  Timer? timer;

  Map packData = {};
  List drawList = [];
  List upData = [];
  Uint8List? toDayNotReceiveImg;

  final _btnEnable = true.obs;
  bool get btnEnable => _btnEnable.value;
  set btnEnable(v) => _btnEnable.value = v;

  drawMoneyAction() {
    btnEnable = false;
    simpleRequest(
      url: Urls.userReceiveHongbao,
      params: {},
      success: (success, json) {
        if (success) {
          if (json["messages"] != null && json["messages"].isNotEmpty) {
            ShowToast.normal(json["messages"] ?? "");
          }
          Get.find<HomeController>().refreshHomeData();
          loadRedPacketData();
        }
      },
      after: () {
        btnEnable = true;
      },
    );
  }

  onRefresh() {
    loadRedPacketData();
  }

  loadRedPacketData() {
    simpleRequest(
      url: Urls.userInvestOrder,
      params: {},
      success: (success, json) async {
        if (success) {
          Map data = json["data"] ?? {};
          packData = data;
          upData = packData["upData"] ?? [];
          drawList = packData["top10"] ?? [];
          drawList = packData["top10"] ?? [];
          // drawList = [
          //   ...drawList,
          //   ...drawList,
          //   ...drawList,
          //   ...drawList,
          //   ...drawList
          // ];
          // toDayNotReceiveImg = await loadShotImage();
          if (upData != null && upData.isNotEmpty) {
            if (timer != null) {
              timer?.cancel();
              timer = null;
            }
            timer = Timer.periodic(const Duration(seconds: 5), (timer) {
              if (topScrollPageCtrl != null &&
                  topScrollPageCtrl!.page != null) {
                topScrollPageCtrl!.animateToPage(
                    topScrollPageCtrl!.page!.toInt() - 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear);
              }
            });
          }
          update();
          pullCtrl.refreshCompleted();
        } else {
          pullCtrl.refreshFailed();
        }
      },
      after: () {},
    );
  }

  // Future<Uint8List> loadShotImage() async {
  //   return screenshotCtrl.captureFromWidget(toDayNotReceiveShot(),
  //       delay: const Duration(milliseconds: 10));
  // }

  @override
  void onInit() {
    topScrollPageCtrl = PageController(initialPage: 1000);
    loadRedPacketData();
    super.onInit();
  }

  @override
  void onClose() {
    topScrollPageCtrl?.dispose();
    timer?.cancel();
    timer = null;
    pullCtrl.dispose();
    super.onClose();
  }
}

class RedPacket extends GetView<RedPacketController> {
  const RedPacket({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: getDefaultAppBar(context, "奖励金"),
      body: SmartRefresher(
        controller: controller.pullCtrl,
        onRefresh: controller.onRefresh,
        header: WaterDropHeader(
          waterDropColor: Colors.white,
          complete: getSimpleText("刷新成功", 14, Colors.white),
          failed: getSimpleText("获取失败", 14, Colors.white),
          idleIcon: Icon(Icons.autorenew, size: 15.w, color: AppColor.textGrey),
          refresh: const CupertinoActivityIndicator(
            color: Colors.white,
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 457.w,
                width: 375.w,
                child: Stack(
                  children: [
                    Positioned(
                        width: 375.w,
                        height: 30.w,
                        child: Container(
                          color: Colors.white,
                        )),
                    Positioned.fill(
                        child: Image.asset(
                      assetsName("home/redpacket/bg_top"),
                      width: 375.w,
                      height: 457.w,
                      fit: BoxFit.fill,
                    )),
                    Positioned(
                        left: 0,
                        right: 0,
                        top: 26.w,
                        height: 46.w,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: GetBuilder<RedPacketController>(
                                init: controller,
                                builder: (_) {
                                  return PageView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: controller.topScrollPageCtrl,
                                    scrollDirection: Axis.vertical,
                                    itemCount: 1000,
                                    itemBuilder: (context, index) {
                                      int i = -1;
                                      Map upData = {};
                                      if (controller.upData != null &&
                                          controller.upData.isNotEmpty) {
                                        i = index % controller.upData.length;
                                        if (controller.upData.length >= i + 1) {
                                          upData = controller.upData[i];
                                        }
                                      }

                                      return SizedBox(
                                        width: 375.w,
                                        height: 46.w,
                                        child: Center(
                                          child: upData.isNotEmpty
                                              ? getSimpleText(
                                                  "${upData["u_Name"] ?? ""}已领取奖励金${priceFormat(upData["receiveAmount"] ?? 0)}元",
                                                  14,
                                                  const Color(0xFF9C2600))
                                              : gwb(0),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            )
                          ],
                        )),
                    Positioned(
                        top: 114.5.w,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: getSimpleText(
                              "今日可领取金额", 16, const Color(0xFFC81B00)),
                        )),
                    Positioned(
                        top: 185.w,
                        left: 0,
                        right: 0,
                        child: Center(child: toDayNotReceiveShot())),
                    Positioned(
                        top: 288.w,
                        left: 0,
                        right: 0,
                        child: Center(child: GetBuilder<RedPacketController>(
                          builder: (_) {
                            return getSimpleText(
                              "剩余领取红包金额：${controller.packData["notReceive"] ?? ""}元",
                              15,
                              const Color(0xFF7D3F00),
                            );
                          },
                        ))),
                    Positioned(
                        top: 320.w,
                        right: 0,
                        left: 0,
                        child: Center(
                          child: CustomButton(
                            onPressed: () {},
                            child: SizedBox(
                              width: 245.w,
                              height: 54.w,
                              child: Stack(
                                children: [
                                  Positioned(
                                      child: GetBuilder<RedPacketController>(
                                    builder: (_) {
                                      return GetX<RedPacketController>(
                                        builder: (_) {
                                          return CustomButton(
                                            onPressed: controller.btnEnable
                                                ? () {
                                                    // if (controller.packData[
                                                    //             "toDayNotReceiveFlag"] !=
                                                    //         null &&
                                                    //     controller.packData[
                                                    //             "toDayNotReceiveFlag"] ==
                                                    //         1) {}
                                                    controller
                                                        .drawMoneyAction();
                                                  }
                                                : null,
                                            child: Image.asset(
                                              assetsName(
                                                  "home/redpacket/btn_${controller.packData["toDayNotReceiveFlag"] ?? 0}"),
                                              width: 245.w,
                                              height: 54.w,
                                              fit: BoxFit.fill,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  )),
                                  // Positioned(
                                  //     top: 6.w,
                                  //     left: 0,
                                  //     right: 0,
                                  //     child: Center(
                                  //       child: Image.asset(
                                  //         assetsName(
                                  //             "home/redpacket/btn_text_lq"),
                                  //         width: 111.w,
                                  //         height: 34.w,
                                  //         fit: BoxFit.fill,
                                  //       ),
                                  //     )),
                                ],
                              ),
                            ),
                          ),
                        )),
                    Positioned(
                        top: 400.w,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: sbRow([
                            oBtn("获取规则", () => showRule(context)),
                            oBtn(
                                "获取记录",
                                () => push(const RedPacketHistory(), context,
                                    binding: RedPacketHistoryBinding())),
                          ], width: 375 - 55 * 2),
                        ))
                  ],
                ),
              ),
              ghb(14),
              SizedBox(
                width: 355.w,
                height: 698.w,
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Image.asset(
                      assetsName("home/redpacket/bg_rank"),
                      width: 355.w,
                      height: 698.w,
                      fit: BoxFit.fill,
                    )),
                    Positioned(
                        top: 19.w,
                        left: 79.w,
                        right: 79.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              assetsName("home/redpacket/icon_title_left"),
                              width: 43.w,
                              height: 12.w,
                              fit: BoxFit.fill,
                            ),
                            getSimpleText("兑换排行榜", 18, const Color(0xFFD0240B)),
                            Image.asset(
                              assetsName("home/redpacket/icon_title_right"),
                              width: 43.w,
                              height: 12.w,
                              fit: BoxFit.fill,
                            ),
                          ],
                        )),
                    Positioned(
                        top: 52.w,
                        left: 50.w,
                        right: 50.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getSimpleText("排名", 14, const Color(0xFFD0240B)),
                            getSimpleText("姓名", 14, const Color(0xFFD0240B)),
                            getSimpleText("交易笔数", 14, const Color(0xFFD0240B)),
                          ],
                        )),
                    Positioned(
                        top: 86.w,
                        left: 45.w,
                        right: 45.w,
                        bottom: 40.w,
                        child: GetBuilder<RedPacketController>(
                          builder: (_) {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.drawList != null &&
                                      controller.drawList.isNotEmpty
                                  ? controller.drawList.length
                                  : 0,
                              itemBuilder: (context, index) {
                                return drawListCell(
                                    controller.drawList[index], index);
                              },
                            );
                          },
                        ))
                  ],
                ),
              ),
              ghb(30.w)
            ],
          ),
        ),
      ),
    );
  }

  void showRule(BuildContext context) {
    showGeneralDialog(
      context: Global.navigatorKey.currentContext!,
      barrierLabel: "",
      barrierDismissible: true,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          child: SizedBox(
            width: 336.w,
            height: 480.w,
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      assetsName("home/redpacket/rule_bg"),
                      width: 336.w,
                      height: 480.w,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                      top: 180.w,
                      left: 43.w,
                      right: 43.w,
                      bottom: 37.w,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            getWidthText(
                                controller.packData["invsetDesc"] ?? "暂无内容",
                                14,
                                AppColor.textBlack,
                                336 - 66 * 2,
                                1000)
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget toDayNotReceiveShot() {
    return centRow([
      shadowText(getSimpleText("￥", 35, null, isBold: true)),
      gwb(5),
      shadowText(GetBuilder<RedPacketController>(
        builder: (_) {
          return getSimpleText(
              "${controller.packData["toDayNotReceive"] ?? ""}", 55, null,
              isBold: true);
        },
      )),
      gwb(5),
      Container(
        width: 25.w,
        height: 25.w,
        margin: EdgeInsets.only(top: 13.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.5.w),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFA6729),
                Color(0xFFF12C0F),
              ],
            )),
        child: Center(
          child: getSimpleText("元", 15, Colors.white),
        ),
      )
    ]);
  }

  Widget shadowText(Widget t) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFA6729),
            Color(0xFFF12C0F),
          ],
        ).createShader(Offset.zero & bounds.size);
      },
      blendMode: BlendMode.srcATop,
      child: t,
    );

    // Container(
    //   foregroundDecoration: const BoxDecoration(
    //       backgroundBlendMode: BlendMode.lighten,
    //       gradient: LinearGradient(
    //         begin: Alignment.topCenter,
    //         end: Alignment.bottomCenter,
    //         colors: [
    //           Color(0xFFFA6729),
    //           Color(0xFFF12C0F),
    //         ],
    //       )),
    //   child: t,
    // );
  }

  Widget drawListCell(Map data, int index) {
    return Container(
        height: 56.5.w,
        width: (375 - 45 * 2).w,
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
                bottom: BorderSide(
                    width: 0.5.w, color: AppColor.pageBackgroundColor))),
        child: Row(
          children: [
            ghb(56.5),
            SizedBox(
              width: 39.w,
              height: 39.w,
              child: Center(
                  child: index < 3
                      ? Image.asset(
                          assetsName("home/redpacket/icon_index${index + 1}"),
                          width: index == 2 ? 27.w : 39.w,
                          height: index == 2 ? 27.w : 39.w,
                          fit: BoxFit.fill,
                        )
                      : getSimpleText(
                          index + 1 < 10 ? "0${index + 1}" : "${index + 1}",
                          14,
                          AppColor.textBlack)),
            ),
            gwb(32),
            ClipRRect(
              borderRadius: BorderRadius.circular(13.5.w),
              child: CustomNetworkImage(
                src: AppDefault().imageUrl + (data["u_Avatar"] ?? ""),
                width: 27.w,
                height: 27.w,
                fit: BoxFit.fill,
              ),
            ),
            gwb(10),
            getWidthText(data["u_Name"] ?? "", 14, AppColor.textBlack, 91, 1),
            getWidthText(
              "${data["receiveCount"] ?? 1}",
              14,
              AppColor.textBlack,
              66,
              1,
              textAlign: TextAlign.center,
              alignment: Alignment.center,
            )
          ],
        ));
  }
}

Widget oBtn(String title, Function() onPressed) {
  return CustomButton(
    onPressed: onPressed,
    child: Container(
      width: 117.w,
      height: 41.w,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(assetsName("home/redpacket/btn_small")),
              fit: BoxFit.fill)),
      child: Center(
        child: getSimpleText(title, 15, const Color(0xFF903109)),
      ),
    ),
  );
}
