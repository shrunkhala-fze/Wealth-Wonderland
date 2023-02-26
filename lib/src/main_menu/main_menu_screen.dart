// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../games_services/games_services.dart';
import '../settings/settings.dart';
import '../style/delayed_appear.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import '../style/rough/button.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final gamesServicesController = context.watch<GamesServicesController?>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return Scaffold(
      backgroundColor: palette.gray,
      body: ResponsiveScreen(
        mainAreaProminence: 0.45,
        squarishMainArea: DelayedAppear(
          ms: 1000,
          child: const Center(
            child: Text(
              'Wealth Wonderland',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 55,
                height: 1,
              ),
            ),
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DelayedAppear(
              ms: 800,
              child: RoughButton(
                onTap: () {
                  audioController.playSfx(SfxType.buttonTap);
                  GoRouter.of(context).go('/play');
                },
                drawRectangle: true,
                textColor: palette.red,
                fontSize: 42,
                soundEffect: SfxType.erase,
                child: const Text('Play'),
              ),
            ),
            _gap,
            // if (gamesServicesController != null) ...[
            //   _hideUntilReady(
            //     ready: gamesServicesController.signedIn,
            //     // TODO: show an "active animation on the button"
            //     child: DelayedAppear(
            //       ms: 600,
            //       child: RoughButton(
            //         onTap: () => gamesServicesController.showAchievements(),
            //         child: const Text('Achievements'),
            //       ),
            //     ),
            //   ),
            //   _gap,
            //   _hideUntilReady(
            //     // TODO: show an "active animation on the button"
            //     ready: gamesServicesController.signedIn,
            //     child: DelayedAppear(
            //       ms: 400,
            //       child: RoughButton(
            //         onTap: () => gamesServicesController.showLeaderboard(),
            //         child: const Text('Leaderboard'),
            //       ),
            //     ),
            //   ),
            //   _gap,
            // ],
            DelayedAppear(
              ms: 600,
              child: RoughButton(
                onTap: () {
                  audioController.playSfx(SfxType.buttonTap);
                  // GoRouter.of(context).go('/play');
                },
                // drawRectangle: true,
                textColor: palette.trueWhite,
                fontSize: 42,
                soundEffect: SfxType.erase,
                child: const Text('Achievements'),
              ),
            ),

            DelayedAppear(
              ms: 400,
              child: RoughButton(
                onTap: () {
                  audioController.playSfx(SfxType.buttonTap);
                  // GoRouter.of(context).go('/play');
                },
                // drawRectangle: true,
                textColor: palette.trueWhite,
                fontSize: 42,
                soundEffect: SfxType.erase,
                child: const Text('Leaderboards'),
              ),
            ),
            _gap,
            DelayedAppear(
              ms: 200,
              child: RoughButton(
                onTap: () => GoRouter.of(context).push('/settings'),
                child: const Text('Settings'),
              ),
            ),
            _gap,
            const Padding(
              padding: EdgeInsets.only(top: 32),
              // child: ValueListenableBuilder<bool>(
              //   valueListenable: settingsController.muted,
              //   builder: (context, muted, child) {
              //     return IconButton(
              //       onPressed: () => settingsController.toggleMuted(),
              //       icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
              //     );
              // },
              // ),
              child: SizedBox(height: 5),
            ),
            _gap,
            const Text('By Clueless Coders'),
            _gap,
          ],
        ),
      ),
    );
  }

  /// Prevents the game from showing game-services-related menu items
  /// until we're sure the player is signed in.
  ///
  /// This normally happens immediately after game start, so players will not
  /// see any flash. The exception is folks who decline to use Game Center
  /// or Google Play Game Services, or who haven't yet set it up.
  // Widget _hideUntilReady({required Widget child, required Future<bool> ready}) {
  //   return FutureBuilder<bool>(
  //     future: ready,
  //     builder: (context, snapshot) {
  //       // Use Visibility here so that we have the space for the buttons
  //       // ready.
  //       return Visibility(
  //         visible: snapshot.data ?? false,
  //         maintainState: true,
  //         maintainSize: true,
  //         maintainAnimation: true,
  //         child: child,
  //       );
  //     },
  //   );
  // }
  Widget _hideUntilReady({required Widget child, required Future<bool> ready}) {
    return FutureBuilder<bool>(
      future: ready,
      builder: (context, snapshot) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 700),
          opacity: snapshot.hasData ? 1 : 0,
          child: child,
        );
      },
    );
  }

  static const _gap = SizedBox(height: 10);
}
