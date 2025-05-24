import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/album_bloc.dart';
import '../widgets/album_card.dart';
import '../../model/album.dart';

/// Screen displaying a list of albums in a stylish list.
class AlbumListScreen extends StatelessWidget {
  const AlbumListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Albums')),
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          if (state is! AlbumLoaded &&
              state is! AlbumLoading &&
              state is! AlbumError) {
            context.read<AlbumBloc>().add(FetchAlbums());
          }
          if (state is AlbumLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumError) {
            return Center(
              child: Card(
                margin: const EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed:
                            () => context.read<AlbumBloc>().add(RetryFetch()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is AlbumLoaded) {
            final albums = state.albums;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: albums.length,
              itemBuilder: (context, index) {
                return AlbumCard(album: albums[index]);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
