import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:storyways/di/injector.dart';

import 'package:storyways/home/data/datasources/home_remote_datasource.dart';
import 'package:storyways/home/data/models/book.dart';
import 'package:storyways/home/data/respository/home_repository.dart';
import 'package:storyways/home/presentation/pages/home_bloc/home_bloc.dart';
import 'package:storyways/style/app_colors.dart';

import 'package:storyways/home/presentation/widgets/continue_book_item.dart';
import 'package:storyways/home/presentation/widgets/new_book_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Injector().homeBloc
        ..add(const HomeEvent(status: HomeEventStatus.initial)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: const [_SearchAppBar()],
        ),
        body: _buildBody(),
        bottomNavigationBar: _buildNavBar(),
      ),
    );
  }

  Widget _buildNavBar() {
    return GNav(
      activeColor: Colors.black,
      iconSize: 24,
      duration: const Duration(milliseconds: 400),
      tabBackgroundColor: Colors.white,
      backgroundColor: Colors.grey[200]!,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      color: AppColors.primaryColor,
      tabMargin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 32.0),
      tabs: const [
        GButton(
          icon: Icons.home,
          text: 'Home',
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        GButton(
          icon: Icons.search,
          text: 'Search',
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        GButton(
          icon: Icons.book,
          text: 'Library',
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        GButton(
          icon: Icons.person,
          text: 'Profile',
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.isLoading || state.isInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        final continueBooks = state.homeData?.continueBooks;
        final newBooks = state.homeData?.newBooks;

        final continueBooksIsEmpty = continueBooks?.isNotEmpty != true;
        final newBooksIsEmpty = newBooks?.isNotEmpty != true;

        if (continueBooksIsEmpty && newBooksIsEmpty) {
          return const Center(child: Text('Empty'));
        }

        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              'Continue',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 8.0),
            if (!continueBooksIsEmpty) _buildContinueBooks(continueBooks!),
            const SizedBox(height: 16.0),
            const Text(
              'New',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 8.0),
            if (!newBooksIsEmpty) _buildNewBooks(newBooks!),
          ],
        );
      },
    );
  }

  Widget _buildContinueBooks(List<Book> list) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (_, index) => ContinueBookItem(book: list[index]),
      ),
    );
  }

  Widget _buildNewBooks(List<Book> list) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      separatorBuilder: (_, index) => const Divider(thickness: 2.0),
      itemBuilder: (_, index) => NewBookItem(book: list[index]),
    );
  }
}

class _SearchAppBar extends StatefulWidget {
  const _SearchAppBar({super.key});

  @override
  State<_SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<_SearchAppBar> {
  OverlayEntry? overlayEntry;

  @override
  Widget build(BuildContext context) {
    final overlayState = Overlay.of(context);
    final size = MediaQuery.of(context).size;
    final homeBloc = context.read<HomeBloc>();

    return SizedBox(
      width: size.width - 16.0,
      height: 60,
      child: TextField(
        onChanged: (text) {
          if (text.isNotEmpty == true && overlayEntry == null) {
            overlayState.insert(overlayEntry ??=
                _createOverlayEntry(context, screenHeight: size.height));
          } else if (text.isNotEmpty != true && overlayEntry != null) {
            _closeOverlay();
          }
          homeBloc.add(
            HomeEvent(status: HomeEventStatus.search, searchText: text),
          );
        },
        decoration: const InputDecoration(
          hintText: 'Search for something',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
          suffixIcon: Icon(
            Icons.search,
            color: Colors.grey,
            size: 30.0,
          ),
        ),
        style: const TextStyle(color: Colors.black, fontSize: 16.0),
      ),
    );
  }

  OverlayEntry _createOverlayEntry(
    BuildContext context, {
    required double screenHeight,
  }) {
    return OverlayEntry(
      builder: (_) => BlocProvider.value(
        value: context.read<HomeBloc>(),
        child: Positioned(
          top: 120,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: _closeOverlay,
            child: SizedBox(
              height: screenHeight - 120,
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Colors.black12),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: Material(
                      elevation: 6.0,
                      child: _buildSearchResult(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _closeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  Widget _buildSearchResult() {
    return BlocSelector<HomeBloc, HomeState, List<Book>?>(
      selector: (state) => state.searchedBooks,
      builder: (_, books) {
        if (books?.isNotEmpty == true) {
          return ListView.separated(
            itemCount: books!.length,
            shrinkWrap: true,
            padding: const EdgeInsets.all(16.0),
            separatorBuilder: (_, index) => const Divider(thickness: 2.0),
            itemBuilder: (_, index) =>
                NewBookItem(book: books[index], hideNotificationIcon: true),
          );
        }
        return const SizedBox();
      },
    );
  }
}
