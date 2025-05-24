import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/album.dart';
import '../model/photo.dart';

/// Data provider responsible for fetching albums and photos from the remote API.
/// Uses in-memory caching for session efficiency.
class AlbumApiProvider {
  final http.Client client;
  List<Album>? _cachedAlbums;
  final Map<int, List<Photo>> _photosCache = {};

  AlbumApiProvider({required this.client});

  Future<List<Album>> fetchAlbums() async {
    if (_cachedAlbums != null) return _cachedAlbums!;
    try {
      final albumsRes = await client.get(
        Uri.parse('https://jsonplaceholder.typicode.com/albums'),
      );
      if (albumsRes.statusCode != 200) throw Exception('Failed to load albums');
      final List albumsJson = json.decode(albumsRes.body);
      final List<Album> albums = [];
      for (final albumJson in albumsJson) {
        final albumId = albumJson['id'];
        final photoRes = await client.get(
          Uri.parse(
            'https://jsonplaceholder.typicode.com/photos?albumId=$albumId&_limit=1',
          ),
        );
        String? thumbUrl;
        String? url;
        if (photoRes.statusCode == 200) {
          final List photosJson = json.decode(photoRes.body);
          if (photosJson.isNotEmpty) {
            thumbUrl = photosJson[0]['thumbnailUrl'];
            url = photosJson[0]['url'];
          }
        }
        albums.add(
          Album.fromJson({...albumJson, 'thumbnailUrl': thumbUrl, 'url': url}),
        );
      }
      _cachedAlbums = albums;
      return albums;
    } catch (e) {
      throw Exception('Failed to fetch albums: $e');
    }
  }

  Future<List<Photo>> fetchPhotosForAlbum(int albumId) async {
    if (_photosCache.containsKey(albumId)) return _photosCache[albumId]!;
    try {
      final res = await client.get(
        Uri.parse(
          'https://jsonplaceholder.typicode.com/photos?albumId=$albumId',
        ),
      );
      if (res.statusCode != 200) throw Exception('Failed to load photos');
      final List photosJson = json.decode(res.body);
      final photos = photosJson.map((json) => Photo.fromJson(json)).toList();
      _photosCache[albumId] = List<Photo>.from(photos);
      return _photosCache[albumId]!;
    } catch (e) {
      throw Exception('Failed to fetch photos: $e');
    }
  }

  void clearCache() {
    _cachedAlbums = null;
    _photosCache.clear();
  }
}
