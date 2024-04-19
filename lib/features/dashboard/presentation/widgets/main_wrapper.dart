import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mind_lab_app/features/dashboard/presentation/bloc/bottom_nav_cubit.dart';
import 'package:mind_lab_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mind_lab_app/features/dashboard/presentation/pages/profile_page.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  // Top level pages
  final List<Widget> topLevelpages = const [
    DashboardPage(),
    ProfilePage(),
  ];

  // On Page Changed
  void onPageChanged(int page) {
    BlocProvider.of<BottomNavCubit>(context).changeSelectedIndex(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _mainWrapperAppBar(),
      bottomNavigationBar: _bottomAppBar(context),
      body: _mainWrapperBody(),
      floatingActionButton: _mainWrapperFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  BottomAppBar _bottomAppBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _bottomAppBarItem(context,
              defaultIcon: IconlyLight.home,
              page: 0,
              label: 'Home',
              filledIcon: IconlyBold.home),
          _bottomAppBarItem(context,
              defaultIcon: IconlyLight.profile,
              page: 1,
              label: 'Profile',
              filledIcon: IconlyBold.profile),
        ],
      ),
    );
  }

  PageView _mainWrapperBody() {
    return PageView(
      onPageChanged: (int page) => onPageChanged(page),
      controller: pageController,
      children: topLevelpages,
    );
  }

  Widget _bottomAppBarItem(
    BuildContext context, {
    required defaultIcon,
    required page,
    required label,
    required filledIcon,
  }) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<BottomNavCubit>(context).changeSelectedIndex(page);

        pageController.animateToPage(page,
            duration: const Duration(milliseconds: 10),
            curve: Curves.fastLinearToSlowEaseIn);
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            Icon(
              context.watch<BottomNavCubit>().state == page
                  ? filledIcon
                  : defaultIcon,
              color: context.watch<BottomNavCubit>().state == page
                  ? Colors.blue
                  : Colors.grey,
              size: 26,
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              label,
              style: GoogleFonts.aBeeZee(
                color: context.watch<BottomNavCubit>().state == page
                    ? Colors.blue
                    : Colors.grey,
                fontSize: 13,
                fontWeight: context.watch<BottomNavCubit>().state == page
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Floating Action Button - Main Wrapper
  FloatingActionButton _mainWrapperFab() {
    return FloatingActionButton(
      onPressed: () {},
      shape: const CircleBorder(),
      child: const Icon(
        IconlyBold.plus,
        color: Colors.black,
      ),
    );
  }

  // App Bar - MainWrapper Widget
  AppBar _mainWrapperAppBar() {
    return AppBar(
      title: const Text("Mind Lab App"),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(IconlyLight.logout),
        ),
      ],
    );
  }
}
