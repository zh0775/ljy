import 'package:flutter/material.dart';
import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/home/component/recent_data.dart';
import 'package:cxhighversion2/home/home.dart';
import 'package:cxhighversion2/product/component/product_list_cell.dart';
import 'package:cxhighversion2/service/urls.dart';
import 'package:cxhighversion2/third/reorderables-0.4.4/widgets/reorderable_table.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:cxhighversion2/util/toast.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:get/get.dart';

class HomeCustomSettingsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeCustomSettingsController>(HomeCustomSettingsController());
  }
}

class HomeCustomSettingsController extends GetxController {
  List productTmpList = [
    {
      "levelLogo": "product/img_lakala",
      "tbName": "拉卡拉",
      "levelTitle": "拉卡拉MIni2021新4G版",
      "levelSubhead": "0.6%+3 服务费",
      "levelNowPrice": 149,
    },
    {
      "levelLogo": "product/img_sft",
      "tbName": "盛付通",
      "levelTitle": "盛付通台牌",
      "levelSubhead": "0.6%+3 服务费",
      "levelNowPrice": 149,
    },
    {
      "levelLogo": "product/img_hkrt",
      "tbName": "海科融通",
      "levelTitle": "海科融通大机2021",
      "levelSubhead": "0.6%+3 服务费",
      "levelNowPrice": 149,
    },
  ];

  List businessDemoList = [
    {
      "coverImages": "home/img_bs_01",
      "title": "重磅！央行取消信用卡利率 上下限管理",
      "view": 2213
    },
    {
      "coverImages": "home/img_bs_02",
      "title": "「干货」从卡奴到卡神的16 条心得和4大提额技巧",
      "view": 32
    },
    {
      "coverImages": "home/img_bs_03",
      "title": "POS机展业的技巧，简单的 方式重复做",
      "view": 2213
    },
    {
      "coverImages": "home/img_bs_04",
      "title": "银联公布2020年交易数据， 向数字化转型发力",
      "view": 98
    },
  ];

  List integralDemoList = [
    {
      "shopImgShow": "home/jifen_01",
      "shopMeta": "DISPOSABLE MASK一次性医用口罩",
      "shopNowPrice": 50
    },
    {
      "shopImgShow": "home/jifen_02",
      "shopMeta": "宝格丽洗漱专用马克杯， 各色可选",
      "shopNowPrice": 100
    },
    {
      "shopImgShow": "home/jifen_03",
      "shopMeta": "【限量款】锐舞苹果12 promax 手机壳",
      "shopNowPrice": 200
    },
    {
      "shopImgShow": "home/jifen_04",
      "shopMeta": "徐福记新年贺岁款，美 味紫薯黑糖年糕",
      "shopNowPrice": 200
    },
  ];

  Map dataInfoDemoData = {
    "teamThisMAmount": 4200,
    "soleThisMAmount": 4200,
    "teamLastMAmount": 2235.45,
    "soleLastMAmount": 2235.45,
    "teamThisDAmount": 610,
    "soleThisDAmount": 610,
    "teamLastDAmount": 321.68,
    "soleLastDAmount": 321.68,
    "teamThisMActTerminal": 5712,
    "soleThisMActTerminal": 357,
    "teamLastMActTerminal": 6817,
    "soleLastMActTerminal": 531,
    "teamThisDActTerminal": 54,
    "soleThisDActTerminal": 5,
    "teamLastDActTerminal": 89,
    "soleLastDActTerminal": 6,
    "teamThisMAddMerchant": 311,
    "soleThisMAddMerchant": 11,
    "teamLastMAddMerchant": 301,
    "soleLastMAddMerchant": 10,
    "teamThisDAddMerchant": 3,
    "soleThisDAddMerchant": 1,
    "teamLastDAddMerchant": 49,
    "soleLastDAddMerchant": 2,
    "teamThisMAddUser": 5902,
    "soleThisMAddUser": 582,
    "teamLastMAddUser": 2145,
    "soleLastMAddUser": 332,
    "teamThisDAddUser": 190,
    "soleThisDAddUser": 31,
    "teamLastDAddUser": 239,
    "soleLastDAddUser": 59,
  };

  List defaultSettings = [];
  List settings = [];
  Map homeData = {};

  final _haveAdded = false.obs;
  bool get haveAdded => _haveAdded.value;
  set haveAdded(v) => _haveAdded.value = v;

  final _haveUnAdd = false.obs;
  bool get haveUnAdd => _haveUnAdd.value;
  set haveUnAdd(v) => _haveUnAdd.value = v;

  List currentSelectedModules = [];
  List currentUnselectedModules = [];

  List currentModules = [];
  List otherModules = [];

  String addedModuleListBuildId = "HomeCustomSettings_addedModuleListBuildId";
  String unDddedModuleListBuildId =
      "HomeCustomSettings_unDddedModuleListBuildId";

  checkSelect() {
    haveAdded = currentSelectedModules.isNotEmpty;
    haveUnAdd = currentUnselectedModules.isNotEmpty;
  }

  changeList({required bool isAdd, required int index}) {
    if (!isAdd) {
      dynamic data = currentUnselectedModules.removeAt(index);
      currentSelectedModules.add(data);
    } else {
      dynamic data = currentSelectedModules.removeAt(index);
      data["open"] = false;
      currentUnselectedModules.add(data);
    }
    update();
    checkSelect();
  }

  selectListOnReorder(oldIndex, newIndex) {
    dynamic row = currentSelectedModules.removeAt(oldIndex);
    currentSelectedModules.insert(newIndex, row);
    update();
  }

  loadSaveSettingAction() {
    List module = [];
    for (var e in currentSelectedModules) {
      e["module_Flag"] = 1;
      (e as Map).remove("open");
      module.add(e);
    }
    for (var e in currentUnselectedModules) {
      e["module_Flag"] = 0;
      (e as Map).remove("open");
      module.add(e);
    }

    for (var e in otherModules) {
      e["module_Flag"] = 0;
      module.add(e);
    }

    for (var i = 0; i < module.length; i++) {
      Map e = module[i];
      e["module_Order"] = i + 1;
    }

    simpleRequest(
      url: Urls.userSetHomeModule,
      params: {},
      otherData: module,
      success: (success, json) {
        if (success) {
          Get.find<HomeController>().homeOnRefresh();
          ShowToast.normal("保存设置成功");
          Future.delayed(const Duration(seconds: 1), () {
            Get.back();
          });
        }
      },
      after: () {},
    );
  }

  bool isFirst = true;
  // late BuildContext context;
  // late ScrollController drag;
  List homeModules = [];
  dataInit(List? modules) {
    if (!isFirst) {
      return;
    }
    isFirst = false;
    // context = ctx;
    homeModules = modules ?? [];
    homeModulesFormat();
    // currentSelectedModules = currentModules;

    // drag = PrimaryScrollController.of(context) ?? ScrollController();
  }

  homeModulesFormat() {
    final homeCtrl = Get.find<HomeController>();
    if (homeModules == null || homeModules.isEmpty) {
      homeModules = AppDefault().homeData["homeModule"];
    }
    if (homeModules == null || homeModules.length < 2) {
      ShowToast.normal("获取自定义数据失败");
      homeCtrl.refreshHomeData();
      Future.delayed(const Duration(seconds: 1), () {
        Get.back();
      });
      return;
    }

    if (homeModules != null && homeModules.isNotEmpty) {
      String code = homeModules[0]["module_Code"] ?? "";
      bool repetition = false;
      for (var i = 1; i < homeModules.length; i++) {
        var e = homeModules[i];
        if (code == (e["module_Code"] ?? "null")) {
          repetition = true;
          break;
        }
      }
      if (repetition) {
        ShowToast.normal("数据出现错误");
        homeCtrl.refreshHomeData();
        Future.delayed(const Duration(seconds: 1), () {
          Get.back();
        });
        return;
      }
    }

    List tmpModules = homeModules;
    homeModules = [];
    otherModules = [];

    if (AppDefault().checkDay) {
      homeModules = tmpModules;
    } else {
      for (var e in tmpModules) {
        if (e["module_Code"] != "hm00003" && e["module_Code"] != "hm00002") {
          homeModules.add(e);
        } else {
          e["module_Flag"] = 0;
          otherModules.add(e);
        }
      }
    }
    homeModules.sort(
        ((a, b) => (a["module_Order"] as int).compareTo(b["module_Order"])));
    currentModules = homeModules
        .asMap()
        .entries
        .map((e) => {...e.value, "open": false})
        .toList();
    for (var e in currentModules) {
      if (e["module_Flag"] == 0) {
        currentUnselectedModules.add(e);
      } else {
        currentSelectedModules.add(e);
      }
    }
    checkSelect();
  }
}

class HomeCustomSettings extends GetView<HomeCustomSettingsController> {
  final List homeModules;
  const HomeCustomSettings({Key? key, this.homeModules = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.dataInit(homeModules);
    return Scaffold(
      appBar: getDefaultAppBar(context, "定制我的首页", action: [
        CustomButton(
          onPressed: () {
            controller.loadSaveSettingAction();
          },
          child: SizedBox(
            width: 60.w,
            height: 50.w,
            child: Center(
              child: getSimpleText("保存", 14, AppColor.textBlack),
            ),
          ),
        )
      ]),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            gwb(375),
            GetX<HomeCustomSettingsController>(
              init: controller,
              builder: (_) {
                return Visibility(
                    visible: controller.haveAdded,
                    child: sbhRow([
                      centClm([
                        getSimpleText("已添加模块", 18, AppColor.textBlack,
                            isBold: true),
                        ghb(3),
                        centRow([
                          getSimpleText("拖动符号  [", 14, AppColor.textGrey),
                          Icon(
                            Icons.menu_rounded,
                            size: 20.w,
                          ),
                          getSimpleText("] 可按顺序排列", 14, AppColor.textGrey),
                        ]),
                      ], crossAxisAlignment: CrossAxisAlignment.start)
                    ], width: 375 - 23.5 * 2, height: 80));
              },
            ),
            GetBuilder<HomeCustomSettingsController>(
              init: controller,
              // id: controller.addedModuleListBuildId,
              initState: (_) {},
              builder: (_) {
                double height = controller.currentSelectedModules != null &&
                        controller.currentSelectedModules.isNotEmpty
                    ? controller.currentSelectedModules.length * 60.5.w
                    : 0;
                return Align(
                  child: SizedBox(
                      width: 375.w,
                      height: height,
                      child: ReorderableTable(
                        onReorder: controller.selectListOnReorder,
                        children: [
                          ...controller.currentSelectedModules
                              .asMap()
                              .entries
                              .map((e) => deleteCell(e))
                              .toList(),
                        ],
                      )),
                );
              },
            ),
            ghb(9),
            GetX<HomeCustomSettingsController>(
              builder: (_) {
                return Visibility(
                  visible: controller.haveUnAdd,
                  child: sbhRow([
                    getSimpleText("未添加模块", 18, AppColor.textBlack, isBold: true)
                  ], width: 375 - 23 * 2, height: 51),
                );
              },
            ),
            GetBuilder<HomeCustomSettingsController>(
              init: controller,
              builder: (controller) {
                return Column(
                  children: [
                    ...controller.currentUnselectedModules
                        .asMap()
                        .entries
                        .map((e) => addCell(e))
                        .toList()
                  ],
                );
              },
            ),
            ghb(70)
          ],
        ),
      ),
    );
  }

  Widget addCell(MapEntry e) {
    return Align(
      child: Container(
        width: 375.w,
        decoration: const BoxDecoration(
          color: Colors.white,
          // border: Border(
          //     top: BorderSide(
          //         width: 0.5.w,
          //         color: e.key == 0
          //             ? AppColor.lineColor
          //             : Colors.transparent),
          //     bottom: BorderSide(
          //         width: 0.5.w,
          //         color: AppColor.lineColor)),
        ),
        child: Column(
          children: [
            sbhRow([
              centRow([
                CustomButton(
                  onPressed: () {
                    controller.changeList(isAdd: false, index: e.key);
                  },
                  child: SizedBox(
                    width: 30.5.w,
                    height: 50.w,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.add_circle_rounded,
                        size: 25.w,
                        color: const Color(0xFF35C85D),
                      ),
                    ),
                  ),
                ),
                gwb(18),
                getSimpleText(
                    e.value["module_Name"] ?? "", 16, AppColor.textBlack,
                    isBold: true),
              ]),
              CustomButton(
                onPressed: () {
                  e.value["open"] = !e.value["open"];
                  controller.update();
                },
                child: SizedBox(
                  width: 40.w,
                  height: 60.5.w,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: getSimpleText(
                        e.value["open"] ? "收起" : "预览", 13, AppColor.textGrey),
                  ),
                ),
              )
            ], width: 375 - 25 * 2, height: 60.5),
            getDemo(e.value, e.value["open"]),
          ],
        ),
      ),
    );
  }

  ReorderableTableRow deleteCell(MapEntry e) {
    return ReorderableTableRow(
      //a key must be specified for each row
      key: ObjectKey(e),
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Align(
          child: Container(
            width: 374.7.w,
            height: 60.5.w,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(
                      width: 0.5.w,
                      color:
                          e.key == 0 ? AppColor.lineColor : Colors.transparent),
                  bottom: BorderSide(width: 0.5.w, color: AppColor.lineColor)),
            ),
            child: Align(
              child: sbhRow([
                centRow([
                  CustomButton(
                    onPressed: () {
                      controller.changeList(isAdd: true, index: e.key);
                    },
                    child: SizedBox(
                      width: 30.5.w,
                      height: 50.w,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.remove_circle_rounded,
                          size: 25.w,
                          color: const Color(0xFFFF3B2F),
                        ),
                      ),
                    ),
                  ),
                  gwb(18),
                  getSimpleText(
                      e.value["module_Name"] ?? "", 16, AppColor.textBlack,
                      isBold: true),
                ]),
                Icon(
                  Icons.menu_rounded,
                  size: 20.w,
                  color: const Color(0xFFB3B3B3),
                ),
              ], width: 375 - 24 * 2, height: 60.5),
            ),
          ),
        )
      ],
    );
  }

  Widget getDemo(Map data, bool open) {
    switch (data["module_Code"]) {
      case "hm00001": //机具产品
        return machineDemo(open);
      case "hm00004": //商学院
        return businessDemo(open);
      case "hm00005": //积分商城
        return integralDemo(open);
      case "hm00002": //团队数据
        return dataInfoDemo(open, 1);
      case "hm00003": //个人数据
        return dataInfoDemo(open, 0);
      default:
        return ghb(0);
    }
  }

  Widget dataInfoDemo(bool open, int type) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 375.w,
        height: open ? 316.5.w : 0,
        // color: Colors.red,
        child: SingleChildScrollView(
          child: Column(
            children: [
              gline(351, 0.5, color: const Color(0xFFF0F0F0)),
              RecentData(
                recentDataType:
                    type == 0 ? RecentDataType.personally : RecentDataType.team,
                data: controller.dataInfoDemoData,
              ),
              gline(351, 0.5, color: const Color(0xFFF0F0F0)),
              ghb(10.5),
              textTips(),
            ],
          ),
        ));
  }

  Widget integralDemo(bool open) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 375.w,
        height: open ? 530.w : 0,
        // color: Colors.red,
        child: SingleChildScrollView(
          child: Column(
            children: [
              gline(351, 0.5, color: const Color(0xFFF0F0F0)),
              ghb(10.5),
              SizedBox(
                  width: 325.w,
                  child: Wrap(
                    runSpacing: 10.5.w,
                    spacing: 7.w,
                    children: controller.integralDemoList
                        .asMap()
                        .entries
                        .map((e) => Container(
                              width: 159.w,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF7F7F7),
                                  borderRadius: BorderRadius.circular(5.w)),
                              child: Column(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(5.w),
                                      ),
                                      child: Image.asset(
                                          assetsName(
                                              e.value["shopImgShow"] ?? ""),
                                          width: 159.w,
                                          height: 159.w,
                                          fit: BoxFit.fitWidth)),
                                  ghb(6),
                                  getContentText(e.value["shopMeta"] ?? "", 13,
                                      AppColor.textBlack, 137, 36, 2,
                                      alignment: Alignment.topLeft),
                                  sbRow([
                                    getSimpleText(
                                        "积分：${integralFormat(e.value["shopNowPrice"] ?? 0)}",
                                        13,
                                        const Color(0xFFFF6326))
                                  ], width: 137),
                                  ghb(10),
                                ],
                              ),
                            ))
                        .toList(),
                  )),
              ghb(10.5),
              textTips(),
            ],
          ),
        ));
  }

  Widget businessDemo(bool open) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 375.w,
        height: open ? 500.w : 0,
        // color: Colors.red,
        child: SingleChildScrollView(
          child: Column(
            children: [
              gline(351, 0.5, color: const Color(0xFFF0F0F0)),
              ...controller.businessDemoList.map((e) => centClm([
                    ghb(17.5),
                    sbRow([
                      Image.asset(
                        assetsName(e["coverImages"] ?? ""),
                        width: 115.w,
                        height: 80.w,
                        fit: BoxFit.fill,
                      ),
                      centClm([
                        getContentText(e["title"] ?? "", 15, AppColor.textBlack,
                            176, 53, 2,
                            alignment: Alignment.topLeft),
                        ghb(3),
                        getSimpleText(
                            "浏览：${e["view"] ?? 0}", 12, AppColor.textGrey),
                      ], crossAxisAlignment: CrossAxisAlignment.start),
                    ], width: 345 - 10 * 2),
                    ghb(15),
                    gline(325, 0.5),
                  ])),
              ghb(10.5),
              textTips(),
            ],
          ),
        ));
  }

  Widget machineDemo(bool open) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 375.w,
        height: open ? 530.w : 0,
        // color: Colors.red,
        child: SingleChildScrollView(
          child: Column(
            children: [
              gline(351, 0.5, color: const Color(0xFFF0F0F0)),
              ...controller.productTmpList.map((e) => ProductListCell(
                    cellData: e,
                    isDemo: true,
                    haveBottomLine: true,
                  )),
              ghb(10.5),
              textTips(),
            ],
          ),
        ));
  }

  Widget textTips() {
    return Column(
      children: [
        // SizedBox(
        //   height: 38.w,
        //   child: Center(
        //     child: getSimpleText("*以上为模块内容展示，并非真实数据", 12, AppColor.textGrey),
        //   ),
        // ),
        getSimpleText("*以上为模块内容展示，并非真实数据", 12, AppColor.textGrey),
        ghb(13.5),
        gline(351, 0.5, color: const Color(0xFFF0F0F0))
      ],
    );
  }
}
