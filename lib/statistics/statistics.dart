import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/statistics/deal_statistics.dart';
import 'package:cxhighversion2/statistics/earn_statistics.dart';
import 'package:cxhighversion2/statistics/integral_statistics.dart';
import 'package:cxhighversion2/statistics/machineManage/statistics_machine_maintain.dart';
import 'package:cxhighversion2/statistics/machineManage/statistics_machine_manage.dart';
import 'package:cxhighversion2/statistics/machineManage/statistics_machine_replenishment.dart';
import 'package:cxhighversion2/statistics/machine_statistics.dart';
import 'package:cxhighversion2/statistics/userManage/statistics_user_manage.dart';
import 'package:cxhighversion2/util/EventBus.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:cxhighversion2/util/notify_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'machineEquities/statistics_machine_equities.dart';
import 'machineManage/statistics_machine_popularize.dart';

class StatisticsController extends GetxController {
  Map homeTeamTanNo = {};
  Map homeData = {};
  @override
  void onInit() {
    dataFormat();
    bus.on(HOME_DATA_UPDATE_NOTIFY, homeDataNotify);
    super.onInit();
  }

  homeDataNotify(arg) {
    dataFormat();
  }

  dataFormat() {
    homeData = AppDefault().homeData;
    homeTeamTanNo = homeData["homeTeamTanNo"] ?? {};
    update();
  }

  @override
  void onClose() {
    bus.off(HOME_DATA_UPDATE_NOTIFY, homeDataNotify);
    super.onClose();
  }
}

class Statistics extends GetView<StatisticsController> {
  const Statistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getDefaultAppBar(context, "统计",
          centerTitle: false, color: Colors.transparent, needBack: false),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              ghb(10),
              gwb(375),
              Container(
                width: 345.w,
                height: 144.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(assetsName("statistics/bg_top"))),
                ),
                child: GetBuilder<StatisticsController>(
                  builder: (_) {
                    return centRow([
                      topTjView(0),
                      gline(1, 90, color: Colors.white.withOpacity(0.1)),
                      topTjView(1),
                    ]);
                  },
                ),
              ),
              ghb(15),
              teamDataView(),
              ghb(15),
              dataManagerView(),
              ghb(15),
              personManagerView(),
              ghb(15),
              machineManagerView(),
              ghb(20)
            ],
          )),
    );
  }

  Widget topTjView(int index) {
    return SizedBox(
      width: (345 - 6.5 * 2).w / 2 - 1.1.w,
      height: 144.w,
      child: Row(
        children: [
          gwb(19.5),
          GetBuilder<StatisticsController>(builder: (_) {
            return centClm([
              centRow([
                Image.asset(
                  assetsName("statistics/icon_${index == 0 ? "sy" : "jy"}"),
                  width: 19.w,
                  fit: BoxFit.fitWidth,
                ),
                gwb(4.5),
                getSimpleText(index == 0 ? "收益" : "交易", 16, Colors.white,
                    isBold: true),
              ]),
              ghb(30),
              getSimpleText(
                  "总${index == 0 ? "收益" : "交易额"}(元)", 12, Colors.white),
              ghb(6),
              getSimpleText(
                  priceFormat(index == 0
                      ? ((controller.homeData["homeBouns"] ??
                              {})["totalBouns"] ??
                          0)
                      : (controller.homeTeamTanNo["soleTotalNum"] ?? 0)),
                  18,
                  Colors.white,
                  isBold: true),
            ], crossAxisAlignment: CrossAxisAlignment.start);
          }),
        ],
      ),
    );
  }

  Widget teamDataView() {
    return Container(
      width: 345.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w), color: Colors.white),
      child: GetBuilder<StatisticsController>(builder: (_) {
        return Column(
          children: [
            cellTitle("团队数据"),
            ghb(10),
            centRow(List.generate(2, (index) {
              return SizedBox(
                  width: 345.w / 2 - 0.1.w,
                  child: Row(
                    children: [
                      gwb(25),
                      centClm([
                        getSimpleText(
                            index == 0 ? "激活设备总数" : "总交易笔数", 12, AppColor.text),
                        ghb(6),
                        getSimpleText(
                            "${index == 0 ? controller.homeTeamTanNo["teamTotalActTerminal"] ?? 0 : controller.homeTeamTanNo["teamTotalNum"] ?? 0}",
                            18,
                            AppColor.text,
                            isBold: true),
                      ], crossAxisAlignment: CrossAxisAlignment.start),
                    ],
                  ));
            })),
            ghb(10.5),
            gline(345, 0.5),
            centRow(List.generate(3, (index) {
              String num = "";

              switch (index) {
                case 0:
                  num =
                      "${controller.homeTeamTanNo["teamTotalAddUserL1"] ?? "0"}";
                  break;
                case 1:
                  num =
                      "${controller.homeTeamTanNo["teamTotalAddUserL2"] ?? "0"}";
                  break;
                case 2:
                  num =
                      "${controller.homeTeamTanNo["teamTotalAddUserL3"] ?? "0"}";
                  break;
                default:
              }

              return CustomButton(
                onPressed: () {
                  int idx = index;
                  if (index == 0) {
                    idx = 3;
                  } else if (index == 1) {
                    idx = 2;
                  } else if (index == 2) {
                    idx = 1;
                  }
                  push(const StatisticsUserManage(), null,
                      binding: StatisticsUserManageBinding(),
                      arguments: {"type": idx});
                },
                child: Container(
                  padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
                  width: 345.w / 3 - 1.1.w,
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              width: index == 0 ? 0 : 0.5.w,
                              color: AppColor.lineColor))),
                  child: Center(
                    child: centClm([
                      centRow([
                        getSimpleText(
                            index == 0
                                ? "商户"
                                : index == 1
                                    ? "合伙人"
                                    : "盘主",
                            12,
                            AppColor.text,
                            textHeight: 1.3),
                        gwb(3),
                        Image.asset(
                          assetsName("statistics/icon_arrow_right_gray"),
                          width: 12.w,
                          fit: BoxFit.fitWidth,
                        )
                      ]),
                      ghb(4),
                      getSimpleText(num, 14, AppColor.text, isBold: true)
                    ], crossAxisAlignment: CrossAxisAlignment.start),
                  ),
                ),
              );
            }))
          ],
        );
      }),
    );
  }

  Widget dataManagerView() {
    return Container(
      width: 345.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w), color: Colors.white),
      child: Column(
        children: [
          cellTitle("数据管理"),
          ghb(10),
          SizedBox(
            width: (345 - 5 * 2).w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                String img = "";
                String title = "";
                switch (index) {
                  case 0:
                    img = "icon_sbtj";
                    title = "设备统计";
                    break;
                  case 1:
                    img = "icon_sytj";
                    title = "收益统计";
                    break;
                  case 2:
                    img = "icon_jytj";
                    title = "交易统计";
                    break;
                  case 3:
                    img = "icon_jftj";
                    title = "积分统计";
                    break;
                }
                return statisBtn(
                  img,
                  title,
                  0,
                  onPressed: () {
                    if (index == 0) {
                      push(const MachineStatistics(), null,
                          binding: MachineStatisticsBinding());
                    } else if (index == 1) {
                      push(const EarnStatistics(), null,
                          binding: EarnStatisticsBinding());
                    } else if (index == 2) {
                      push(const DealStatistics(), null,
                          binding: DealStatisticsBinding());
                    } else if (index == 3) {
                      push(const IntegralStatistics(), null,
                          binding: IntegralStatisticsBinding());
                    }
                  },
                );
              }),
            ),
          ),
          ghb(15),
        ],
      ),
    );
  }

  Widget personManagerView() {
    return Container(
      width: 345.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w), color: Colors.white),
      child: Column(
        children: [
          cellTitle("人员管理"),
          ghb(10),
          SizedBox(
            width: (345 - 5 * 2).w,
            child: Wrap(
              // spacing: 28.9.w,
              children: List.generate(4, (index) {
                String img = "";
                String title = "";
                switch (index) {
                  case 0:
                    img = "icon_yhgl";
                    title = "用户管理";
                    break;
                  case 1:
                    img = "icon_shgl";
                    title = "商户管理";
                    break;
                  case 2:
                    img = "icon_hhrgl";
                    title = "合伙人管理";
                    break;
                  case 3:
                    img = "icon_pzgl";
                    title = "盘主管理";
                    break;
                }
                return statisBtn(
                  img,
                  title,
                  1,
                  onPressed: () {
                    int idx = index;
                    if (index == 3) {
                      idx = 1;
                    } else if (index == 1) {
                      idx = 3;
                    }

                    push(const StatisticsUserManage(), null,
                        binding: StatisticsUserManageBinding(),
                        arguments: {"type": idx});
                  },
                );
              }),
            ),
          ),
          ghb(15),
        ],
      ),
    );
  }

  Widget machineManagerView() {
    return Container(
      width: 345.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w), color: Colors.white),
      child: Column(
        children: [
          cellTitle("设备管理"),
          ghb(10),
          SizedBox(
            width: (345 - 5 * 2).w,
            child: Wrap(
              alignment: WrapAlignment.start,
              // spacing: 28.9.w,
              runSpacing: 16.w,
              children: List.generate(6, (index) {
                String img = "";
                String title = "";
                switch (index) {
                  case 0:
                    img = "icon_sbgl";
                    title = "设备管理";
                    break;
                  case 1:
                    img = "icon_wdjj";
                    title = "我的机具";
                    break;
                  case 2:
                    img = "icon_sbtg";
                    title = "设备推广";
                    break;
                  case 3:
                    img = "icon_wxgh";
                    title = "维修更换";
                    break;
                  case 4:
                    img = "icon_xhgl";
                    title = "续货管理";
                    break;
                  case 5:
                    img = "icon_xysb";
                    title = "权益设备";
                    break;
                }
                return statisBtn(
                  img,
                  title,
                  1,
                  onPressed: () {
                    if (index == 0) {
                      push(const StatisticsMachineManage(), null,
                          binding: StatisticsMachineManageBinding(),
                          arguments: {"type": 0});
                    } else if (index == 1) {
                      push(const StatisticsMachineManage(), null,
                          binding: StatisticsMachineManageBinding(),
                          arguments: {"type": 1});
                    } else if (index == 2) {
                      push(
                        const StatisticsMachinePopularize(),
                        null,
                        binding: StatisticsMachinePopularizeBinding(),
                      );
                    } else if (index == 3) {
                      push(
                        const StatisticsMachineMaintain(),
                        null,
                        binding: StatisticsMachineMaintainBinding(),
                      );
                    } else if (index == 4) {
                      push(const StatisticsMachineReplenishment(), null,
                          binding: StatisticsMachineReplenishmentBinding());
                    } else if (index == 5) {
                      push(const StatisticsMachineEquities(), null,
                          binding: StatisticsMachineEquitiesBinding());
                    }
                  },
                );
              }),
            ),
          ),
          ghb(15),
        ],
      ),
    );
  }

  Widget cellTitle(String title) {
    return sbhRow(
      [
        centRow([
          Container(
            width: 3.w,
            height: 15.w,
            decoration: BoxDecoration(
                color: AppColor.theme,
                borderRadius: BorderRadius.circular(1.25.w)),
          ),
          gwb(8),
          getSimpleText(title, 15, AppColor.text, isBold: true),
        ])
      ],
      width: 345 - 15.5 * 2,
      height: 45.5.w,
    );
  }

  Widget statisBtn(String img, String title, int type,
      {required Function()? onPressed}) {
    return CustomButton(
      onPressed: onPressed,
      child: SizedBox(
        width: (345 - 5 * 2).w / 4 - 0.1.w,
        child: Center(
          child: centClm([
            Image.asset(
              assetsName("statistics/$img"),
              width: type == 0 ? 30.w : 45.w,
              height: type == 0 ? 30.w : 45.w,
              fit: BoxFit.fill,
            ),
            ghb(type == 0 ? 4 : 5),
            getSimpleText(title, 12, AppColor.text2),
          ]),
        ),
      ),
    );
  }
}
