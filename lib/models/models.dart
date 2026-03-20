class CurlType {
  final String id;
  final int category;
  final String title;
  final String desc;
  final String emoji;
  final List<String> tips;

  const CurlType({
    required this.id, required this.category, required this.title,
    required this.desc, required this.emoji, required this.tips,
  });
}

class Product {
  final int id;
  final String category;
  final String name;
  final String brand;
  final String price;
  final double rating;
  final int reviewCount;
  final List<String> types;
  final String img;
  final String desc;
  final List<String> tags;
  final String? imageUrl;

  const Product({
    required this.id, required this.category, required this.name,
    required this.brand, required this.price, required this.rating,
    required this.reviewCount, required this.types, required this.img,
    required this.desc, required this.tags, this.imageUrl,
  });
}

class CommunityPost {
  final int id;
  final String author;
  final String avatar;
  final String curlType;
  final String time;
  final String title;
  final String content;
  int likes;
  final int comments;
  final List<String> tags;
  final bool hasImage;
  final String postType; // notice | guide | salon | tip | product | help
  final bool isPinned;
  final String? imageUrl;

  CommunityPost({
    required this.id, required this.author, required this.avatar,
    required this.curlType, required this.time, required this.title,
    required this.content, required this.likes, required this.comments,
    required this.tags, required this.hasImage,
    this.postType = 'tip', this.isPinned = false, this.imageUrl,
  });
}

class DiaryEntry {
  final int id;
  final DateTime date;
  final List<String> routine;
  final int result;
  final String memo;
  final List<String> tags;
  final bool hasPhoto;
  final String? imageUrl;

  DiaryEntry({
    required this.id, required this.date, required this.routine,
    required this.result, required this.memo, required this.tags,
    this.hasPhoto = false, this.imageUrl,
  });
}
