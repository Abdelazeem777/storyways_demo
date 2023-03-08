import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:storyways/home/data/models/book.dart';
import 'package:storyways/home/data/models/home_data.dart';
import 'package:storyways/home/data/respository/home_repository.dart';

part 'home_state.dart';
part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._homeRepository) : super(const HomeState()) {
    on<HomeEvent>(
      (event, emit) async {
        if (event.isInitial) {
          return await _loadHomeData(emit);
        }
        if (event.isSearch) {
          return await _searchForBooks(
            emit,
            searchText: event.searchText,
          );
        }
      },
      transformer: (books, mapper) => books
          .where(
            (event) =>
                event.searchText?.isNotEmpty != true ||
                event.searchText!.length >= 2,
          )
          .debounceTime(const Duration(milliseconds: 300))
          .distinct(
            (previous, next) => !next.isSearch ? false : previous == next,
          )
          .switchMap(mapper),
    );
  }

  final HomeRepository _homeRepository;

  Future<void> _loadHomeData(Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(status: HomeStateStatus.loading));
      final homeData = await _homeRepository.getHomeData();
      emit(
        state.copyWith(
          status: HomeStateStatus.loaded,
          homeData: homeData,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _searchForBooks(
    Emitter<HomeState> emit, {
    String? searchText,
  }) async {
    try {
      if (searchText?.trim().isNotEmpty != true) {
        return emit(
          const HomeState(status: HomeStateStatus.loaded),
        );
      }
      emit(state.copyWith(status: HomeStateStatus.searching));
      final searchedBooks =
          await _homeRepository.searchForBook(searchText!.trim());
      emit(
        state.copyWith(
          status: HomeStateStatus.loaded,
          searchedBooks: searchedBooks,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
