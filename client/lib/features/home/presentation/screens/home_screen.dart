import 'package:flutter/material.dart';
// import 'package:mybudget/features/about/presentation/screens/about_tab.dart';
import 'package:mybudget/features/transactions/presentation/screens/history_tab.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:mybudget/features/home/presentation/screens/home_tab.dart';
import 'package:mybudget/features/profile/presentation/screens/profile_tab.dart';
import 'package:mybudget/features/transactions/presentation/screens/add_transaction_tab.dart';
import 'package:mybudget/features/jars/presentation/screens/jars_setting_tab.dart';
// import 'package:mybudget/features/settings/presentation/screens/settings_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<PersistentTabConfig> _tabs() => [
    PersistentTabConfig(
      screen: const HomeTab(),
      item: ItemConfig(
        icon: const Icon(Icons.home),
        // title: "Home",
        activeForegroundColor: Colors.blue,
        inactiveForegroundColor: Colors.grey,
      ),
    ),
    PersistentTabConfig(
      screen: const HistoryTab(),
      item: ItemConfig(
        icon: const Icon(Icons.history),
        // title: "About",
        activeForegroundColor: Colors.blue,
        inactiveForegroundColor: Colors.grey,
      ),
    ),
    PersistentTabConfig.noScreen(
      // screen: const AddTransactionTab(),
      item: ItemConfig(
        icon: const Icon(Icons.add, size: 30),
        // title: "",
        activeForegroundColor: Colors.blue,
        inactiveForegroundColor: Colors.grey,
      ),
      onPressed: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddTransactionTab()),
        );
      },
    ),
    // PersistentTabConfig(
    //   screen: const SettingsTab(),
    //   item: ItemConfig(
    //     icon: const Icon(Icons.settings),
    //     // title: "Settings",
    //     activeForegroundColor: Colors.blue,
    //     inactiveForegroundColor: Colors.grey,
    //   ),
    // ),
    PersistentTabConfig(
      screen: const JarsSettingTab(),
      item: ItemConfig(
        icon: const Icon(Icons.settings),
        // title: "Jars",
        activeForegroundColor: Colors.blue,
        inactiveForegroundColor: Colors.grey,
      ),
    ),
    PersistentTabConfig(
      screen: const ProfileTab(),
      item: ItemConfig(
        icon: const Icon(Icons.person),
        // title: "Profile",
        activeForegroundColor: Colors.blue,
        inactiveForegroundColor: Colors.grey,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: _tabs(),
      navBarBuilder:
          (navBarConfig) => Style15BottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: const NavBarDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
      backgroundColor: Colors.white,
      navBarHeight: 60.0,
    );
  }
}
