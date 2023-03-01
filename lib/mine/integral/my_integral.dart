import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/home/integralRepurchase/integral_repurchase.dart';
import 'package:cxhighversion2/mine/integral/my_integral_history.dart';
import 'package:cxhighversion2/statistics/integral_statistics.dart';
import 'package:cxhighversion2/util/EventBus.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:cxhighversion2/util/notify_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyIntegralBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<MyIntegralController>(MyIntegralController(datas: Get.arguments));
  }
}

class MyIntegralController extends GetxController {
  final dynamic datas;
  MyIntegralController({this.datas});

  String infoContent = '''
一、积分获取与计算
1、立刷电签、嘉联云电签、盛店宝电签、钱宝电签、融享付电签、融享付大机用户刷卡交易10000元返800积分（扫码交易没有积分）；扫码交易不计算积分；100积分等价于1元人民币。

2、积分可以累计。

3、积分的数值精确到个位（小数点后全部舍弃，不进行四舍五入）。

4、注册pos机的资料要和注册联聚拓客平台用户的资料要一致，否则不能获取对应的交易积分

二、积分有效期
1、用户连续100天没有刷卡交易，积分自动过期。

2、过期的积分不能再进行使用。

三、积分使用 
1、积分不可转让，积分仅限于在联聚拓客平台以及联聚拓客平台合作方使用。

2、积分兑换商品：用户积分仅限于在联聚拓客平台商城内兑换商品。

3、积分兑换现金：用户积分兑换现金，平台以5折回收（比如1000积分等价于10元人民币，那么1000积分可以兑换5元人民币），用户1000积分起兑换。

四、免责条款
1、联聚拓客有权在未向您通知的情况下自行变更、终止全部或部分积分规则,无须为积分规则的变更或终止承担任何责任。您对联聚拓客平台的继续使用,视为您对积分规则变更和终止的接受。''';

  double jfNum = 0.0;
  Map homeData = {};
  dataFormat() {
    homeData = AppDefault().homeData;
    jfNum = 0.0;
    List accounts = homeData["u_Account"] ?? [];
    for (var e in accounts) {
      if (e["a_No"] >= 4) {
        jfNum += (e["amout"] ?? 0);
      }
    }
    update();
  }

  homeDataNotify(arg) {
    dataFormat();
  }

  @override
  void onInit() {
    dataFormat();
    bus.on(HOME_DATA_UPDATE_NOTIFY, homeDataNotify);
    super.onInit();
  }

  @override
  void onClose() {
    bus.off(HOME_DATA_UPDATE_NOTIFY, homeDataNotify);
    super.onClose();
  }
}

class MyIntegral extends GetView<MyIntegralController> {
  const MyIntegral({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getDefaultAppBar(context, "我的积分", action: [
        CustomButton(
            onPressed: () {
              push(const MyIntegralHistory(), context,
                  binding: MyIntegralHistoryBinding());
            },
            child: SizedBox(
              width: 80.w,
              height: kToolbarHeight,
              child: Center(child: getSimpleText("积分明细", 14, AppColor.text2)),
            )),
      ]),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: 375.w,
                height: 246.w,
                color: Colors.white,
                child: Column(
                  children: [
                    ClipPath(
                      clipper: MyClippper(arc: 45.w),
                      child: Container(
                        width: 375.w,
                        height: 175.w,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                alignment: Alignment.topCenter,
                                fit: BoxFit.fitWidth,
                                image:
                                    AssetImage(assetsName("mine/jf/bg_top")))),
                        child: Column(
                          children: [
                            ghb(35),
                            sbRow([
                              Padding(
                                padding: EdgeInsets.only(left: 15.w),
                                child: centClm([
                                  GetBuilder<MyIntegralController>(
                                    builder: (_) {
                                      return getSimpleText(
                                          priceFormat(controller.jfNum,
                                              savePoint: 0),
                                          35,
                                          Colors.white,
                                          isBold: true);
                                    },
                                  ),
                                  getSimpleText("当前可用积分", 14,
                                      Colors.white.withOpacity(0.5))
                                ],
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start),
                              ),
                              CustomButton(
                                onPressed: () {
                                  push(const IntegralStatistics(), null,
                                      binding: IntegralStatisticsBinding());
                                },
                                child: Container(
                                  width: 90.w,
                                  height: 30.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.w),
                                      color: Colors.black.withOpacity(0.1)),
                                  child: Row(
                                    children: [
                                      gwb(8),
                                      Image.asset(
                                        assetsName("mine/jf/icon_jf_tj"),
                                        width: 18.w,
                                        fit: BoxFit.fitWidth,
                                      ),
                                      gwb(2),
                                      getSimpleText("积分统计", 12, Colors.white)
                                    ],
                                  ),
                                ),
                              )
                            ], width: 375 - 15 * 2)
                          ],
                        ),
                      ),
                    ),
                    sbRow(
                        List.generate(4, (index) {
                          String img = "mine/jf/btn_";
                          String title = "";
                          switch (index) {
                            case 0:
                              img += "sc";
                              title = "积分商城";
                              break;
                            case 1:
                              img += "fg";
                              title = "积分复购";
                              break;
                            case 2:
                              img += "tx";
                              title = "积分兑现";
                              break;
                            case 3:
                              img += "sm";
                              title = "积分说明";
                              break;
                          }

                          return CustomButton(
                            onPressed: () {
                              if (index == 0) {
                              } else if (index == 1) {
                                push(const IntegralRepurchase(), context,
                                    binding: IntegralRepurchaseBinding());
                              } else if (index == 2) {
                                push(const IntegralRepurchase(), context,
                                    binding: IntegralRepurchaseBinding(),
                                    arguments: {"isRepurchase": false});
                              } else if (index == 3) {
                                pushInfoContent(
                                    title: "积分规则说明",
                                    content: controller.infoContent);
                              }
                            },
                            child: centClm([
                              Image.asset(
                                assetsName(img),
                                height: 30.w,
                                fit: BoxFit.fitHeight,
                              ),
                              ghb(5),
                              getSimpleText(title, 12, AppColor.text2)
                            ]),
                          );
                        }),
                        width: 375 - 30 * 2)
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class MyClippper extends CustomClipper<Path> {
  final double arc;
  MyClippper({required this.arc});
  Path path = Path();

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height - arc);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - arc);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
