import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';

import 'package:storyways/home/data/datasources/home_remote_datasource.dart';
import 'package:storyways/home/data/models/book.dart';
import 'package:storyways/home/data/respository/home_repository.dart';
import 'package:storyways/home/presentation/pages/home_bloc/home_bloc.dart';
import 'package:storyways/style/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeBloc(HomeRepositoryImpl(MockHomeRemoteDataSourceImpl()))
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
                  color: AppColors.primaryColor),
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
        itemBuilder: (_, index) => _ContinueBookItem(book: list[index]),
      ),
    );
  }

  Widget _buildNewBooks(List<Book> list) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      separatorBuilder: (_, index) => const Divider(thickness: 2.0),
      itemBuilder: (_, index) => _NewBookItem(book: list[index]),
    );
  }
}

class _ContinueBookItem extends StatelessWidget {
  const _ContinueBookItem({
    super.key,
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: SizedBox(
          width: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (book.coverImage?.isNotEmpty == true)
                AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(imageUrl: book.coverImage!),
                      ),
                      _buildPlayIcon(),
                    ],
                  ),
                ),
              Text(
                book.name,
                style: Theme.of(context).textTheme.headline2,
              ),
              Text(
                book.author,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
        onTap: () => print('ContinueBookItem'),
      ),
    );
  }

  Widget _buildPlayIcon() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: SvgPicture.asset('lib/images/play_icon.svg'),
    );
  }
}

class _NewBookItem extends StatelessWidget {
  const _NewBookItem({
    super.key,
    required this.book,
    this.hideNotificationIcon = false,
  });

  final Book book;
  final bool hideNotificationIcon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: 100,
        child: Row(
          children: [
            if (book.coverImage?.isNotEmpty == true) _buildBookCoverImage(),
            const SizedBox(width: 12.0),
            Expanded(child: _buildBookInfo(context)),
            const SizedBox(width: 12.0),
            if (!hideNotificationIcon) _buildNotificationIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCoverImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.network(
        book.coverImage!,
        width: 75,
        height: 100,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildBookInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.name,
          style: Theme.of(context).textTheme.headline2,
        ),
        Text(
          book.author,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 8.0),
        if (book.publishedDate != null) _buildPublishedDate()
      ],
    );
  }

  Widget _buildPublishedDate() {
    final formattedDate = DateFormat('dd MMM yyyy').format(book.publishedDate!);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('lib/images/calendar_icon.svg'),
        const SizedBox(width: 4.0),
        Text(formattedDate),
      ],
    );
  }

  Widget _buildNotificationIcon() {
    return SvgPicture.asset('lib/images/notification_icon.svg');
  }
}

class _SearchAppBar extends StatelessWidget {
  const _SearchAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    OverlayEntry? overlayEntry;
    final overlayState = Overlay.of(context);
    final size = MediaQuery.of(context).size;
    final homeBloc = context.read<HomeBloc>();

    return SizedBox(
      width: size.width - 16.0,
      height: 50,
      child: TextField(
        onChanged: (text) {
          if (text.isNotEmpty == true && overlayEntry == null) {
            overlayState.insert(overlayEntry ??= _createOverlayEntry(context));
          } else if (text.isNotEmpty != true && overlayEntry != null) {
            overlayEntry?.remove();
            overlayEntry = null;
          }
          homeBloc.add(
            HomeEvent(status: HomeEventStatus.search, searchText: text),
          );
        },
        decoration: InputDecoration(
          hintText: 'Search for something',
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(left: 15.0, top: 15.0),
          suffixIcon: const Icon(
            Icons.search,
            color: Colors.grey,
            size: 30.0,
          ),
          prefixIcon: InkWell(
            child: const Icon(
              Icons.close,
              color: Colors.grey,
              size: 30.0,
            ),
            onTap: () {
              overlayEntry?.remove();
              overlayEntry = null;
            },
          ),
        ),
        style: const TextStyle(color: Colors.black, fontSize: 16.0),
      ),
    );
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (_) => BlocProvider.value(
        value: context.read<HomeBloc>(),
        child: Positioned(
          top: 110,
          left: 0,
          right: 0,
          child: Material(
            elevation: 6.0,
            child: _buildSearchResult(),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResult() {
    return BlocSelector<HomeBloc, HomeState, List<Book>?>(
      selector: (state) => state.searchedBooks,
      builder: (_, books) {
        if (books?.isNotEmpty == true) {
          return ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.separated(
              itemCount: books!.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(16.0),
              separatorBuilder: (_, index) => const Divider(thickness: 2.0),
              itemBuilder: (_, index) =>
                  _NewBookItem(book: books[index], hideNotificationIcon: true),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
