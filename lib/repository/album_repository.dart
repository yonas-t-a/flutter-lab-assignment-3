import '../data_provider/album_api_provider.dart';
import '../model/album.dart';
import '../model/photo.dart';

/// Repository layer that abstracts data access for albums and photos.
/// Handles caching and error propagation.
class AlbumRepository {
  final AlbumApiProvider apiProvider;
  List<Album>? _cache;
  final Map<int, List<Photo>> _photosCache = {};

  AlbumRepository({required this.apiProvider});

  Future<List<Album>> getAlbums() async {
    if (_cache != null) return _cache!;
    try {
      final albums = await apiProvider.fetchAlbums();
      _cache = albums;
      return albums;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Photo>> getPhotosForAlbum(int albumId) async {
    if (_photosCache.containsKey(albumId)) return _photosCache[albumId]!;
    try {
      final photos = await apiProvider.fetchPhotosForAlbum(albumId);
      _photosCache[albumId] = photos;
      return photos;
    } catch (e) {
      rethrow;
    }
  }

  void clearCache() {
    _cache = null;
    _photosCache.clear();
    apiProvider.clearCache();
  }
}
