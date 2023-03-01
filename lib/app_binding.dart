import 'package:cxhighversion2/bounspool/bonuspool.dart';
import 'package:cxhighversion2/business/business.dart';
import 'package:cxhighversion2/business/finance/finance_space_home.dart';
import 'package:cxhighversion2/business/finance/finance_space_mine.dart';
import 'package:cxhighversion2/home/home.dart';
import 'package:cxhighversion2/information/information_main.dart';
import 'package:cxhighversion2/mine/mine_page.dart';
import 'package:cxhighversion2/product/product.dart';
import 'package:cxhighversion2/statistics/statistics.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() async {
    // Get.lazyPut<MainPageCtrl>(() => MainPageCtrl());
    // Get.put<EarnMainController>(EarnMainController());
    Get.lazyPut<InformationMainController>(() => InformationMainController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<MinePageController>(() => MinePageController());
    Get.lazyPut<BusinessController>(() => BusinessController());
    Get.lazyPut<StatisticsController>(() => StatisticsController());
    Get.lazyPut<BounsPoolController>(() => BounsPoolController());

    // 金融区
    // Get.lazyPut<FinanceSpaceHomeController>(() => FinanceSpaceHomeController());
    // Get.lazyPut<FinanceSpaceMineController>(() => FinanceSpaceMineController());
  }
}
