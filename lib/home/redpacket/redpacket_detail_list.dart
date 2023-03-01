import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/component/custom_empty_view.dart';
import 'package:cxhighversion2/service/urls.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

class RedPacketDetaiListBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<RedPacketDetaiListController>(RedPacketDetaiListController());
  }
}

class RedPacketDetaiListController extends GetxController {
  FixedExtentScrollController? yearPickCtrl = FixedExtentScrollController();
  FixedExtentScrollController? monthPickCtrl = FixedExtentScrollController();
  String listBuildId = "listBuildId_";

  // RefreshController pullCtrl = RefreshController();
  List<RefreshController> pullCtrls = [
    RefreshController(),
    RefreshController()
  ];
  List<ScrollController> listCtrls = [ScrollController(), ScrollController()];
  List<ExpandableListController> expandCtrl = [
    ExpandableListController(),
    ExpandableListController()
  ];
  PageController listPageCtrl = PageController();

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(v) => _isLoading.value = v;
  bool topAnimation = false;
  final _topIndex = 0.obs;
  int get topIndex => _topIndex.value;
  set topIndex(v) {
    if (!topAnimation) {
      _topIndex.value = v;
      changePage(topIndex);
      loadDetails();
    }
  }

  changePage(int index) {
    topAnimation = true;
    listPageCtrl
        .animateToPage(index,
            duration: const Duration(milliseconds: 300), curve: Curves.linear)
        .then((value) {
      topAnimation = false;
    });
  }

  int currentMonth = 0;
  int currentYear = 0;

  final _scrollYearIndex = 0.obs;
  int get scrollYearIndex => _scrollYearIndex.value;
  set scrollYearIndex(v) => _scrollYearIndex.value = v;
  final _scrollMonthIndex = 0.obs;
  int get scrollMonthIndex => _scrollMonthIndex.value;
  set scrollMonthIndex(v) => _scrollMonthIndex.value = v;

  double appBarMaxHeight = 0;

  showPick(int year, int month) {
    scrollYearIndex = yearList.indexOf(year);
    scrollMonthIndex = monthList.indexOf(month);

    if (yearPickCtrl != null) {
      yearPickCtrl!.dispose();
    }
    if (monthPickCtrl != null) {
      monthPickCtrl!.dispose();
    }

    yearPickCtrl = FixedExtentScrollController(initialItem: scrollYearIndex);
    monthPickCtrl = FixedExtentScrollController(initialItem: scrollMonthIndex);
    // yearPickCtrl.animateToItem(scrollYearIndex,
    //     duration: Duration(milliseconds: 300), curve: Curves.linear);
    // monthPickCtrl.animateToItem(scrollMonthIndex,
    //     duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  List<List<RedPackDealSection>> listDatas = [
    <RedPackDealSection>[],
    <RedPackDealSection>[]
  ];
  List counts = [0, 0];
  List pageNos = [1, 1];
  int pageSize = 20;

  onLoad() {
    loadDetails(isLoad: true);
  }

  onRefresh() {
    loadDetails();
  }

  cancelPick() {}
  confirmPick() {
    currentMonth = monthList[scrollMonthIndex];
    currentYear = yearList[scrollYearIndex];
    loadDetails();
  }

  loadDetails({bool isLoad = false, int? year, int? month}) {
    isLoad ? pageNos[topIndex]++ : pageNos[topIndex] = 1;

    Map<String, dynamic> params = {
      "id": detailData["id"] ?? -1,
      "d_Type": topIndex,
      "pageSize": pageSize,
      "pageNo": pageNos[topIndex],
      "month": month ?? currentMonth,
      "year": year ?? currentYear
    };
    if (listDatas[topIndex].isEmpty) {
      isLoading = true;
    }
    simpleRequest(
      url: Urls.userHongbaoQueueList,
      params: params,
      success: (success, json) {
        if (success) {
          Map data = json["data"] ?? {};
          counts[topIndex] = data["count"] ?? 0;
          List<RedPackDealSection> l = listDatas[topIndex];
          if (isLoad) {
            listDatas[topIndex][0] = RedPackDealSection(
                amout: double.parse(data["totalAmount"] ?? 0.0),
                year: currentYear,
                month: currentMonth,
                dealList: [...l[0].getItems(), ...(data["data"] ?? [])]);
          } else {
            listDatas[topIndex][0] = RedPackDealSection(
                amout: double.parse(data["totalAmount"] ?? 0.0),
                year: currentYear,
                month: currentMonth,
                dealList: data["data"] ?? []);
          }
          update(["$listBuildId$topIndex"]);
          // isLoad ?
          // listDatas[topIndex] = []
        }
        if (isLoad) {
          success
              ? pullCtrls[topIndex].loadComplete()
              : pullCtrls[topIndex].loadFailed();
        } else {
          success
              ? pullCtrls[topIndex].refreshCompleted()
              : pullCtrls[topIndex].refreshFailed();
        }
      },
      after: () {
        isLoading = false;
      },
    );
  }

  DateFormat addTimeDateFormat = DateFormat("yyyy/MM/dd HH:mm:ss");

  bool isFirst = true;
  Map detailData = {};
  dataInit(Map data) {
    if (!isFirst) return;
    isFirst = false;
    detailData = data;
    DateTime now = DateTime.now();
    currentMonth = now.month;
    currentYear = now.year;
    for (var e in listDatas) {
      e.add(RedPackDealSection(
          amout: 0, year: currentYear, month: currentMonth, dealList: []));
    }

    loadDetails();
  }

  List yearList = [];
  List monthList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  @override
  void onInit() {
    for (var i = 0; i < 50; i++) {
      yearList.add(DateTime.now().year - i);
    }
    super.onInit();
  }

  @override
  void onClose() {
    yearPickCtrl?.dispose();
    monthPickCtrl?.dispose();
    // pullCtrl.dispose();
    for (var e in pullCtrls) {
      e.dispose();
    }
    for (var e in listCtrls) {
      e.dispose();
    }
    for (var e in expandCtrl) {
      e.dispose();
    }
    listPageCtrl.dispose();
    super.onClose();
  }
}

class RedPacketDetaiList extends GetView<RedPacketDetaiListController> {
  final Map detailData;
  const RedPacketDetaiList({super.key, this.detailData = const {}});

  @override
  Widget build(BuildContext context) {
    controller.dataInit(detailData);
    return Scaffold(
      appBar: getDefaultAppBar(context, "领取明细"),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 50.w,
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    topButton(0, "已领取"),
                    topButton(1, "未领取"),
                  ],
                ),
              )),
          Positioned(
              top: 50.w,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                child: GetBuilder<RedPacketDetaiListController>(builder: (_) {
                  return pageList(context);
                }),
              ))
        ],
      ),
    );
  }

  Widget pageList(BuildContext context) {
    return PageView(
      controller: controller.listPageCtrl,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      children: [
        list(0),
        list(1),
      ],
      onPageChanged: (value) {
        controller.topIndex = value;
      },
    );
  }

  Widget list(int listIndex) {
    // return

    // Builder(builder: (context) {
    //   double screenHeight = ScreenUtil().screenHeight;
    //   double appBarMaxHeight = (Scaffold.of(context).appBarMaxHeight ?? 0);
    return GetBuilder<RedPacketDetaiListController>(
      id: "${controller.listBuildId}$listIndex",
      builder: (_) {
        List<RedPackDealSection> listData = controller.listDatas[listIndex];
        int count = controller.counts[listIndex];
        List dealList = listData[0].dealList;
        return SmartRefresher(
          controller: controller.pullCtrls[listIndex],
          onRefresh: controller.onRefresh,
          onLoading: controller.onLoad,
          enablePullDown: true,
          enablePullUp: count > dealList.length,
          child: dealList.isEmpty
              ? Column(
                  children: [
                    sectionView(0, listData[0]),
                    GetX<RedPacketDetaiListController>(
                      builder: (_) => CustomEmptyView(
                        isLoading: controller.isLoading,
                      ),
                    )
                  ],
                )
              : ListView.builder(
                  itemCount: listData[0].dealList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return sectionView(0, listData[0]);
                    } else {
                      return rowView(index, dealList[index - 1]);
                    }
                  },
                ),

          // ExpandableListView(
          //   controller: controller.listCtrls[listIndex],
          //   physics: const BouncingScrollPhysics(),
          //   builder: SliverExpandableChildDelegate(
          //     controller: controller.expandCtrl[listIndex],
          //     sectionList: controller.listDatas[listIndex],
          //     headerBuilder: (context, sectionIndex, index) {
          //       return sectionView(sectionIndex, listData[sectionIndex]);
          //     },
          //     itemBuilder: (context, sectionIndex, itemIndex, index) {
          //       // return listData[0].dealList.isEmpty
          //       //     ? GetX<RedPacketDetaiListController>(
          //       //         builder: (_) {
          //       //           return CustomEmptyView(
          //       //             isLoading: controller.isLoading,
          //       //           );
          //       //         },
          //       //       )
          //       //     : rowView(
          //       //         itemIndex, listData[sectionIndex].dealList[itemIndex]);
          //       return rowView(
          //           itemIndex, listData[sectionIndex].dealList[itemIndex]);
          //     },
          //   ),
          // ),
        );
      },
    );
    // });
  }

  Widget sectionView(int itemIndex, RedPackDealSection data) {
    return Container(
      width: 375.w,
      height: 40.w,
      color: AppColor.pageBackgroundColor,
      child: Center(
        child: sbhRow([
          CustomButton(
              onPressed: () {
                controller.showPick(data.year, data.month);
                showBottomDatePick(data.year, data.month);
              },
              child: Center(
                  child: centRow([
                getSimpleText(
                    "${data.year}年${data.month}月", 14, AppColor.textBlack),
                gwb(2),
                Image.asset(
                  assetsName("common/drop_down"),
                  width: 8.w,
                  fit: BoxFit.fitWidth,
                )
              ]))),
          getSimpleText(
              "总计：￥${priceFormat(data.amout)}", 14, AppColor.textBlack),
        ], width: 375 - 20 * 2, height: 40),
      ),
    );
  }

  Widget rowView(int sectionIndex, Map data) {
    return Container(
      width: 375.w,
      height: 60.5.w,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(width: 0.5.w, color: AppColor.lineColor))),
      child: Center(
        child: sbhRow([
          getSimpleText(data["dsec"] ?? "", 13, AppColor.textGrey),
          getSimpleText(
              "${priceFormat(data["amount"] ?? 0)}元", 18, AppColor.textRed),
        ], width: 375 - 20 * 2, height: 60),
      ),
    );
  }

  Widget topButton(int index, String title) {
    return CustomButton(
      onPressed: () {
        controller.topIndex = index;
      },
      child: GetX<RedPacketDetaiListController>(
        builder: (_) {
          return SizedBox(
            width: (375 / 2 - 0.1).w,
            height: 50.w,
            child: Center(
              child: centClm([
                getSimpleText(
                    title,
                    15,
                    controller.topIndex == index
                        ? AppColor.textRed
                        : AppColor.textBlack,
                    isBold: controller.topIndex == index),
                ghb(controller.topIndex == index ? 3 : 0),
                controller.topIndex == index
                    ? Container(
                        width: 20.w,
                        height: 2.w,
                        color: AppColor.textRed,
                      )
                    : ghb(0)
              ]),
            ),
          );
        },
      ),
    );
  }

  showBottomDatePick(int year, int month) {
    Get.bottomSheet(
      Container(
        width: 375.w,
        height: 248.w,
        color: Colors.white,
        child: Column(
          children: [
            sbhRow([
              CustomButton(
                onPressed: () {
                  controller.cancelPick();
                  Get.back();
                },
                child: getSimpleText("取消", 16, AppColor.textGrey),
              ),
              CustomButton(
                onPressed: () {
                  controller.confirmPick();
                  Get.back();
                },
                child: getSimpleText("确定", 16, AppColor.textBlack),
              ),
            ], width: 375 - 16 * 2, height: 48),
            gline(375, 0.5),
            SizedBox(
                width: 375.w,
                height: (248 - 48 - 0.5).w,
                child: Center(
                  child: centRow([
                    pick(true),
                    pick(false),
                  ]),
                ))

            // CupertinoDatePicker(
            //   mode: CupertinoDatePickerMode.date,
            //   dateOrder: DatePickerDateOrder.ymd,
            //   initialDateTime: DateTime(year, month),
            //   onDateTimeChanged: (value) {},
            // ),
            // ),
          ],
        ),
      ),
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
    );
  }

  Widget pick(bool isYear) {
    return SizedBox(
      height: (248 - 48 - 0.5).w,
      width: 123.w,
      child: Center(
        child: CupertinoPicker.builder(
          // key: isYear ? controller.yearPickKey : controller.monthPickKey,
          childCount:
              isYear ? controller.yearList.length : controller.monthList.length,
          scrollController:
              isYear ? controller.yearPickCtrl : controller.monthPickCtrl,
          itemExtent: 40.w,
          onSelectedItemChanged: (value) {
            isYear
                ? controller.scrollYearIndex = value
                : controller.scrollMonthIndex = value;
          },
          itemBuilder: (context, index) {
            return SizedBox(
                width: 123.w,
                height: 40.w,
                child: GetX<RedPacketDetaiListController>(
                  autoRemove: false,
                  init: controller,
                  builder: (_) {
                    return Center(
                      child: getSimpleText(
                        isYear
                            ? "${controller.yearList[index]}年"
                            : "${controller.monthList[index]}月",
                        isYear
                            ? (controller.scrollYearIndex == index ? 16 : 15)
                            : (controller.scrollMonthIndex == index ? 16 : 15),
                        isYear
                            ? (controller.scrollYearIndex == index
                                ? AppColor.textBlack
                                : AppColor.textBlack)
                            : (controller.scrollMonthIndex == index
                                ? AppColor.textBlack
                                : AppColor.textBlack),
                      ),
                    );
                  },
                ));
          },
        ),
      ),
    );
  }
}

class RedPackDealSection extends ExpandableListSection {
  final List dealList;
  final double amout;
  final int year;
  final int month;
  RedPackDealSection(
      {required this.dealList,
      this.amout = 0.0,
      required this.year,
      required this.month});
  bool isExpanded = true;

  @override
  List getItems() {
    return dealList;
  }

  @override
  bool isSectionExpanded() {
    return isExpanded;
  }

  @override
  void setSectionExpanded(bool expanded) {
    isExpanded = expanded;
  }
}
