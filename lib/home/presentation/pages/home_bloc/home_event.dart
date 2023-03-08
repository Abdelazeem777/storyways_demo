part of 'home_bloc.dart';

enum HomeEventStatus {
  initial,
  search,
}

extension on HomeEvent {
  bool get isInitial => status == HomeEventStatus.initial;
  bool get isSearch => status == HomeEventStatus.search;
}

@immutable
class HomeEvent {
  final HomeEventStatus status;
  final String? searchText;

  const HomeEvent({
    required this.status,
    this.searchText,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other.runtimeType == runtimeType &&
        (other as HomeEvent).status == status &&
        other.searchText == searchText;
  }

  @override
  int get hashCode => status.hashCode ^ searchText.hashCode;

  HomeEvent copyWith({
    HomeEventStatus? status,
    String? searchText,
  }) {
    return HomeEvent(
      status: status ?? this.status,
      searchText: searchText ?? this.searchText,
    );
  }
}
