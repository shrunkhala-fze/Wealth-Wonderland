import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../style/palette.dart';

Logger _log = Logger('scaffold_with_navbar.dart');

class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.child,
    Key? key,
  }) : super(key: key);

  /// The widget to display in the body of the Scaffold.
  /// In this sample, it is a Navigator.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: palette.inkFullOpacity,
        selectedItemColor: palette.inkFullOpacity,
        // selectedLabelStyle: TextStyle(color: palette.inkFullOpacity),
        // unselectedLabelStyle: TextStyle(color: palette.inkFullOpacity),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Wallete',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Back',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward),
            label: 'Next',
          ),
        ],
        // currentIndex: _calculateSelectedIndex(context),
        currentIndex: 0, // doesn't matter, currently just being used as links
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  // static int _calculateSelectedIndex(BuildContext context) {
  //   final String location = GoRouterState.of(context).location;

  //   if (location.startsWith('/play')) {
  //     return 0;
  //   }
  //   if (location.startsWith('/wallet')) {
  //     return 1;
  //   }
  //   if (location.startsWith('/beginning/1')) {
  //     return 2;
  //   }
  //   if (location.startsWith('/beginning/2')) {
  //     return 3;
  //   }
  //   return 0;
  // }

  void _onItemTapped(int index, BuildContext context) {
    final String location = GoRouterState.of(context).location;
    final locationPieces = location.split('/');
    final int pageNumber = int.parse(locationPieces.last);
    final prevPageNumber = pageNumber == 1 ? pageNumber : pageNumber - 1;
    final nextPageNumber = pageNumber + 1;

    final String nextLocation =
        locationPieces.sublist(0, locationPieces.length - 1).join('/');

    _log.info(
        'Current page number in story: $pageNumber, next: $nextLocation/${pageNumber + 1} prev: $nextLocation/${pageNumber - 1}');

    switch (index) {
      case 0:
        GoRouter.of(context).go('/play');
        break;
      case 1:
        GoRouter.of(context).go('/wallet/');
        break;
      case 2:
        GoRouter.of(context).go('$nextLocation/$prevPageNumber');
        break;
      case 3:
        GoRouter.of(context).go('$nextLocation/$nextPageNumber');
        break;
    }
  }
}
