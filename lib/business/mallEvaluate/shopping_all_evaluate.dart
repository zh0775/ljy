// 商品所有的评价列表

import 'package:flutter/material.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/component/custom_network_image.dart';
import 'package:cxhighversion2/component/custom_empty_view.dart';
import 'package:cxhighversion2/service/urls.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ShoppingAllEvaluateBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ShoppingAllEvaluateController>(ShoppingAllEvaluateController(shopIds: Get.arguments));
  }
}

class ShoppingAllEvaluateController extends GetxController {
  final dynamic shopIds;
  ShoppingAllEvaluateController({this.shopIds});

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(v) => _isLoading.value = v;

  List shopAllEvaluateList = [
    {
      "id": 1,
      "orderNo": "201545130123056460",
      "orderStatusList": [1],
      "title": "自动伞十二骨全自动雨 伞抗风防晒黑胶伞",
      "orderType": 1,
      "orderTypeText": "已完成",
      "selectTypeList": [1],
      "selectTypeTextList": ["商务蓝"],
      "integralNum": 540,
      "integralTotal": 1080,
      "num": 2,
      "logisticsId": 1,
      "porductImgUrl": "https://t7.baidu.com/it/u=852388090,130270862&fm=193&f=GIF"
    },
    {
      "id": 2,
      "orderNo": "201545130123056469",
      "orderStatusList": [1],
      "title": "1自动伞十二骨全自动雨 伞抗风防晒黑胶伞",
      "orderType": 1,
      "orderTypeText": "已完成",
      "selectTypeList": [1],
      "selectTypeTextList": ["商务蓝"],
      "integralNum": 540,
      "integralTotal": 540,
      "num": 1,
      "logisticsId": 1,
      "porductImgUrl": "https://t7.baidu.com/it/u=852388090,130270862&fm=193&f=GIF"
    }
  ];

  // 获取商品全部评价
  int pageSize = 10;
  int pageNo = 1;
  int count = 0;

  loadList({bool isLoad = false}) {
    isLoad ? pageNo++ : pageNo = 1;
    if (shopAllEvaluateList.isEmpty) {
      isLoading = true;
    }

    Map<String, dynamic> params = {
      "pageSize": pageSize,
      "pageNo": pageNo,
      "isBoutique": 1,
      "shop_Type": 2,
    };
    simpleRequest(
      url: Urls.userProductList,
      params: params,
      success: (success, json) {
        if (success) {
          Map data = json["data"] ?? {};
          shopAllEvaluateList = data["data"] ?? [];
          update();
        }
      },
      after: () {},
    );
  }

  //

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}

class ShoppingAllEvaluatePage extends GetView<ShoppingAllEvaluateController> {
  const ShoppingAllEvaluatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getDefaultAppBar(context, '商品评价'),
        body: SingleChildScrollView(
          child: shopAllEvaluate(),
        ));
  }

  // 商品全部评价列表

  Widget shopAllEvaluate() {
    return GetBuilder<ShoppingAllEvaluateController>(
      initState: (_) {},
      builder: (_) {
        return Container(
          child: Column(
            children: List.generate(controller.shopAllEvaluateList.length, (index) {
              Map data = controller.shopAllEvaluateList[index];
              return myEvaluateItem(data);
            }),
          ),
        );
      },
    );
  }

  Widget myEvaluateItem(Map data) {
    return Container(
      width: 375.w,
      color: Colors.white,
      padding: EdgeInsets.all(15.w),
      margin: EdgeInsets.only(top: 15.w),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.w),
                child: Image.network(
                  "https://cdn.pixabay.com/photo/2014/11/30/14/11/cat-551554_1280.jpg",
                  width: 30.w,
                  height: 30.w,
                ),
              ),
              gwb(6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getSimpleText('喵喵爱吃鱼', 15, const Color(0xFF333333)),
                        getSimpleText("2022-11-18", 12, const Color(0xFF333333)),
                      ],
                    ),
                    Container(
                      child: startRating(currentStart: 3),
                    )
                  ],
                ),
              ),
            ],
          ),
          ghb(13),
          SizedBox(
            child: Text(
              "宝贝收到1了，我超喜欢，做工质地都好得没话说，服 务态度也超好， 很有心的店家，以后常光顾！",
              style: TextStyle(
                fontSize: 15.w,
                color: const Color(0xFF333333),
              ),
            ),
          ),
          ghb(8),
          GestureDetector(
            onTap: () {
              print('test');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(
                  'https://cdn.pixabay.com/photo/2014/11/30/14/11/cat-551554_1280.jpg',
                  width: 100.w,
                  height: 100.w,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          ghb(20),
        ],
      ),
    );
  }

  Widget startRating({int currentStart = 0}) {
    return Row(
        children: List.generate(5, (index) {
      return Icon(
        index < currentStart ? Icons.star : Icons.star_border,
        size: 11.w,
        color: const Color(0xFFFEB501),
      );
    }));
  }
}
