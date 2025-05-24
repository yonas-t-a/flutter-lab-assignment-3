import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/album.dart';
import '../../bloc/album_bloc.dart';
import '../../model/photo.dart';

/// Screen displaying details for a single album, including all its photos.
class AlbumDetailScreen extends StatelessWidget {
  final Album album;
  const AlbumDetailScreen({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          if (album.url != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                album.url!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 64),
                    ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  album.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text('Album ID: ${album.id}'),
                Text('User ID: ${album.userId}'),
              ],
            ),
          ),
          BlocBuilder<AlbumBloc, AlbumState>(
            buildWhen:
                (prev, curr) =>
                    curr is AlbumPhotosLoading ||
                    curr is AlbumPhotosLoaded ||
                    curr is AlbumPhotosError,
            builder: (context, state) {
              if (state is! AlbumPhotosLoaded && state is! AlbumPhotosError) {
                // Trigger fetch if not already loaded or errored
                context.read<AlbumBloc>().add(FetchAlbumPhotos(album.id));
              }
              if (state is AlbumPhotosLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is AlbumPhotosError) {
                return Center(
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
                              () => context.read<AlbumBloc>().add(
                                FetchAlbumPhotos(album.id),
                              ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is AlbumPhotosLoaded) {
                final List<Photo> photos = state.photos;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      final photo = photos[index];
                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              photo.thumbnailUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image),
                                  ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            photo.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
