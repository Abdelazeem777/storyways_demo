import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
          title: const Text('Home'),
        ),
        body: _buildBody(),
        bottomNavigationBar: _buildNavBar(),
      ),
    );
  }

  Widget _buildNavBar() {
    return const GNav(
      tabs: [
        GButton(
          icon: Icons.home,
          text: 'Home',
        ),
        GButton(
          icon: Icons.search,
          text: 'Search',
        ),
        GButton(
          icon: Icons.book,
          text: 'Library',
        ),
        GButton(
          icon: Icons.person,
          text: 'Profile',
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.isLoading) {
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
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (_, index) => _ContinueBookItem(book: list[index]),
      ),
    );
  }

  Widget _buildNewBooks(List<Book> list) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
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
                  child: ClipOval(
                    child: CachedNetworkImage(imageUrl: book.coverImage!),
                  ),
                ),
              Text(
                book.name,
              ),
              Text(book.author),
            ],
          ),
        ),
        onTap: () => print('ContinueBookItem'),
      ),
    );
  }
}

class _NewBookItem extends StatelessWidget {
  const _NewBookItem({
    super.key,
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          if (book.coverImage?.isNotEmpty == true)
            Image.network(book.coverImage!),
          Text(book.name),
          Text(book.author),
        ],
      ),
    );
  }
}
