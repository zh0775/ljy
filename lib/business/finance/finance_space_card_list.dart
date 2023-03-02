import 'package:cxhighversion2/business/finance/finance_space_card_apply.dart';
import 'package:cxhighversion2/business/finance/finance_space_card_pop.dart';
import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/component/custom_empty_view.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FinanceSpaceCardListBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<FinanceSpaceCardListController>(
        FinanceSpaceCardListController(datas: Get.arguments));
  }
}

class FinanceSpaceCardListController extends GetxController {
  final dynamic datas;
  FinanceSpaceCardListController({this.datas});

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(v) => _isLoading.value = v;

  int pageSize = 20;
  int pageNo = 1;
  int count = 0;
  List dataList = [];

  loadData({bool isLoad = false}) {
    isLoad ? pageNo++ : pageNo = 1;
    if (dataList.isEmpty) {
      isLoading = true;
    }
    count = 0;
    dataList = [
      {"id": 0, "name": "建行龙卡尊享白金信用卡", "xh": "初审+首刷+M4补贴", "jl": 68},
      {"id": 0, "name": "建行龙卡尊享白金信用卡", "xh": "初审+首刷+M4补贴", "jl": 68},
      {"id": 0, "name": "建行龙卡尊享白金信用卡", "xh": "初审+首刷+M4补贴", "jl": 68},
      {"id": 0, "name": "建行龙卡尊享白金信用卡", "xh": "初审+首刷+M4补贴", "jl": 68},
      {"id": 0, "name": "建行龙卡尊享白金信用卡", "xh": "初审+首刷+M4补贴", "jl": 68},
      {"id": 0, "name": "建行龙卡尊享白金信用卡", "xh": "初审+首刷+M4补贴", "jl": 68}
    ];
    update();
  }

  @override
  void onInit() {
    loadData();
    super.onInit();
  }
}

class FinanceSpaceCardList extends GetView<FinanceSpaceCardListController> {
  const FinanceSpaceCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getDefaultAppBar(context, "热门信用卡"),
      body: GetBuilder<FinanceSpaceCardListController>(
        builder: (_) {
          return EasyRefresh(
              onLoad: controller.count <= controller.dataList.length
                  ? null
                  : () => controller.loadData(isLoad: true),
              onRefresh: () => controller.loadData(),
              header: const CupertinoHeader(),
              footer: const CupertinoFooter(),
              noMoreLoad: controller.count >= controller.dataList.length,
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 20.w),
                itemCount: controller.dataList.isEmpty
                    ? 2
                    : controller.dataList.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Center(
                      child: sbhRow([
                        getSimpleText(
                            "*本页面相关信息仅供参考，不构成任务投资建议", 12, AppColor.text3),
                      ], width: 375 - 15 * 2, height: 36),
                    );
                  } else {
                    if (controller.dataList.isEmpty) {
                      return GetX<FinanceSpaceCardListController>(
                        builder: (_) {
                          return CustomEmptyView(
                            isLoading: controller.isLoading,
                          );
                        },
                      );
                    } else {
                      return cell(index - 1, controller.dataList[index - 1]);
                    }
                  }
                },
              ));
        },
      ),
    );
  }

  Widget cell(int index, Map data) {
    return Center(
      child: Container(
        width: 345.w,
        height: 159.w,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(index == 0 ? 8.w : 0),
                bottom: Radius.circular(
                    index >= controller.dataList.length - 1 ? 8.w : 0))),
        child: Column(
          children: [
            index != 0 ? gline(315, 1) : ghb(0),
            sbhRow([
              centRow([
                Image.asset(
                  assetsName("business/finance/card0"),
                  width: 126.w,
                  height: 78.5.w,
                  fit: BoxFit.fill,
                ),
                gwb(11),
                centClm([
                  getWidthText(data["name"] ?? "", 15, AppColor.text,
                      315 - 11 - 126 - 1, 2,
                      isBold: true),
                  ghb(5),
                  getWidthText(
                    data["xh"] ?? "",
                    12,
                    AppColor.text2,
                    315 - 11 - 126 - 1,
                    2,
                  ),
                  ghb(10),
                  Container(
                    height: 18.w,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                        color: AppColor.theme.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(2.w)),
                    child:
                        getSimpleText("奖励￥${data["jl"]}", 10, AppColor.theme),
                  )
                ], crossAxisAlignment: CrossAxisAlignment.start)
              ])
            ], width: 345 - 15 * 2, height: 110),
            sbRow([
              gwb(0),
              centRow(List.generate(3, (index) {
                return index == 1
                    ? gwb(10)
                    : CustomButton(
                        onPressed: () {
                          if (index == 0) {
                            push(const FinanceSpaceCardPop(), null,
                                binding: FinanceSpaceCardPopBinding(),
                                arguments: {
                                  "data": data,
                                });
                          } else {
                            push(const FinanceSpaceCardApply(), null,
                                binding: FinanceSpaceCardApplyBinding(),
                                arguments: {
                                  "data": data,
                                });
                          }
                        },
                        child: Container(
                          width: 80.w,
                          height: 30.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.w),
                              color: index == 0 ? AppColor.theme : Colors.white,
                              border: Border.all(
                                  color: index == 0
                                      ? Colors.transparent
                                      : AppColor.theme,
                                  width: index == 0 ? 0 : 1.w)),
                          child: getSimpleText(index == 0 ? "我要推广" : "申请办卡", 12,
                              index == 0 ? Colors.white : AppColor.theme),
                        ),
                      );
              }))
            ], width: 315),
          ],
        ),
      ),
    );
  }
}
