import 'package:flutter/material.dart';

import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cxhighversion2/component/app_banner.dart';

import 'mall_cart_page.dart';
import 'user_mall_page.dart';

import 'package:get/get.dart';

class PointsMallPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<PointsMallPageController>(PointsMallPageController());
  }
}

class PointsMallPageController extends GetxController {
  List<BannerData> banner = <BannerData>[
    BannerData(
        imagePath:
            '${AppDefault().imageUrl}D0031/2023/1/202301311856422204X.png',
        id: '1'),
  ];

  List productList = [
    {
      "id": 1,
      "title": "酒店枕芯五星级宾馆枕 头仿羽布羽丝棉仿鹅...",
      "integral": 1592,
      "exchange": 9456,
      "tag": "积分+现金",
      "status": 0,
      "favoriteStatus": false,
      "img": "${AppDefault().imageUrl}D0031/2023/1/202301311856422204X.png",
    },
    {
      "id": 2,
      "title": "臻棉超柔4件套200*23 0cm 丝丝深情",
      "integral": 6380,
      "exchange": 9456,
      "tag": "",
      "status": 1,
      "favoriteStatus": false,
      "img": "${AppDefault().imageUrl}D0031/2023/1/202301311856422204X.png",
    },
    {
      "id": 3,
      "title": "天堂伞2件套 天堂伞天堂伞",
      "integral": 1592,
      "exchange": 9456,
      "tag": "积分+现金",
      "status": 1,
      "favoriteStatus": false,
      "img": "${AppDefault().imageUrl}D0031/2023/1/202301311856422204X.png",
    },
    {
      "id": 4,
      "title": "苏泊尔电磁炉 苏泊尔 电磁炉",
      "integral": 1592,
      "exchange": 9456,
      "tag": "",
      "status": 0,
      "favoriteStatus": false,
      "img": "${AppDefault().imageUrl}D0031/2023/1/202301311856422204X.png",
    },
  ];

  @override
  void onInit() {
    super.onInit();
  }
}

class PointsMallPage extends GetView<PointsMallPageController> {
  const PointsMallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFFFFFFF),
      appBar: getDefaultAppBar(
        context,
        "积分商城",
        action: [],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          MallTop(),
          ghb(6),
          RecommendationList(),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: '分类'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: '购物车'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              push(const MallCartPage(), null, binding: MallCartPageBinding());
              break;
            case 3:
              push(const UserMallPage(), null, binding: UserMallPageBinding());
              break;
            default:
          }
        },
      ),
    );
  }

  // banner + 商城快捷入口
  Widget MallTop() {
    return Container(
      decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
      width: 375.w,
      child: Column(children: [
        ghb(5),
        gwb(375),
        CustomButton(
          child: Container(
            width: 345.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F7),
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
        ghb(20.5),
        Column(
          children: [
            AppBanner(
              width: 375,
              height: 218,
              banners: controller.banner,
              borderRadius: 5,
            ),
          ],
        ),
        sbRow(
            List.generate(4, (index) {
              String title = "";
              String img = "business/mall/shortcut_icon_";

              switch (index) {
                case 0:
                  title = "兑换榜单";
                  img += "1";
                  break;
                case 1:
                  title = "联聚定制";
                  img += "2";
                  break;
                case 2:
                  title = "活动特惠";
                  img += "3";
                  break;
                case 3:
                  title = "商城新品";
                  img += "4";
                  break;
                default:
              }

              return CustomButton(
                onPressed: () {},
                child: centClm([
                  Image.asset(
                    assetsName(img),
                    width: 45.w,
                  ),
                  ghb(4),
                  getSimpleText(title, 12, AppColor.text2)
                ]),
              );
            }),
            width: 375 - 25.5 * 2),
        ghb(20),
      ]),
    );
  }

  Widget RecommendationList() {
    return Container(
      width: 375.w,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
            child: Center(
              child: sbhRow([
                nSimpleText("精品推荐", 16, isBold: true),
                GestureDetector(
                  onTap: () => print("点击事件"),
                  child: centRow([
                    nSimpleText("查看更多", 12,
                        color: AppColor.text3, textHeight: 1.2),
                    Image.asset(
                      assetsName("mine/icon_right_arrow"),
                      width: 12.w,
                      fit: BoxFit.fitWidth,
                    )
                  ]),
                )
              ], width: 345, height: 50),
            ),
          ),

          ghb(15),
          ProductListView(),
          // 产品列表
        ],
      ),
    );
  }

  // 积分列表
  Widget ProductListView() {
    return Container(
      width: 375.w,
      child: Column(
        children: [
          SizedBox(
            width: 345.w,
            child: Wrap(
              spacing: 10.w,
              runSpacing: 10.w,
              children: List.generate(controller.productList.length, (index) {
                Map data = controller.productList[index];
                return Container(
                  decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
                  width: (375 - 15 * 2 - 10).w / 2 - 0.1,

                  // 167.5.w,
                  height: 270.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.network(
                        data["img"],
                        width: 167.5.w,
                        height: 167.5.w,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0.w),
                        width: 167.5.w,
                        height: 102.5.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getWidthText(data['title'], 14.w,
                                AppColor.textBlack, 149.w, 2,
                                textAlign: TextAlign.left,
                                alignment: Alignment.topLeft),
                            getSimpleText("${data['integral']}积分" ?? "0积分", 18,
                                AppColor.theme3,
                                isBold: true, textAlign: TextAlign.left),
                            sbhRow([
                              getSimpleText("已兑${data['exchange']}个" ?? "已兑0个",
                                  12, Color(0xFF999999),
                                  textAlign: TextAlign.left),
                              centRow([
                                GetBuilder<PointsMallPageController>(
                                  builder: (_) {
                                    return CustomButton(
                                      onPressed: () {
                                        data["favoriteStatus"] =
                                            !data["favoriteStatus"];
                                        //
                                        controller.update();
                                      },
                                      child: Image.asset(
                                        assetsName(data["favoriteStatus"]
                                            ? 'business/mall/btn_iscollect'
                                            : 'business/mall/btn_collect'),
                                        width: 32.w,
                                        height: 28.w,
                                      ),
                                    );
                                  },
                                )
                              ])
                            ], width: 167.5 - 10 * 2, height: 12.w),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
