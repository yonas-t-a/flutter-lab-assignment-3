import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'model/album.dart';
import 'ui/screens/album_list_screen.dart';
import 'ui/screens/album_detail_screen.dart';

/// App routes using GoRouter
final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AlbumListScreen(),
      routes: [
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            final album = state.extra as Album;
            return AlbumDetailScreen(album: album);
          },
        ),
      ],
    ),
  ],
);

/// Helper for navigation
class AlbumRoutes {
  static void goToDetail(BuildContext context, Album album) {
    GoRouter.of(context).go('/detail', extra: album);
  }
}
