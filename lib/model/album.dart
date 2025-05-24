/// Album model representing an album and its first photo (if available).
/// See model/photo.dart for the Photo model.
class Album {
  final int id;
  final int userId;
  final String title;
  final String? thumbnailUrl;
  final String? url;

  Album({
    required this.id,
    required this.userId,
    required this.title,
    this.thumbnailUrl,
    this.url,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    id: json['id'] as int,
    userId: json['userId'] as int,
    title: json['title'] as String,
    thumbnailUrl: json['thumbnailUrl'] as String?,
    url: json['url'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'thumbnailUrl': thumbnailUrl,
    'url': url,
  };
}
