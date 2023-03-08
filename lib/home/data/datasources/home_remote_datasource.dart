import 'package:storyways/home/data/models/book.dart';
import 'package:storyways/home/data/models/home_data.dart';

abstract class HomeRemoteDataSource {
  Future<HomeData> getHomeData();
  Future<List<Book>> searchForBook(String bookName);
}

class MockHomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<List<Book>> searchForBook(String bookName) => Future.delayed(
        const Duration(milliseconds: 500),
        () => List.generate(
          10,
          (index) => Book(
            id: index,
            name: '$bookName $index',
            author: 'Author $index',
            coverImage: 'https://picsum.photos/300/300',
            publishedDate: DateTime.now(),
          ),
        ),
      );

  @override
  Future<HomeData> getHomeData() {
    final books = List.generate(
      10,
      (index) => Book(
        id: index,
        name: 'Book $index',
        author: 'Author $index',
        coverImage: 'https://picsum.photos/300/300',
        publishedDate: DateTime.now(),
      ),
    );
    return Future.delayed(
      const Duration(seconds: 2),
      () => HomeData(
        newBooks: books,
        continueBooks: books,
      ),
    );
  }
}
