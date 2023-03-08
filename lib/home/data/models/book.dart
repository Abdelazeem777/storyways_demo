// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Book {
  final int id;
  final String name;
  final String author;
  final String? coverImage;
  final DateTime? publishedDate;
  Book({
    required this.id,
    required this.name,
    required this.author,
    this.coverImage,
    this.publishedDate,
  });

  Book copyWith({
    int? id,
    String? name,
    String? author,
    String? coverImage,
    DateTime? publishedDate,
  }) {
    return Book(
      id: id ?? this.id,
      name: name ?? this.name,
      author: author ?? this.author,
      coverImage: coverImage ?? this.coverImage,
      publishedDate: publishedDate ?? this.publishedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'author': author,
      'coverImage': coverImage,
      'publishedDate': publishedDate?.millisecondsSinceEpoch,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as int,
      name: map['name'] as String,
      author: map['author'] as String,
      coverImage:
          map['coverImage'] != null ? map['coverImage'] as String : null,
      publishedDate: map['publishedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['publishedDate'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) =>
      Book.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Book(id: $id, name: $name, author: $author, coverImage: $coverImage, publishedDate: $publishedDate)';
  }

  @override
  bool operator ==(covariant Book other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.author == author &&
        other.coverImage == coverImage &&
        other.publishedDate == publishedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        author.hashCode ^
        coverImage.hashCode ^
        publishedDate.hashCode;
  }
}
