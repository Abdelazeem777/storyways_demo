import 'package:storyways/home/data/datasources/home_remote_datasource.dart';
import 'package:storyways/home/data/models/book.dart';
import 'package:storyways/home/data/models/home_data.dart';

abstract class HomeRepository {
  Future<HomeData> getHomeData();
  Future<List<Book>> searchForBook(String bookName);
}

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(HomeRemoteDataSource remoteDataSource)
      : _remoteDataSource = remoteDataSource;

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<HomeData> getHomeData() => _remoteDataSource.getHomeData();

  @override
  Future<List<Book>> searchForBook(String bookName) =>
      _remoteDataSource.searchForBook(bookName);
}
