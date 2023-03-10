import 'package:storyways/home/data/datasources/home_remote_datasource.dart';
import 'package:storyways/home/data/respository/home_repository.dart';
import 'package:storyways/home/presentation/pages/home_bloc/home_bloc.dart';

///Implementing
///
///`Singleton` design pattern
///
///`Flyweight` design pattern
///
///to save specific objects from recreation
class Injector {
  final _flyweightMap = <String, dynamic>{};
  static final _singleton = Injector._internal();

  Injector._internal();
  factory Injector() => _singleton;

  //===================[SPLASH_CUBIT]===================
  HomeBloc get homeBloc => HomeBloc(homeRepository);

  HomeRepository get homeRepository => HomeRepositoryImpl(homeRemoteDataSource);

  HomeRemoteDataSource get homeRemoteDataSource =>
      MockHomeRemoteDataSourceImpl();
}
