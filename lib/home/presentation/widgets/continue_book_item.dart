import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/models/book.dart';

class ContinueBookItem extends StatelessWidget {
  const ContinueBookItem({
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
