/// 积分商城 我的售后页面

import 'package:cxhighversion2/business/afterSale/refund_ progress_page.dart';
import 'package:cxhighversion2/service/urls.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/component/custom_network_image.dart';
import 'package:cxhighversion2/component/custom_empty_view.dart';

import 'package:cxhighversion2/business/mallOrder/mall_order_status.page.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MallOrderPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<MallOrderPageController>(
        MallOrderPageController(datas: Get.arguments));
  }
}

class MallOrderPageController extends GetxController {
  final dynamic datas;

  MallOrderPageController({this.datas});

  bool isFirst = true;
  bool topAnimation = false; // top动画

  late PageController pageCtrl;
  // RefreshController allPullCtrl = RefreshController(); // 全部
  // RefreshController processingPullCtrl = RefreshController(); // 处理中
  // RefreshController completedPullCtrl = RefreshController(); // 已完成
  // RefreshController cancelledPullCtrl = RefreshController(); // 已取消
  DateFormat dateFormat = DateFormat("yyyy/MM/dd HH:mm:ss");

  List<List> dataLists = [
    [],
    [],
    [],
    [],
  ];
  List<int> pageSizes = [
    20,
    20,
    20,
    20,
  ];
  List<int> pageNos = [
    1,
    1,
    1,
    1,
  ];
  List<int> counts = [
    0,
    0,
    0,
    0,
  ];

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(v) => _isLoading.value = v;

  final _topIndex = 0.obs;
  int get topIndex => _topIndex.value;
  set topIndex(v) {
    if (!topAnimation) {
      _topIndex.value = v;
      changePage(topIndex);
      loadList(status: topIndex);
    }
  }

  int mallAllCount = 0;
  int mallProcessingCount = 0;

  final _mallAllOrderData = Rx<List>([
    {
      "id": 1,
      "orderNo": "201545130123056460",
      "orderStatusList": [1],
      "orderStatusTextList": ["查看物流"],
      "title": "自动伞十二骨全自动雨 伞抗风防晒黑胶伞",
      "orderType": 1,
      "orderTypeText": "申请退款中",
      "selectTypeList": [1],
      "selectTypeTextList": ["商务蓝"],
      "integralNum": 540,
      "integralTotal": 1080,
      "num": 2,
      "logisticsId": 1,
      "porductImgUrl":
          "https://t7.baidu.com/it/u=852388090,130270862&fm=193&f=GIF"
    }
  ]);
  List get mallAllOrderList => _mallAllOrderData.value;
  set mallAllOrderList(v) => _mallAllOrderData.value = v;

  final _mallProcessingOrderData = Rx<List>([
    {
      "id": 1,
      "orderNo": "201545130123056466",
      "orderStatusList": [1],
      "orderStatusTextList": ["查看物流"],
      "title": "酒店枕芯五星级宾馆枕头仿羽布羽丝棉仿...",
      "orderType": 1,
      "orderTypeText": "退款成功",
      "selectTypeList": [1],
      "selectTypeTextList": ["商务蓝"],
      "integralNum": 1064,
      "integralTotal": 1064,
      "num": 1,
      "logisticsId": 1,
      "porductImgUrl":
          "https://t7.baidu.com/it/u=852388090,130270862&fm=193&f=GIF"
    }
  ]);
  List get mallProcessingOrderList => _mallProcessingOrderData.value;
  set mallProcessingOrderList(v) => _mallProcessingOrderData.value = v;

  loadList({bool isLoad = false, int? status}) {
    int myLoadIdx = status ?? topIndex;
    isLoad ? pageNos[myLoadIdx]++ : pageNos[myLoadIdx] = 1;
    if (dataLists[myLoadIdx].isEmpty) {
      isLoading = true;
    }

    simpleRequest(
      url: Urls.userOrderList,
      params: {},
      success: (success, json) {
        if (success) {}
      },
      after: () {
        isLoading = false;
      },
    );
  }

  // 切换top-tabber
  changePage(int index) {
    if (isFirst) {
      return;
    }

    topAnimation = true;
    pageCtrl
        .animateToPage(index,
            duration: const Duration(milliseconds: 300), curve: Curves.linear)
        .then((value) {
      topAnimation = false;
    });
  }

  @override
  void onInit() {
    pageCtrl = PageController(initialPage: datas["index"] ?? 0);
    topIndex = datas["index"] ?? 0;
    isFirst = false;
    super.onInit();
  }
}

class MallOrderPage extends GetView<MallOrderPageController> {
  const MallOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getDefaultAppBar(context, "我的订单"),
      body: Stack(
        children: [
          // topBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 51.w,
            child: topBar(),
          ),

          Positioned(
            top: 51.w,
            left: 0,
            right: 0,
            bottom: 0,
            child: mallOrderPageView(),
          )
        ],
      ),
    );
  }

  // topBar
  Widget topBar() {
    return Container(
      width: 375.w,
      height: 51.w,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: ["全部", "待发货", "待收货", "已完成"]
            .asMap()
            .entries
            .map(
              (item) => CustomButton(
                onPressed: () {
                  controller.topIndex = item.key;
                },
                child: Center(
                  child: GetX<MallOrderPageController>(
                    init: controller,
                    initState: (_) {},
                    builder: (_) {
                      return SizedBox(
                        width: (375 / 4).w,
                        height: 55.w,
                        child: centClm([
                          getSimpleText(
                            item.value,
                            15,
                            controller.topIndex != item.key
                                ? const Color(0xFFBCC0C9)
                                : const Color(0xFFFF6231),
                          ),
                          ghb(controller.topIndex == item.key ? 3 : 0),
                          controller.topIndex != item.key
                              ? ghb(0)
                              : Container(
                                  width: 30.w,
                                  height: 2.w,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFFF6231),
                                      borderRadius: BorderRadius.circular(2.w)),
                                )
                        ]),
                      );
                    },
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // 积分商城我的订单
  Widget mallOrderPageView() {
    return PageView(
      physics: const BouncingScrollPhysics(),
      controller: controller.pageCtrl,
      scrollDirection: Axis.horizontal,
      onPageChanged: (value) {
        controller.topIndex = value;
      },
      children: [
        // GetBuilder<MallOrderPageController>(
        //   init: controller,
        //   builder: (_) {
        //     return mallOrderList(controller.mallAllOrderList,
        //         controller.mallAllCount, 0, controller.allPullCtrl, () async {
        //       // controller.onRefresh(0);
        //     }, () async {
        //       // controller.onLoad(0);
        //     });
        //   },
        // ),
        // GetBuilder<MallOrderPageController>(
        //   init: controller,
        //   builder: (_) {
        //     return mallOrderList(
        //         controller.mallProcessingOrderList,
        //         controller.mallProcessingCount,
        //         0,
        //         controller.processingPullCtrl, () async {
        //       controller.onRefresh(0);
        //     }, () async {
        //       controller.onLoad(0);
        //     });
        //   },
        // ),
      ],
    );
  }

  // 积分商城我的订单列表
  Widget mallOrderList(
      List datas,
      int count,
      int listIndex,
      // RefreshController pullCtrl,
      Function()? onRefresh,
      Function()? onLoading) {
    return EasyRefresh(
      // controller: pullCtrl,
      onRefresh: onRefresh,
      onLoad: onLoading,
      // physics: const BouncingScrollPhysics(),
      // enablePullUp: datas.length < count ? true : false,
      child: datas.isEmpty
          ? GetX<MallOrderPageController>(
              init: controller,
              builder: (_) {
                return CustomEmptyView(
                  isLoading: controller.isLoading,
                );
              },
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                  bottom: 15.w +
                      paddingSizeBottom(Global.navigatorKey.currentContext!)),
              itemCount: datas.isEmpty ? 0 : datas.length,
              itemBuilder: (context, index) {
                return mallOrderItem(datas[index], index, context, listIndex);
              },
            ),
    );
  }

  //
  Widget mallOrderItem(
      Map data, int index, BuildContext context, int listIndex) {
    return Container(
      width: 375.w - 15.w * 2,
      margin: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.w)),
      padding: EdgeInsets.all(15.w),
      child: Column(
        children: [
          SizedBox(
            child: sbRow([
              getSimpleText(
                  "订单编号：${data['orderNo']}", 10, const Color(0xFF999999)),
              getSimpleText(
                  "${data['orderTypeText']}", 12, const Color(0xFFFF6231)),
            ], width: 345.w),
          ),
          ghb(14),
          GestureDetector(
            onTap: () {
              push(const MallOrderStatusPage(), null,
                  binding: MallOrderStatusPageBinding());
            },
            child: Container(
              width: 345.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(8.w),
              ),
              padding: EdgeInsets.fromLTRB(10.w, 7.5.w, 10.w, 7.5.w),
              child: sbRow([
                CustomNetworkImage(
                  src: "${data['porductImgUrl']}",
                  width: 60,
                  height: 60,
                  fit: BoxFit.fitWidth,
                ),
                gwb(11),
                SizedBox(
                  width: 345.w - 60.w - 30.w * 2 - 11.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getSimpleText(
                          "${data['title']}", 12, const Color(0xFF333333)),
                      getSimpleText("已选：${data['selectTypeTextList'][0]}；", 10,
                          const Color(0xFF999999)),
                      sbRow([
                        getSimpleText("${data['integralNum']}积分", 10,
                            const Color(0xFF333333)),
                        getSimpleText(
                            "x${data['num']}", 12, const Color(0xFF999999)),
                      ])
                    ],
                  ),
                ),
              ]),
            ),
          ),
          ghb(15.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              getSimpleText("总计：", 10.w, const Color(0xFF333333)),
              getSimpleText(
                  "${data['integralTotal']}积分", 12.w, const Color(0xFFFF6231)),
            ],
          ),
          ghb(13),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              borderButton('查看物流', const Color.fromARGB(255, 164, 151, 151),
                  data['logisticsId'], '1')
            ],
          )
        ],
      ),
    );
  }

  Widget borderButton(
    String buttonTitle,
    Color color,
    int id,
    String type,
  ) {
    return GestureDetector(
      onTap: () {
        print("button对应的事件");
        push(const RefundProgressPage(), null,
            binding: RefundProgressPageBinding());
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(8.5.w, 7.w, 8.5.w, 7.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.w),
            border: Border.all(
              color: color,
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.white,
                  offset: Offset.zero,
                  blurRadius: 2.w,
                  spreadRadius: 2.w,
                  blurStyle: BlurStyle.solid)
            ]),
        child: getSimpleText("${buttonTitle} ", 12.w, const Color(0xFF333333),
            textHeight: 1.1),
      ),
    );
  }
}
