import 'dart:convert';
import 'dart:typed_data';

import 'package:cxhighversion2/component/app_wechat_manager.dart';
import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:universal_html/html.dart' as html;

class FinanceSpaceCardPopBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<FinanceSpaceCardPopController>(
        FinanceSpaceCardPopController(datas: Get.arguments));
  }
}

class FinanceSpaceCardPopController extends GetxController {
  final dynamic datas;
  FinanceSpaceCardPopController({this.datas});

  int type = 0;
  Map cardData = {};
  String shareUrl = "";
  Map homeData = {};
  @override
  void onInit() {
    homeData = AppDefault().homeData;
    cardData = (datas ?? {})["data"] ?? {};
    super.onInit();
  }
}

class FinanceSpaceCardPop extends GetView<FinanceSpaceCardPopController> {
  const FinanceSpaceCardPop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getDefaultAppBar(context, "我要推广"),
        body: Stack(
          children: [
            Positioned.fill(
                child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.topCenter,
                      fit: BoxFit.fitWidth,
                      image: AssetImage(
                          assetsName("business/finance/bg_tuiguang")))),
            )),
            Positioned.fill(
                bottom: 105.w + paddingSizeBottom(context),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [gwb(375), ghb(45), shareView(false), ghb(45)],
                  ),
                )),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 105.w + paddingSizeBottom(context),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  bottom: paddingSizeBottom(context),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8.w)),
                    boxShadow: [
                      BoxShadow(color: const Color(0x26000000), blurRadius: 5.w)
                    ]),
                child: centRow([
                  shareButotn(3, context),
                  gwb(41.5),
                  shareButotn(2, context),
                ]),
              ),
            ),
          ],
        ));
  }

  Widget shareView(bool share) {
    return Container(
      width: 320.w,
      height: 540.w,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.w)),
    );
  }

  Widget shareButotn(int idx, BuildContext context) {
    return CustomButton(
      onPressed: () async {
        // if (controller.webCtrl == null) {
        //   ShowToast.normal("请等待页面加载完毕");
        // }
        // RenderRepaintBoundary boundary = controller
        //     .screenKeys[controller.pageIndex].currentContext!
        //     .findRenderObject() as RenderRepaintBoundary;
        // ui.Image image = await boundary.toImage();
        // ByteData? byteData =
        //     await (image.toByteData(format: ui.ImageByteFormat.png));

        // if (byteData == null) {
        //   ShowToast.normal("出现错误，请稍后再试");
        //   return;
        // }
        // Uint8List imageBytes = byteData.buffer.asUint8List();
        // RenderRepaintBoundary? boundary =
        //     controller.shareViewKey.currentContext?.findRenderObject()
        //         as RenderRepaintBoundary?;

        // ui.Image image = await boundary!.toImage();
        // ByteData? byteData =
        //     await (image.toByteData(format: ui.ImageByteFormat.png));

        // if (byteData == null) {
        //   // ShowToast.normal("出现错误，请稍后再试");
        //   return;
        // }
        // Uint8List imageBytes = byteData.buffer.asUint8List();

        Uint8List imageBytes = await ScreenshotController().captureFromWidget(
            shareView(true),
            delay: const Duration(milliseconds: 100),
            context: context);

        if (idx == 0) {
          AppWechatManager().sharePriendWithFile(imageBytes);
        } else if (idx == 1) {
          AppWechatManager().shareTimelineWithFile(imageBytes);
        } else if (idx == 2) {
          saveAssetsImg(imageBytes);
        } else if (idx == 3) {
          copyClipboard(
              "${controller.shareUrl}?id=${controller.homeData["u_Number"] ?? ""}");
        }
      },
      child: centClm([
        Image.asset(
          assetsName(idx == 0
              ? "share/wx_friend2"
              : idx == 1
                  ? "share/pyq2"
                  : idx == 2
                      ? "share/icon_share_download"
                      : "share/icon_share_copy"),
          // width: 30.5.w,
          height: 50.w,
          fit: BoxFit.fitHeight,
        ),
        ghb(5),
        getSimpleText(
            idx == 0
                ? "微信好友"
                : idx == 1
                    ? "微信朋友圈"
                    : idx == 2
                        ? "保存图片"
                        : "复制链接",
            12,
            AppColor.text2)
      ]),
    );
  }

  saveAssetsImg(Uint8List? imageBytes) async {
    // bool havePermission = await checkStoragePermission();
    // if (!havePermission) {
    //   ShowToast.normal("没有权限，无法保存图片");
    //   return;
    // }
    // Uint8List? byte = await controller.webCtrl!.takeScreenshot();
    if (kIsWeb) {
      if (imageBytes != null) {
        final base64data = base64Encode(imageBytes.toList());
        final a =
            html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');
        a.download = "${DateTime.now().millisecondsSinceEpoch}";
        a.click();
        a.remove();
      }
      // js.context.callMethod(
      //   "savePicture",
      //   [
      //     // html.Blob(
      //     //   imageBytes,
      //     // ),
      //     imageBytes,
      //     "${DateTime.now().millisecondsSinceEpoch}.png"
      //   ],
      // );
    } else {
      saveImageToAlbum(imageBytes);
    }
  }
}
