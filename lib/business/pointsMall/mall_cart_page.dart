import 'package:cxhighversion2/component/custom_network_image.dart';
import 'package:flutter/material.dart';

import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cxhighversion2/service/urls.dart';
import 'points_mall_page.dart';
import 'package:get/get.dart';

class MallCartPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<MallCartPageController>(MallCartPageController());
  }
}

class MallCartPageController extends GetxController {
  final dynamic datas;
  MallCartPageController({this.datas});
  List MallTypeList = [];

  final _currentIndex = 0.obs; // 默认第一个
  int get currentIndex => _currentIndex.value;
  set currentIndex(v) => _currentIndex.value = v;

  loadData({String? searchStr}) {
    simpleRequest(
        url: Urls.userShopAllClass,
        params: {},
        success: (success, json) {
          if (success) {
            // Map data = json["data"] ?? {};
            MallTypeList = json["data"] ?? [];
            update();
          }
        },
        after: () {},
        useCache: true);
  }

  @override
  void onInit() {
    loadData();
    super.onInit();
  }
}

class MallCartPage extends StatelessWidget {
  const MallCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getDefaultAppBar(
        context,
        "分类",
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.white,
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Column(
              children: [
                mallCartSearch(),
              ],
            ),
          ),

          Positioned(
            top: kToolbarHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: categoryTab(),
                ),
                SingleChildScrollView(
                  child: categoryContent(),
                )
              ],
            ),
          )

          // Positioned(
          //   left: 0,
          //   top: 54.5.w,
          //   child: CategoryTab(),
          // ),
          // Positioned(left: 90.w, top: 54.5.w, child: CategoryContent())
        ],
      ),
    );
  }

  // 搜索
  Widget mallCartSearch() {
    return Container(
      color: Colors.white,
      width: 375.w,
      child: Column(children: [
        ghb(5),
        gwb(375),
        CustomButton(
          child: Container(
            width: 345.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColor.pageBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: sbRow([
                Text('请输入想要搜索的商品'),
                Image.asset(
                  assetsName("business/mall/icon_search"),
                  width: 18.w,
                ),
              ], width: 345 - 20.5 * 2),
            ),
          ),
          onPressed: () => print(""),
        ),
        ghb(9.5.w),
      ]),
    );
  }

  // 左侧分类
  Widget categoryTab() {
    return GetBuilder<MallCartPageController>(
      init: MallCartPageController(),
      initState: (_) {},
      builder: (controller) {
        return SizedBox(
          width: 90.w,
          child: Column(
            children: List.generate((controller.MallTypeList ?? []).length, (index) {
              Map data = controller.MallTypeList[index ?? 0] ?? [];

              return GetBuilder<MallCartPageController>(
                builder: (_) {
                  return GestureDetector(onTap: () {
                    controller.currentIndex = index;
                  }, child: GetX<MallCartPageController>(
                    builder: (controller) {
                      return Container(
                        decoration: BoxDecoration(color: Color(controller.currentIndex == index ? 0xFFFFFFFF : 0xFFF5F5F7)),
                        alignment: Alignment.center,
                        width: 90.w,
                        height: 50.w,
                        child: Text(
                          data['title'] ?? '',
                          style: TextStyle(fontSize: 15, color: Color(controller.currentIndex == index ? 0xFFFF6231 : 0xFF333333)),
                        ),
                      );
                    },
                  ));
                },
              );
            }),
          ),
        );
      },
    );
  }

  // 分类区域

  Widget categoryContent() {
    return Container(
      width: 285.w,
      padding: EdgeInsets.all(8.w),
      child:
          // Container(child: Text("${controller.MallTypeList[controller.currentIndex]['children']}")
          GetX<MallCartPageController>(
        init: MallCartPageController(),
        initState: (_) {},
        builder: (controller) {
          return Column(
            children: List.generate((controller.MallTypeList[controller.currentIndex]['child'] ?? []).length, (level2Index) {
              Map _level2Item = (controller.MallTypeList[controller.currentIndex]['child'])[level2Index] ?? [];
              List _level3data = _level2Item['child'] ?? [];
              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_level2Item['title'] ?? ""),
                  ),
                  ghb(10.5.w),
                  // Text('${level2data["children"]}')
                  SizedBox(
                    child: Wrap(
                      spacing: 10.w,
                      runSpacing: 20.w,
                      children: List.generate((_level3data ?? []).length, (level3Index) {
                        Map level3item = _level3data[level3Index] ?? [];
                        return Container(
                          child: Column(children: [
                            // Image.network("${level3item['imgUrl']}"),
                            CustomNetworkImage(
                              src: AppDefault().imageUrl + (level3item["icon"] ?? ""),
                              width: 70.w,
                              height: 70.w,
                            ),

                            Text("${level3item['title'] ?? ''}"),
                          ]),
                        );
                      }),
                    ),
                  ),
                  ghb(10.5.w),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}



// [
//                 Align(
//                   child: Text("ceshi"),
//                   alignment: Alignment.centerLeft,
//                 ),
//                 SizedBox(
//                   child: Wrap(
//                     spacing: 10.w,
//                     runSpacing: 10.w,
//                     children: List.generate(controller.MallTypeList[controller.currentIndex].length, (index) {
//                       Map data = controller.MallTypeList[index];
//                       return Container(
//                         width: 70.w,
//                         height: 90.w,
//                         child: Column(
//                           children: [
//                             // Image.network(
//                             //   data[""],
//                             //   width: 70.w,
//                             //   height: 70.w,
//                             // ),
//                             Text("gougo")
//                           ],
//                         ),
//                       );
//                     }),
//                   ),
//                 )
//               ]