import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rcadminapp/models/user_profile.dart';
import 'package:rcadminapp/utils/profile_pic_update.dart';
import 'package:rcadminapp/widgets/edit_profile_form.dart';
import 'package:rcadminapp/widgets/profile_pic.dart';
import 'package:rcadminapp/widgets/rca_header_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _selectedImage;
  bool _imageDeleted = false;
  TextEditingController? _birthDateController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_birthDateController == null) {
      final user =
          ModalRoute.of(context)!.settings.arguments as UserProfileModel;
      _birthDateController = TextEditingController(
        text:
            '${user.birth.day.toString().padLeft(2, '0')}/${user.birth.month.toString().padLeft(2, '0')}/${user.birth.year}',
      );
    }
  }

  @override
  void dispose() {
    _birthDateController?.dispose();
    super.dispose();
  }

  Future<void> profilePicUpdate() async {
    await ProfilePicUpdate.execute(
      context: context,
      onImageSelected: (image) {
        setState(() {
          _selectedImage = image;
          _imageDeleted = false;
        });
      },
      onImageDeleted: () {
        setState(() {
          _selectedImage = null;
          _imageDeleted = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Recupera o objeto user passado via arguments
    final user = ModalRoute.of(context)!.settings.arguments as UserProfileModel;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: RcaHeaderBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(95, 120, 138, 0.5),
              Color.fromRGBO(36, 59, 85, 0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 5,
              margin: EdgeInsets.only(top: 150, bottom: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ProfilePic(
                      image: _imageDeleted ? '' : user.imageUrl,
                      imageFile:
                          _selectedImage, // Passa a imagem local se existir
                      isShowPhotoUpload: true,
                      imageUploadBtnPress: profilePicUpdate,
                    ),
                    const Divider(),
                    EditProfileForm(user: user),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
