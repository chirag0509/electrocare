import 'package:electrocare/screens/bottomNav/home_screen.dart';
import 'package:electrocare/screens/bottomNav/wallet.dart';
import 'package:electrocare/screens/bottomNav/profile_screen.dart';
import 'package:electrocare/screens/bottomNav/repairs/recent_repairs.dart';
import 'package:electrocare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const RecentRepairs(),
    const Wallet(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Constants.bg1,
        activeColor: Constants.primary,
        color: Constants.grey,
        elevation: 1,
        style: TabStyle.textIn,
        height: 60.h,
        items: [
          TabItem(
            icon: Icon(
              FontAwesomeIcons.home,
              size: 22.sp,
              color: Constants.grey,
            ),
            activeIcon: Container(
              decoration: BoxDecoration(
                color: Constants.primary,
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Icon(
                FontAwesomeIcons.home,
                size: 20.sp,
                color: Constants.bg1,
              ),
            ),
            title: 'Home',
          ),
          TabItem(
            icon: Icon(
              FontAwesomeIcons.history,
              size: 22.sp,
              color: Constants.grey,
            ),
            activeIcon: Container(
              decoration: BoxDecoration(
                color: Constants.primary,
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Icon(
                FontAwesomeIcons.history,
                size: 20.sp,
                color: Constants.bg1,
              ),
            ),
            title: 'Repairs',
          ),
          TabItem(
            icon: Icon(
              FontAwesomeIcons.wallet,
              size: 22.sp,
              color: Constants.grey,
            ),
            activeIcon: Container(
              decoration: BoxDecoration(
                color: Constants.primary,
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Icon(
                FontAwesomeIcons.wallet,
                size: 20.sp,
                color: Constants.bg1,
              ),
            ),
            title: 'Wallet',
          ),
          TabItem(
            icon: Icon(
              FontAwesomeIcons.solidUser,
              size: 22.sp,
              color: Constants.grey,
            ),
            activeIcon: Container(
              decoration: BoxDecoration(
                color: Constants.primary,
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Icon(
                FontAwesomeIcons.solidUser,
                size: 20.sp,
                color: Constants.bg1,
              ),
            ),
            title: 'Profile',
          ),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
