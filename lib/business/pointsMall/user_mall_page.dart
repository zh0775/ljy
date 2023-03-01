import 'package:flutter/material.dart';
import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'mall_cart_page.dart';
import 'package:cxhighversion2/business/mallCollect/mall_collect_page.dart';

import 'package:cxhighversion2/business/afterSale/after_sale_page.dart';

import 'package:get/get.dart';

class UserMallPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserMallPageController>(() => UserMallPageController());
  }
}

class UserMallPageController extends GetxController {
  Map MallUserInfo = {"username": "拓客北海", "phone": "18261322045"};

  @override
  void onInit() {
    super.onInit();
  }
}

class UserMallPage extends GetView<UserMallPageController> {
  const UserMallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0, backgroundColor: Color(0xFFFF6231)),
      body: Stack(children: [
        Positioned(
          top: 0,
          child: Image.asset(
            assetsName("business/mall/user/user_mall_bg"),
            width: 375.w,
            height: 127.w,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: UserTopInfo(),
        ),
        Positioned(
          left: 15.w,
          top: 83.5.w,
          child: userOrderType(),
        ),
        Positioned(
            top: kToolbarHeight + 153.5.w,
            left: 15.w,
            child: Column(
              children: [
                ghb(15.w),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      userCellList(context),
                      ghb(15.w),
                      BusinessCircleCell("商业圈"),
                      ghb(15.w),
                      CustomButton(
                        onPressed: () {},
                        child: Image.asset(
                          assetsName("business/bg_apply_card"),
                          width: 345.w,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ))
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: '分类'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: '购物车'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              push(const MallCartPage(), null, binding: MallCartPageBinding());
              break;
            default:
          }
        },
      ),
    );
  }

  /**
   * userTopInfo    图像、名称、电话
   */

  Widget UserTopInfo() {
    return Container(
      width: 375.w,
      height: 60.w,
      padding: EdgeInsets.fromLTRB(21.w, 1.w, 15.w, 0.w),
      child: Row(
        children: [
          Image.asset(
            assetsName("business/mall/user/user_avatar"),
            width: 60.w,
            height: 60.w,
          ),
          gwb(14.5.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getSimpleText(controller.MallUserInfo['username'], 18.w, Color(0xFFFFFFFF), isBold: true),
              ghb(5.w),
              getSimpleText("手机号：${controller.MallUserInfo['phone']}", 12.w, Color(0xFFFFFFFF)),
            ],
          )
          // centClm([
          //   Text("拓客北海"),
          //   Text("手机号：18261322045"),
          // ])
        ],
      ),
    );
  }

  /**
   * userOrderType
   * 用户订单类型
   */

  Widget userOrderType() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.w), boxShadow: [BoxShadow(color: const Color(0xFFE9EDF5), offset: Offset(0, 5.w), blurRadius: 5.w, spreadRadius: 0.w)]),
      padding: EdgeInsets.fromLTRB(19.w, 11.5.w, 19.w, 11.5.w),
      width: 345.w,
      height: 120.w,
      child: Column(children: [
        sbhRow([
          nSimpleText("我的订单", 18, isBold: true),
          GestureDetector(
            onTap: () => print("点击事件"),
            child: centRow([
              nSimpleText("查看全部", 14, color: AppColor.text3, textHeight: 1.2),
              Image.asset(
                assetsName("mine/icon_right_arrow"),
                width: 12.w,
                fit: BoxFit.fitWidth,
              )
            ]),
          )
        ]),
        sbRow(List.generate(4, (index) {
          String title = "";
          String typeImg = "business/mall/user/";
          switch (index) {
            case 0:
              title = "待收货";
              typeImg += "deliver";
              break;
            case 1:
              title = "待发货";
              typeImg += "send";
              break;
            case 2:
              title = "待评价";
              typeImg += "evaluate";
              break;
            case 3:
              title = "售后";
              typeImg += "refund";
              break;
            default:
          }
          return CustomButton(
            onPressed: () {
              if (index == 3) {
                push(const AfterSalePage(), null, binding: AfterSalePageBinding());
              }
            },
            child: centClm([
              Image.asset(
                assetsName(typeImg),
                width: 45.w,
                fit: BoxFit.fitHeight,
              ),
              getSimpleText(title, 14.w, Color(0xFF999999))
            ]),
          );
        }))
      ]),
    );
  }

  /**
   * cell列表  我的收藏、 我的收获地址、联系客服
   */

  Widget userCellList(context) {
    return Container(
      width: 345.w,
      padding: EdgeInsets.symmetric(vertical: 4.25.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.w), boxShadow: [BoxShadow(color: const Color(0xFFE9EDF5), offset: Offset(0, 8.5.w), blurRadius: 25.5.w, spreadRadius: 15.5.w)]),
      child: Column(
        children: List.generate(3, (index) {
          String title = "";
          switch (index) {
            case 0:
              title = "我的收藏";
              break;
            case 1:
              title = "我的收货地址";
              break;
            case 2:
              title = "联系客服";
              break;
            default:
          }
          return CustomButton(
            onPressed: () {
              switch (index) {
                case 0:
                  push(const MallCollectPage(), null, binding: MallCollectPageBinding());
                  break;
                case 1:
                  break;
                case 2:
                  showAlert(context, "请加客服微信 skx123", confirmOnPressed: () {
                    print("确定");
                  });
                  break;

                default:
              }
            },
            child: sbRow([
              SizedBox(
                height: 56.5.w,
                width: 345.w,
                child: Center(
                  child: sbRow([
                    getSimpleText(title, 14, const Color(0xFF333333), textHeight: 1.1, isBold: true),
                    Image.asset(
                      assetsName("mine/icon_right_arrow"),
                      width: 11.w,
                      fit: BoxFit.fitWidth,
                    )
                  ], width: 345 - 20 * 2 - 0.1),
                ),
              )
            ]),
          );
        }),
      ),
    );
  }

  /**
   * 商业圈cell
   */

  Widget BusinessCircleCell(String title) {
    return Container(
      width: 345.w,
      height: 60.w,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.w)),
      child: Center(
        child: sbRow([
          getSimpleText(title, 14, const Color(0xFF333333), textHeight: 1.1, isBold: true),
          Image.asset(
            assetsName("mine/icon_right_arrow"),
            width: 11.w,
            fit: BoxFit.fitWidth,
          )
        ], width: 345 - 20 * 2 - 0.1),
      ),
    );
  }
}
