class Post {
  final String id; // id 필드 추가
  final String author;
  final String dateTime;
  final String title;
  final String content;
  final String timestamp;
  final String? imageUrl;


  Post({
    required this.id,
    required this.author,
    required this.dateTime,
    required this.title,
    required this.content,
    required this.timestamp,
    this.imageUrl,
  });
}