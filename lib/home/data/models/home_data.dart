// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:storyways/home/data/models/book.dart';

class HomeData {
  final List<Book> newBooks;
  final List<Book> continueBooks;
  HomeData({
    required this.newBooks,
    required this.continueBooks,
  });

  HomeData copyWith({
    List<Book>? newBooks,
    List<Book>? continueBooks,
  }) {
    return HomeData(
      newBooks: newBooks ?? this.newBooks,
      continueBooks: continueBooks ?? this.continueBooks,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'newBooks': newBooks.map((x) => x.toMap()).toList(),
      'continueBooks': continueBooks.map((x) => x.toMap()).toList(),
    };
  }

  factory HomeData.fromMap(Map<String, dynamic> map) {
    return HomeData(
      newBooks: List<Book>.from(
        (map['newBooks'] as List<int>).map<Book>(
          (x) => Book.fromMap(x as Map<String, dynamic>),
        ),
      ),
      continueBooks: List<Book>.from(
        (map['continueBooks'] as List<int>).map<Book>(
          (x) => Book.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeData.fromJson(String source) =>
      HomeData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'HomeData(newBooks: $newBooks, continueBooks: $continueBooks)';

  @override
  bool operator ==(covariant HomeData other) {
    if (identical(this, other)) return true;

    return listEquals(other.newBooks, newBooks) &&
        listEquals(other.continueBooks, continueBooks);
  }

  @override
  int get hashCode => newBooks.hashCode ^ continueBooks.hashCode;
}
