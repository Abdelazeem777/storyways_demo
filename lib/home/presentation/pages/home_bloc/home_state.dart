part of 'home_bloc.dart';

enum HomeStateStatus {
  initial,
  loading,
  loaded,
  searching,
  error,
}

extension HomeStateX on HomeState {
  bool get isInitial => status == HomeStateStatus.initial;
  bool get isLoading => status == HomeStateStatus.loading;
  bool get isSearching => status == HomeStateStatus.searching;
  bool get isLoaded => status == HomeStateStatus.loaded;
  bool get isError => status == HomeStateStatus.error;
}

@immutable
class HomeState {
  final HomeStateStatus status;
  final String? errorMessage;
  final HomeData? homeData;
  final List<Book>? searchedBooks;

  const HomeState({
    this.status = HomeStateStatus.initial,
    this.errorMessage,
    this.homeData,
    this.searchedBooks,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeState &&
        other.status == status &&
        other.errorMessage == errorMessage &&
        other.homeData == homeData &&
        other.searchedBooks == searchedBooks;
  }

  @override
  int get hashCode =>
      status.hashCode ^
      errorMessage.hashCode ^
      homeData.hashCode ^
      searchedBooks.hashCode;

  HomeState copyWith({
    HomeStateStatus? status,
    String? errorMessage,
    HomeData? homeData,
    List<Book>? searchedBooks,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      homeData: homeData ?? this.homeData,
      searchedBooks: searchedBooks ?? this.searchedBooks,
    );
  }
}
