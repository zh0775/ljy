import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/component/custom_empty_view.dart';
import 'package:cxhighversion2/component/custom_input.dart';
import 'package:cxhighversion2/component/custom_network_image.dart';
import 'package:cxhighversion2/home/fodderlib/fodder_lib_detail.dart';
import 'package:cxhighversion2/service/urls.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:cxhighversion2/util/user_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert' as convert;

class ShoppingProductListBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ShoppingProductListController>(
        ShoppingProductListController(datas: Get.arguments));
  }
}

class ShoppingProductListController extends GetxController {
  final dynamic datas;
  ShoppingProductListController({this.datas});

  FocusNode searchNode = FocusNode();
  TextEditingController searcInputCtrl = TextEditingController();

  final _isLoadCollect = false.obs;
  bool get isLoadCollect => _isLoadCollect.value;
  set isLoadCollect(v) => _isLoadCollect.value = v;

  final _isList = false.obs;
  bool get isList => _isList.value;
  set isList(v) => _isList.value = v;

  loadAddCollect(Map data) {
    isLoadCollect = true;
    simpleRequest(
      url: Urls.userAddProductCollection(data["productListId"], 2),
      params: {},
      success: (success, json) {
        if (success) {
          loadData();
        }
      },
      after: () {
        isLoadCollect = false;
      },
    );
  }

  loadRemoveCollect(Map data) {
    isLoadCollect = true;
    simpleRequest(
      url: Urls.userDeleteCollection(data["productListId"]),
      params: {},
      success: (success, json) {
        if (success) {
          loadData();
        }
      },
      after: () {
        isLoadCollect = false;
      },
    );
  }

  RefreshController pullCtrl = RefreshController();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(v) => _isLoading.value = v;

  final _haveCleanInput = false.obs;
  bool get haveCleanInput => _haveCleanInput.value;
  set haveCleanInput(v) => _haveCleanInput.value = v;

  final _haveFocus = false.obs;
  bool get haveFocus => _haveFocus.value;
  set haveFocus(v) => _haveFocus.value = v;

  final _haveCleanAlert = false.obs;
  bool get haveCleanAlert => _haveCleanAlert.value;
  set haveCleanAlert(v) => _haveCleanAlert.value = v;

  final _filterIdx = 0.obs;
  int get filterIdx => _filterIdx.value;
  set filterIdx(v) {
    if (_filterIdx.value != v) {
      _filterIdx.value = v;
      if (filterIdx == 0) {
        buyCountSort = -1;
        priceSore = -1;
      } else if (filterIdx == 1) {
        allSort = -1;
        priceSore = -1;
      } else if (filterIdx == 2) {
        allSort = -1;
        buyCountSort = -1;
      }
    }
  }

  final _allSort = (-1).obs;
  int get allSort => _allSort.value;
  set allSort(v) => _allSort.value = v;

  final _buyCountSort = (-1).obs;
  int get buyCountSort => _buyCountSort.value;
  set buyCountSort(v) => _buyCountSort.value = v;

  final _priceSore = (-1).obs;
  int get priceSore => _priceSore.value;
  set priceSore(v) => _priceSore.value = v;

  searchNodeListener() {
    // if (searchNode.hasFocus) {
    haveFocus = searchNode.hasFocus;
    // print("searchNode.hasFocus === ${searchNode.hasFocus}");
    // }
  }

  searcInputCtrlListener() {
    haveCleanInput = searcInputCtrl.text.isNotEmpty;
  }

  List dataList = [];

  int count = 0;
  int pageSize = 20;
  int pageNo = 1;

  loadData({bool isLoad = false}) {
    isLoad ? pageNo++ : pageNo = 1;
    if (dataList.isEmpty) {
      isLoading = true;
    }
    Map<String, dynamic> params = {
      "pageSize": pageSize,
      "pageNo": pageNo,
      "isBoutique": 0,
      "shop_Type": 2,
    };
    // if (filterIdx == 0) {
    //   params["nOrderTime"] = -1;
    //   params["nOrderDownload"] = -1;
    // } else if (filterIdx == 1) {
    //   params["nOrderTime"] = buyCountSort == 0 ? 1 : 0;
    //   params["nOrderDownload"] = -1;
    // } else if (filterIdx == 2) {
    //   params["nOrderTime"] = -1;
    //   params["nOrderDownload"] = priceSore == 0 ? 1 : 0;
    // }
    // if (searcInputCtrl.text.isNotEmpty) {
    //   params["description"] = searcInputCtrl.text;
    // }

    simpleRequest(
      url: Urls.userProductList,
      params: params,
      success: (success, json) {
        if (success) {
          Map data = json["data"] ?? {};
          count = data["count"] ?? 0;
          List tmpList = data["data"] ?? [];

          dataList = isLoad ? [...dataList, ...tmpList] : tmpList;
          update();
          isLoad ? pullCtrl.loadComplete() : pullCtrl.refreshCompleted();
        } else {
          isLoad ? pullCtrl.loadFailed() : pullCtrl.refreshFailed();
        }
      },
      after: () {
        isLoading = false;
      },
    );
  }

  final _searchHistorys = Rx<List>([]);
  List get searchHistorys => _searchHistorys.value;
  set searchHistorys(v) => _searchHistorys.value = v;

  setHistory(String str) {
    if (str.isEmpty) {
      return;
    }
    if (searchHistorys.contains(str)) {
      searchHistorys.remove(str);
    }
    if (searchHistorys.length > 20) {
      searchHistorys.removeAt(0);
    }
    searchHistorys.insert(0, str);
    searchHistorys = searchHistorys;
    UserDefault.saveStr("ShoppingProductList_Search_History",
        convert.jsonEncode(searchHistorys));
  }

  removeHistory(String str) {
    if (str.isEmpty) {
      return;
    }
    if (searchHistorys.contains(str)) {
      searchHistorys.remove(str);
    }
    searchHistorys = searchHistorys;
    UserDefault.saveStr("ShoppingProductList_Search_History",
        convert.jsonEncode(searchHistorys));
  }

  getHistory() async {
    String? h = await UserDefault.get("ShoppingProductList_Search_History");
    if (h != null && h.isNotEmpty) {
      searchHistorys = convert.jsonDecode(h);
    } else {
      searchHistorys = [];
    }
  }

  cleanHistory() {
    searchHistorys = [];
    UserDefault.removeByKey("ShoppingProductList_Search_History");
  }

  searchAction() {
    takeBackKeyboard(Global.navigatorKey.currentContext!);
    loadData();
    setHistory(searcInputCtrl.text);
  }

  @override
  void onReady() {
    if (fromSearch) {
      searchNode.requestFocus();
    }
    super.onReady();
  }

  bool fromSearch = false;
  @override
  void onInit() {
    fromSearch = (datas ?? {})["isSearch"] ?? false;
    getHistory();
    searchNode.addListener(searchNodeListener);
    searcInputCtrl.addListener(searcInputCtrlListener);
    loadData();
    super.onInit();
  }

  @override
  void onClose() {
    searchNode.removeListener(searchNodeListener);
    searchNode.dispose();
    searcInputCtrl.removeListener(searcInputCtrlListener);
    searcInputCtrl.dispose();
    super.onClose();
  }
}

class ShoppingProductList extends GetView<ShoppingProductListController> {
  const ShoppingProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => takeBackKeyboard(context),
      child: Scaffold(
        appBar: getDefaultAppBar(context, "",
            flexibleSpace: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 11.w, right: 5.w),
                width: 285.w,
                height: 30.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColor.pageBackgroundColor,
                    borderRadius: BorderRadius.circular(15.w)),
                child: sbRow([
                  centRow([
                    gwb(15),
                    CustomInput(
                      width: (285 - 15 - 10 - 27.5).w,
                      heigth: 30.w,
                      focusNode: controller.searchNode,
                      textEditCtrl: controller.searcInputCtrl,
                      placeholder: "请输入想要搜索的商品名称",
                      maxLength: 15,
                      style: TextStyle(
                          fontSize: 12.sp, color: AppColor.text2, height: 1.3),
                      placeholderStyle: TextStyle(
                          fontSize: 12.sp,
                          color: AppColor.assisText,
                          height: 1.3),
                      onSubmitted: (p0) {
                        controller.searchAction();
                      },
                    )
                  ]),
                  GetX<ShoppingProductListController>(
                    builder: (_) {
                      return !controller.haveCleanInput
                          ? gwb(0)
                          : CustomButton(
                              onPressed: () {
                                controller.searcInputCtrl.clear();
                              },
                              child: SizedBox(
                                width: 27.5.w,
                                height: 30.w,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Image.asset(
                                    assetsName("common/btn_search_input_close"),
                                    width: 15.w,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                ], width: 285),
              ),
            ),
            action: [
              CustomButton(
                onPressed: () {
                  controller.searchAction();
                },
                child: SizedBox(
                  height: kToolbarHeight,
                  width: 50.w,
                  child: Center(child: getSimpleText("搜索", 12, AppColor.text2)),
                ),
              )
            ]),
        body: Stack(children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 55.w,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(
                          width: 1.w, color: AppColor.pageBackgroundColor))),
              child: Column(
                children: [
                  sbhRow(
                      List.generate(3, (index) {
                        String title = "";

                        switch (index) {
                          case 0:
                            title = "综合";

                            break;
                          case 1:
                            title = "兑换量";

                            break;
                          case 2:
                            title = "按积分";

                            break;
                        }

                        return CustomButton(
                          onPressed: () {
                            controller.filterIdx = index;
                            if (index == 0) {
                              if (controller.allSort == -1) {
                                controller.allSort = 0;
                              }
                              //  else if (controller.allSort == 0) {
                              //   controller.allSort = 1;
                              // } else {
                              //   controller.allSort = 0;
                              // }
                            } else if (index == 1) {
                              if (controller.buyCountSort == -1) {
                                controller.buyCountSort = 0;
                              } else if (controller.buyCountSort == 0) {
                                controller.buyCountSort = 1;
                              } else {
                                controller.buyCountSort = 0;
                              }
                            } else if (index == 2) {
                              if (controller.priceSore == -1) {
                                controller.priceSore = 0;
                              } else if (controller.priceSore == 0) {
                                controller.priceSore = 1;
                              } else {
                                controller.priceSore = 0;
                              }
                            }
                            controller.loadData();
                          },
                          child: GetX<ShoppingProductListController>(
                            builder: (_) {
                              return SizedBox(
                                height: 55.w,
                                width: 375.w / 3,
                                child: centRow([
                                  getSimpleText(
                                      title,
                                      15,
                                      controller.filterIdx == index
                                          ? AppColor.text2
                                          : AppColor.text3,
                                      isBold: controller.filterIdx == index),
                                  GetX<ShoppingProductListController>(
                                    builder: (controller) {
                                      bool desc = false;
                                      if (index == 0 &&
                                          (controller.allSort == -1 ||
                                              controller.allSort == 0)) {
                                        desc = true;
                                      } else if (index == 1 &&
                                          (controller.buyCountSort == -1 ||
                                              controller.buyCountSort == 0)) {
                                        desc = true;
                                      } else if (index == 2 &&
                                          (controller.priceSore == -1 ||
                                              controller.priceSore == 0)) {
                                        desc = true;
                                      }
                                      return index == 0
                                          ? ghb(0)
                                          : Padding(
                                              padding:
                                                  EdgeInsets.only(left: 3.w),
                                              child: Image.asset(
                                                assetsName(
                                                    "business/mall/btn_sort_${controller.filterIdx == index ? desc ? "desc" : "asc" : "none"}"),
                                                width: 6.w,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            );
                                    },
                                  )
                                ]),
                              );
                            },
                          ),
                        );
                      }),
                      height: 45,
                      width: 375),
                  SizedBox(
                    height: 9.w,
                    width: 375.w,
                    child: Stack(
                      children: [
                        GetX<ShoppingProductListController>(
                          builder: (_) {
                            return AnimatedPositioned(
                              top: 0,
                              left: ((375.w / 3) / 2 - 15.w / 2) +
                                  (controller.filterIdx * (375.w / 3)) -
                                  3.w,
                              duration: const Duration(milliseconds: 300),
                              child: Container(
                                width: 15.w,
                                height: 2.w,
                                decoration: BoxDecoration(
                                  color: AppColor.themeOrange,
                                  borderRadius: BorderRadius.circular(0.5.w),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned.fill(
              top: 55.w,
              child: GetBuilder<ShoppingProductListController>(
                builder: (_) {
                  return SmartRefresher(
                    controller: controller.pullCtrl,
                    onLoading: () => controller.loadData(isLoad: true),
                    onRefresh: () => controller.loadData(),
                    enablePullUp: controller.count > controller.dataList.length,
                    child: controller.dataList.isEmpty
                        ? GetX<ShoppingProductListController>(
                            builder: (_) {
                              return CustomEmptyView(
                                isLoading: controller.isLoading,
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: (controller.dataList.length / 2).ceil(),
                            itemBuilder: (context, index) {
                              return cell(index);
                            },
                          ),
                  );
                },
              )),
          GetX<ShoppingProductListController>(
            builder: (_) {
              return !controller.haveFocus && !controller.haveCleanAlert
                  ? gemp()
                  : Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      height: 300.w,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                top: BorderSide(
                                    width: 1.w,
                                    color: AppColor.pageBackgroundColor))),
                        child: Column(
                          children: [
                            sbhRow([
                              getSimpleText("搜索历史", 15, AppColor.text2),
                              CustomButton(
                                onPressed: () async {
                                  controller.haveCleanAlert = true;
                                  await showAlert(
                                    context,
                                    "是否确定删除搜索历史",
                                    confirmOnPressed: () {
                                      Get.back();
                                      controller.cleanHistory();
                                    },
                                    cancelOnPressed: () {
                                      Get.back();
                                    },
                                  );
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    controller.haveCleanAlert = false;
                                  });
                                },
                                child: SizedBox(
                                  height: 58.w,
                                  child: Center(
                                    child: getSimpleText(
                                        "清空", 12, AppColor.textGrey5),
                                  ),
                                ),
                              ),
                            ], width: 345, height: 58),
                            SizedBox(
                              width: 345.w,
                              child: GetX<ShoppingProductListController>(
                                builder: (_) {
                                  return Wrap(
                                    runSpacing: 10.w,
                                    spacing: 10.w,
                                    children: List.generate(
                                        controller.searchHistorys.length,
                                        (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          controller.searcInputCtrl.text =
                                              controller.searchHistorys[index];
                                          controller.loadData();
                                          takeBackKeyboard(context);
                                        },
                                        onLongPress: () async {
                                          controller.haveCleanAlert = true;
                                          showAlert(
                                            context,
                                            "是否删除该记录",
                                            confirmOnPressed: () {
                                              Get.back();
                                              controller.removeHistory(
                                                  controller
                                                      .searchHistorys[index]);
                                            },
                                          );

                                          Future.delayed(
                                              const Duration(seconds: 1), () {
                                            controller.haveCleanAlert = false;
                                          });
                                        },
                                        child: UnconstrainedBox(
                                          child: Container(
                                            // alignment: Alignment.center,
                                            height: 24.w,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF6F6F6),
                                              borderRadius:
                                                  BorderRadius.circular(12.w),
                                            ),
                                            child: Center(
                                              child: getSimpleText(
                                                  controller
                                                      .searchHistorys[index],
                                                  14,
                                                  AppColor.textGrey5,
                                                  textHeight: 0.9),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ));
            },
          )
        ]),
      ),
    );
  }

  Widget cell(int index) {
    return Padding(
      padding: EdgeInsets.only(top: 15.w),
      child: Center(
        child: sbRow(
            List.generate(2, (idx) {
              Map data = {};
              if (index * 2 + idx <= controller.dataList.length - 1) {
                data = controller.dataList[index * 2 + idx];
              }
              return data.isEmpty
                  ? gwb(0)
                  : Container(
                      width: 167.5.w,

                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3.w)),
                      // 167.5.w,
                      height: 270.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(3.w)),
                            child: CustomNetworkImage(
                                src: AppDefault().imageUrl +
                                    (data["shopImg"] ?? ""),
                                width: 167.5.w,
                                height: 167.5.w,
                                fit: BoxFit.cover),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0.w),
                            width: 167.5.w,
                            height: 102.5.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 45.w,
                                  child: getWidthText(data['shopName'] ?? "",
                                      14.w, AppColor.textBlack, 149.w, 2,
                                      textAlign: TextAlign.left,
                                      alignment: Alignment.topLeft),
                                ),
                                getSimpleText(
                                  "${priceFormat(data['nowPrice'] ?? 0, savePoint: 0)}积分",
                                  18,
                                  AppColor.themeOrange,
                                  isBold: true,
                                ),
                                sbhRow([
                                  getSimpleText(
                                      "已兑${data['shopBuyCount'] ?? 0}个",
                                      12,
                                      AppColor.textGrey5,
                                      textAlign: TextAlign.left),
                                  centRow([
                                    GetBuilder<ShoppingProductListController>(
                                      builder: (_) {
                                        return CustomButton(
                                          onPressed: () {
                                            if ((data["isCollect"] ?? 0) == 0) {
                                              controller.loadAddCollect(data);
                                            } else {
                                              controller
                                                  .loadRemoveCollect(data);
                                            }
                                            // data["favoriteStatus"] =
                                            //     !data["favoriteStatus"];
                                            // //
                                            // controller.update();
                                          },
                                          child: SizedBox(
                                            width: 32.w,
                                            height: 28.w,
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: Image.asset(
                                                assetsName((data["isCollect"] ??
                                                            0) ==
                                                        0
                                                    ? 'business/mall/btn_iscollect'
                                                    : 'business/mall/btn_collect'),
                                                width: 16.w,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  ])
                                ], width: 167.5 - 10 * 2, height: 15.w),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
            }),
            width: 345),
      ),
    );
  }
}
