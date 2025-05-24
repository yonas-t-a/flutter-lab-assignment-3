import 'package:flutter/material.dart';
import '../../model/album.dart';
import '../../routes.dart';

/// Card widget for displaying album info in the list.
class AlbumCard extends StatelessWidget {
  final Album album;
  const AlbumCard({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: () => AlbumRoutes.goToDetail(context, album),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Card(
            elevation: 4,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  if (album.thumbnailUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        album.thumbnailUrl!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              width: 64,
                              height: 64,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image),
                            ),
                      ),
                    )
                  else
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.photo_album),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      album.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
