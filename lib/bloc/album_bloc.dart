import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/album_repository.dart';
import '../model/album.dart';
import '../model/photo.dart';

/// Bloc Events
abstract class AlbumEvent {}

class FetchAlbums extends AlbumEvent {}

class RetryFetch extends AlbumEvent {}

class FetchAlbumPhotos extends AlbumEvent {
  final int albumId;
  FetchAlbumPhotos(this.albumId);
}

/// Bloc States
abstract class AlbumState {}

class AlbumLoading extends AlbumState {}

class AlbumLoaded extends AlbumState {
  final List<Album> albums;
  AlbumLoaded(this.albums);
}

class AlbumError extends AlbumState {
  final String message;
  AlbumError(this.message);
}

class AlbumPhotosLoading extends AlbumState {}

class AlbumPhotosLoaded extends AlbumState {
  final List<Photo> photos;
  AlbumPhotosLoaded(this.photos);
}

class AlbumPhotosError extends AlbumState {
  final String message;
  AlbumPhotosError(this.message);
}

/// Bloc for managing album fetching and state
class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository repository;
  AlbumBloc({required this.repository}) : super(AlbumLoading()) {
    on<FetchAlbums>((event, emit) async {
      emit(AlbumLoading());
      try {
        final albums = await repository.getAlbums();
        emit(AlbumLoaded(albums));
      } catch (e) {
        emit(AlbumError(e.toString()));
      }
    });
    on<RetryFetch>((event, emit) async {
      repository.clearCache();
      add(FetchAlbums());
    });
    on<FetchAlbumPhotos>((event, emit) async {
      emit(AlbumPhotosLoading());
      try {
        final photos = await repository.getPhotosForAlbum(event.albumId);
        emit(AlbumPhotosLoaded(photos));
      } catch (e) {
        emit(AlbumPhotosError(e.toString()));
      }
    });
  }
}
