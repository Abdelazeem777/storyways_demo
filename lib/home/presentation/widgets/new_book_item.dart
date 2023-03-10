import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:storyways/home/data/models/book.dart';

class NewBookItem extends StatelessWidget {
  const NewBookItem({
    super.key,
    required this.book,
    this.hideNotificationIcon = false,
  });

  final Book book;
  final bool hideNotificationIcon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => print('NewBookItem'),
      child: Padding(
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
      ),
    );
  }

  Widget _buildBookCoverImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: CachedNetworkImage(
        imageUrl: book.coverImage!,
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
