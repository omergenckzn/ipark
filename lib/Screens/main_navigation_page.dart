import 'package:flutter_remix/flutter_remix.dart';
import 'package:ipark/Constants/ipark_constants.dart';
import 'package:ipark/Screens/Cars/cars_view.dart';
import 'package:ipark/Screens/Pay/pay_view.dart';
import 'package:ipark/Screens/Premium/premium_view.dart';
import 'package:ipark/Screens/Settings/settings_view.dart';
import 'package:flutter/cupertino.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({Key? key}) : super(key: key);

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {

  CupertinoTabController tabController = CupertinoTabController();
  late int selectedTabIndex;


  @override
  void initState() {
    selectedTabIndex = 0;

    tabController.addListener(() {
      setState(() {
        selectedTabIndex = tabController.index;
      });
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    var sizeModifier = MediaQuery.of(context).size.height;

    return CupertinoTabScaffold(tabBar: CupertinoTabBar(
      height: sizeModifier * 0.09,
      activeColor: IParkColors.activeInputBorderColor,
      inactiveColor: IParkColors.stableInputBorderColor,
      items: [
        navigationBarItemBuilder(
            selectedTabIndex == 0
                ? FlutterRemix.bank_card_fill
                : FlutterRemix.bank_card_line,
            "Pay"),
        navigationBarItemBuilder(
            selectedTabIndex == 1
                ? FlutterRemix.car_fill
                : FlutterRemix.car_line,
            "Cars"),
        navigationBarItemBuilder(
            selectedTabIndex == 2
                ? FlutterRemix.vip_diamond_fill
                : FlutterRemix.vip_diamond_line,
            "Premium"),
        navigationBarItemBuilder(
            selectedTabIndex == 3
                ? FlutterRemix.account_circle_fill
                : FlutterRemix.account_circle_line,
            "Settings"),
      ],
    ), tabBuilder: (context, index) {
      return navigationPagePicker(index);
    },controller: tabController ,);
  }

  CupertinoTabView navigationPagePicker(int index) {
    switch (index) {
      case 0:
        return CupertinoTabView(
          builder: (context) => const PayView(),
        );
      case 1:
        return CupertinoTabView(
          builder: (context) => const CarsView(),
        );
      case 2:
        return CupertinoTabView(
          builder: (context) => const PremiumView(),
        );
      case 3:
        return CupertinoTabView(
          builder: (context) => const SettingsView(),
        );
      default:
        return CupertinoTabView(
          builder: (context) => const PayView(),
        );
    }
  }

  BottomNavigationBarItem navigationBarItemBuilder(
      IconData data, String content) {
    return BottomNavigationBarItem(
        icon: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Icon(
              data,
              size: 22.31,
            ),
            const SizedBox(
              height: 5.4,
            ),
            Text(
                content,
                style: IParkStyles.navigationBarItemTextStyle,
            )
          ],
        ));
  }

}
