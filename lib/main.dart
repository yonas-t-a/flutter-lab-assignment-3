import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'bloc/album_bloc.dart';
import 'repository/album_repository.dart';
import 'data_provider/album_api_provider.dart';
import 'routes.dart';

void main() {
  final apiProvider = AlbumApiProvider(client: http.Client());
  final repository = AlbumRepository(apiProvider: apiProvider);
  runApp(MyApp(repository: repository));
}

/// Root widget for the app, sets up BlocProvider and GoRouter.
class MyApp extends StatelessWidget {
  final AlbumRepository repository;
  const MyApp({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlbumBloc(repository: repository)..add(FetchAlbums()),
      child: MaterialApp.router(
        title: 'Albums App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
