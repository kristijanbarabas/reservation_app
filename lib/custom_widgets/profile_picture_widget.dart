import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:reservation_app/services/constants.dart';

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget(
      {Key? key,
      required this.profilePicture,
      required this.imageHeight,
      required this.imageWidth})
      : super(key: key);

  final String profilePicture;
  final double imageHeight;
  final double imageWidth;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        key: UniqueKey(),
        imageUrl: profilePicture,
        height: imageHeight,
        width: imageWidth,
        maxHeightDiskCache: 300,
        maxWidthDiskCache: 300,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
            color: kBackgroundColor,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.warning,
          color: Colors.red,
          size: 50,
        ),
      ),
    );
  }
}
