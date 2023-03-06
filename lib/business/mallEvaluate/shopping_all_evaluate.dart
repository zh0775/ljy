// 商品所有的评价列表

import 'package:cxhighversion2/component/custom_empty_view.dart';
import 'package:cxhighversion2/service/urls.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:easy_refresh/easy_refresh.dart';

import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ShoppingAllEvaluateBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ShoppingAllEvaluateController>(ShoppingAllEvaluateController(datas: Get.arguments));
  }
}

class ShoppingAllEvaluateController extends GetxController {
  final dynamic datas;
  ShoppingAllEvaluateController({this.datas});

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(v) => _isLoading.value = v;

  List shopAllEvaluateList = [];

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
      "productID": datas["data"]['productId'],
    };
    simpleRequest(
      url: Urls.userCommentList,
      params: params,
      success: (success, json) {
        if (success) {
          Map data = json["data"] ?? {};
          shopAllEvaluateList = data["data"] ?? [];
          count = data['count'];

          update();
        }
      },
      after: () {},
    );
  }

  List stringImgToArray(String strImg) {
    return strImg.split(',');
  }

  //

  @override
  void onInit() {
    loadList();
    super.onInit();
  }
}

class ShoppingAllEvaluatePage extends GetView<ShoppingAllEvaluateController> {
  const ShoppingAllEvaluatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getDefaultAppBar(context, '商品评价'),
        body: Stack(
          children: [
            Positioned(
                left: 0,
                width: 375.w,
                height: controller.shopAllEvaluateList.isEmpty ? 0 : 30.w,
                child: Container(
                  width: 375.w,
                  padding: EdgeInsets.only(left: 15.w),
                  height: 30.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '全部评论',
                        style: TextStyle(
                          fontSize: 15.w,
                          color: const Color(0xFF333333),
                          height: 2.3,
                        ),
                      ),
                      Text(
                        '（共${controller.count ?? 0}个）',
                        style: TextStyle(
                          fontSize: 15.w,
                          color: const Color(0xFF333333),
                          height: 2.3,
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned.fill(
              top: controller.shopAllEvaluateList.isEmpty ? 0 : 30.w,
              child: shopAllEvaluate(),
            ),
          ],
        ));
  }

  // 商品全部评价列表

  Widget shopAllEvaluate() {
    return GetBuilder<ShoppingAllEvaluateController>(
      initState: (_) {},
      builder: (_) {
        return EasyRefresh(
          header: const CupertinoHeader(),
          footer: const CupertinoFooter(),
          onLoad: controller.shopAllEvaluateList.length >= controller.count ? null : () => controller.loadList(isLoad: true),
          onRefresh: () => controller.loadList(),
          child: controller.shopAllEvaluateList.isEmpty
              ? SingleChildScrollView(
                  child: Center(
                    child: GetX<ShoppingAllEvaluateController>(
                      builder: (_) {
                        return CustomEmptyView(type: CustomEmptyType.carNoData, isLoading: controller.isLoading, bottomSpace: 200.w);
                      },
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: controller.shopAllEvaluateList.length,
                  itemBuilder: (context, index) {
                    print("${controller.shopAllEvaluateList[index]}");
                    return myEvaluateItem(controller.shopAllEvaluateList[index]);
                  },
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
                  AppDefault().imageUrl + data['u_Avatar'] ?? "https://cdn.pixabay.com/photo/2014/11/30/14/11/cat-551554_1280.jpg",
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
                        getSimpleText(data['u_Name'] ?? '匿名', 15, const Color(0xFF333333)),
                        getSimpleText(data['addTime'] ?? '', 12, const Color(0xFF333333)),
                      ],
                    ),
                    Container(
                      child: startRating(currentStart: (data['score'] ?? 1.0).floor()),
                    )
                  ],
                ),
              ),
            ],
          ),
          ghb(13),
          SizedBox(
            width: 345.w,
            child: Text(
              data['comment'] ?? '',
              style: TextStyle(
                fontSize: 15.w,
                color: const Color(0xFF333333),
              ),
            ),
          ),
          ghb(8),
          SizedBox(
            width: 345.w,
            child: Wrap(
              spacing: 15.w,
              runSpacing: 10.w,
              children: List.generate(controller.stringImgToArray(data['images'] ?? '').length, (index) {
                String imgsItem = controller.stringImgToArray(data['images'])[index];
                return GestureDetector(
                  onTap: () {
                    toCheckImg(image: "${AppDefault().imageUrl}${imgsItem}");
                  },
                  child: Image.network(
                    AppDefault().imageUrl + imgsItem,
                    width: 100.w,
                    height: 100.w,
                    fit: BoxFit.cover,
                  ),
                );
              }),
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
        index <= currentStart ? Icons.star : Icons.star_border,
        size: 11.w,
        color: const Color(0xFFFEB501),
      );
    }));
  }
}
