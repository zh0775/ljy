import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class FinanceSpaceMineController extends GetxController {
  final dynamic datas;
  FinanceSpaceMineController({this.datas});

  List cardOrderStatus = [
    {
      "id": 0,
      "name": "待确认",
      "num": 12,
    },
    {
      "id": 1,
      "name": "待再查",
      "num": 3,
    },
    {
      "id": 2,
      "name": "待激活",
      "num": 2,
    },
    {
      "id": 3,
      "name": "已完成",
      "num": 6,
    },
    {
      "id": 4,
      "name": "未通过",
      "num": 1,
    }
  ];

  List loansOrderStatus = [
    {
      "id": 0,
      "name": "待确认",
      "num": 12,
    },
    {
      "id": 1,
      "name": "已完成",
      "num": 3,
    },
    {
      "id": 2,
      "name": "未通过",
      "num": 2,
    },
  ];

  List timeFilterList = [
    {"id": 0, "name": "全部"},
    {"id": 1, "name": "近7日"},
    {"id": 2, "name": "近15日"},
    {"id": 3, "name": "近30日"},
  ];

  final _openTimeFilte = false.obs;
  bool get openTimeFilte => _openTimeFilte.value;
  set openTimeFilte(v) => _openTimeFilte.value = v;
  final _timeFilterIdx = 0.obs;
  int get timeFilterIdx => _timeFilterIdx.value;
  set timeFilterIdx(v) {
    if (_timeFilterIdx.value != v) {
      _timeFilterIdx.value = v;
      loadData();
    }
  }

  loadData() {
    update();
  }
}

class FinanceSpaceMine extends StatelessWidget {
  const FinanceSpaceMine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getDefaultAppBar(context, "金融区"),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ghb(15),
            gwb(375),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.w),
              child: Container(
                width: 345.w,
                height: 129.w,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Color(0xFF6B96FD),
                    Color(0xFF366EFD),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
                child: Stack(children: [
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset(
                        assetsName("business/finance/icon_sy"),
                        width: 81.5.w,
                        fit: BoxFit.fitWidth,
                      )),
                  Positioned.fill(
                      top: 23.w,
                      left: 23.w,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: sbClm([
                          centClm([
                            getSimpleText("推广收益(元)", 14, Colors.white),
                            ghb(5),
                            getSimpleText("465.20", 30, Colors.white,
                                isBold: true),
                          ], crossAxisAlignment: CrossAxisAlignment.start),
                          centRow([
                            getSimpleText(
                                "已结算(元)", 12, Colors.white.withOpacity(0.7)),
                            gwb(4),
                            getSimpleText(
                                "342.00", 14, Colors.white.withOpacity(0.7)),
                            gwb(28),
                            getSimpleText(
                                "待结算(元)", 12, Colors.white.withOpacity(0.7)),
                            gwb(4),
                            getSimpleText(
                                "0.00", 14, Colors.white.withOpacity(0.7)),
                          ]),
                        ],
                            height: 91,
                            crossAxisAlignment: CrossAxisAlignment.start),
                      ))
                ]),
              ),
            ),
            ghb(15),
            cardOrderView(),
            ghb(15),
            loansOrderView(),
            ghb(15),
            teamEarnView(),
            ghb(20)
          ],
        ),
      ),
    );
  }

  Widget cardOrderView() {
    return Container(
      width: 345.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w), color: Colors.white),
      child: Column(
        children: [
          ghb(15),
          cellTitle("申卡订单"),
          ghb(12),
          GetBuilder<FinanceSpaceMineController>(
            init: FinanceSpaceMineController(),
            builder: (controller) {
              return sbRow(
                  List.generate(controller.cardOrderStatus.length, (index) {
                    Map e = controller.cardOrderStatus[index];
                    return CustomButton(
                      onPressed: () {},
                      child: SizedBox(
                        height: 60.w,
                        width: 345.w / controller.cardOrderStatus.length,
                        child: Center(
                          child: centClm([
                            getSimpleText("${e["num"] ?? 0}", 18, AppColor.text,
                                isBold: true),
                            ghb(8),
                            getSimpleText(e["name"] ?? "", 12, AppColor.text2)
                          ]),
                        ),
                      ),
                    );
                  }),
                  width: 345);
            },
          ),
          ghb(10),
        ],
      ),
    );
  }

  Widget teamEarnView() {
    return Container(
      width: 345.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w), color: Colors.white),
      child: Column(
        children: [
          // ghb(15),
          cellTitle(
            "团队推广业绩",
            rightWidget: DropdownButtonHideUnderline(
                child: GetX<FinanceSpaceMineController>(
              init: FinanceSpaceMineController(),
              builder: (controller) {
                return DropdownButton2(
                    offset: Offset(0.w, 10.w),
                    customButton: GetX<FinanceSpaceMineController>(
                      builder: (_) {
                        return SizedBox(
                          height: 50.w,
                          width: 80.w,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 55.w,
                              height: 18.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    9.w,
                                  ),
                                  border: Border.all(
                                      width: 0.5.w, color: AppColor.lineColor)),
                              child: Center(
                                child: centRow([
                                  gwb(3),
                                  getSimpleText(
                                      controller.timeFilterList[controller
                                              .timeFilterIdx]["name"] ??
                                          "",
                                      10,
                                      AppColor.text2),
                                  gwb(3),
                                  GetX<FinanceSpaceMineController>(
                                    builder: (_) {
                                      return AnimatedRotation(
                                        turns:
                                            controller.openTimeFilte ? 0.5 : 1,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        child: Image.asset(
                                          assetsName(
                                              "statistics/machine/icon_filter_down_selected_arrow"),
                                          width: 6.w,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      );
                                    },
                                  )
                                ]),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    items: List.generate(
                        controller.timeFilterList.length,
                        (index) => DropdownMenuItem<int>(
                            value: index,
                            child: centClm([
                              SizedBox(
                                height: (18 + 4 * 2).w,
                                child: Center(
                                  child: getSimpleText(
                                      controller.timeFilterList[index]["name"],
                                      12,
                                      controller.timeFilterIdx == index
                                          ? AppColor.blue
                                          : AppColor.textBlack),
                                ),
                              ),
                              index != controller.timeFilterList.length - 1
                                  ? gline(52, 0.5)
                                  : ghb(0)
                            ]))),
                    value: controller.timeFilterIdx,
                    // buttonWidth: 70.w,
                    buttonHeight: kToolbarHeight,
                    itemHeight: 30.w,
                    onChanged: (value) {
                      controller.timeFilterIdx = value;
                    },
                    onMenuStateChange: (isOpen) {
                      controller.openTimeFilte = isOpen;
                    },
                    itemPadding: EdgeInsets.zero,
                    dropdownWidth: 80.w,
                    dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.w),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0x26333333),
                              offset: Offset(0, 5.w),
                              blurRadius: 15.w)
                        ]));
              },
            )),
          ),
          ...List.generate(2, (index) {
            return sbhRow([
              centClm([
                getWidthText(index == 0 ? "我的推广(人)" : "累计团队核卡(张)", 12,
                    AppColor.text2, 345 / 2 - 0.5, 1,
                    alignment: Alignment.center),
                ghb(12),
                getSimpleText(index == 0 ? "724" : "106", 24, AppColor.text2,
                    isBold: true),
              ]),
              gline(1, 40),
              centClm([
                getWidthText(index == 0 ? "团队推广(人)" : "累计团队业绩(元)", 12,
                    AppColor.text2, 345 / 2 - 0.5, 1,
                    alignment: Alignment.center),
                ghb(12),
                getSimpleText(
                    index == 0 ? "698" : "6429.00", 24, AppColor.text2,
                    isBold: true),
              ]),
            ], width: 345, height: 88.5);
          }),
          ghb(20),
        ],
      ),
    );
  }

  Widget loansOrderView() {
    return Container(
      width: 345.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w), color: Colors.white),
      child: Column(
        children: [
          ghb(15),
          cellTitle("贷款订单"),
          ghb(12),
          GetBuilder<FinanceSpaceMineController>(
            init: FinanceSpaceMineController(),
            builder: (controller) {
              return sbRow(
                  List.generate(controller.loansOrderStatus.length, (index) {
                    Map e = controller.cardOrderStatus[index];
                    return CustomButton(
                      onPressed: () {},
                      child: SizedBox(
                        height: 60.w,
                        width: 300.w / controller.loansOrderStatus.length,
                        child: centClm([
                          getSimpleText("${e["num"] ?? 0}", 18, AppColor.text,
                              isBold: true),
                          ghb(8),
                          getSimpleText(e["name"] ?? "", 12, AppColor.text2)
                        ]),
                      ),
                    );
                  }),
                  width: 345);
            },
          ),
          ghb(10),
        ],
      ),
    );
  }

  Widget cellTitle(
    String title, {
    Widget? rightWidget,
    Function()? onPressed,
  }) {
    return Center(
        child: sbRow([
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
      ]),
      rightWidget ??
          CustomButton(
            onPressed: onPressed,
            child: SizedBox(
              height: 15.w,
              child: Center(
                child: centRow([
                  nSimpleText("查看更多", 12,
                      color: AppColor.text3, textHeight: 1.2),
                  Image.asset(
                    assetsName("mine/icon_right_arrow"),
                    width: 12.w,
                    fit: BoxFit.fitWidth,
                  )
                ]),
              ),
            ),
          ),
    ], width: 345 - 15 * 2));
  }
}
