import 'dart:io';

import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    required this.image,
    this.imageFile,
    this.isShowPhotoUpload = false,
    this.imageUploadBtnPress,
  });

  final String image;
  final File? imageFile;
  final bool isShowPhotoUpload;
  final VoidCallback? imageUploadBtnPress;

  ImageProvider get _imageProvider {
    if (imageFile != null) {
      return FileImage(imageFile!);
    }
    if (image.isNotEmpty) {
      return NetworkImage(image);
    }
    return const AssetImage('assets/images/avatar_placeholder.png');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.08),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: _imageProvider,
          ),
          if (isShowPhotoUpload)
            InkWell(
              onTap: imageUploadBtnPress,
              child: CircleAvatar(
                radius: 13,
                backgroundColor: Color.fromRGBO(135, 118, 78, 1),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}