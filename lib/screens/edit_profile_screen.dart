import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rcadminapp/models/auth.dart';
import 'package:rcadminapp/models/user_profile.dart';
import 'package:rcadminapp/service/profile_service.dart';
import 'package:rcadminapp/widgets/profile_pic.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _selectedImage;
  bool _imageDeleted = false;

  Future<void> profilePicUpdate() async {
    try {
      final ImagePicker picker = ImagePicker();

      final dynamic source = await showModalBottomSheet<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galeria'),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Câmera'),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Remover imagem'),
                  onTap: () {
                    Navigator.of(context).pop('delete');
                  },
                )
              ],
            ),
          );
        },
      );

      if (source == null) return;

      final auth = Provider.of<Auth>(context, listen: false);

      if (source == 'delete') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removendo imagem...')),
        );

        await ProfileService().deleteProfileImage(auth);

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagem removida com sucesso!')),
        );
        setState(() {
          _selectedImage = null;
          _imageDeleted = true;
        });
        return;
      }

      final XFile? image = await picker.pickImage(source: source as ImageSource, imageQuality: 50);

      if (image == null) return;

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enviando imagem...')),
      );

      await ProfileService().uploadProfileImage(auth, File(image.path));

      if (!context.mounted) return;

      // Remove a mensagem de "Enviando..." para que a de sucesso apareça imediatamente
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagem atualizada com sucesso!')),
      );
      // Só atualiza a UI se a linha de cima (upload) funcionar sem erros
      setState(() {
        _selectedImage = File(image.path);
        _imageDeleted = false;
      });

    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Recupera o objeto user passado via arguments
    final user = ModalRoute.of(context)!.settings.arguments as UserProfileModel;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'rc@dmin app',
          style: TextStyle(color: Color.fromRGBO(135, 118, 78, 1)),
        ),
        elevation: 5,
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        foregroundColor: Colors.black,
        shadowColor: Colors.black,
        toolbarHeight: 72,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings_outlined,
              color: Color.fromRGBO(135, 118, 78, 1),
            ),
          ),
        ],
      ),
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
      margin: EdgeInsets.only(top: 150,bottom: 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ProfilePic(
                      image: _imageDeleted ? '' : user.imageUrl,
                      imageFile: _selectedImage, // Passa a imagem local se existir
                      isShowPhotoUpload: true,
                      imageUploadBtnPress: profilePicUpdate,
                    ),
                    const Divider(),
                    Form(
                      child: Column(
                        children: [
                          UserInfoEditField(
                            text: "Name",
                            child: TextFormField(
                              initialValue: user.socialName,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFF00BF6D).withValues(alpha: 0.05),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5,
                                  vertical: 16.0,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                              ),
                            ),
                          ),
                          UserInfoEditField(
                            text: "Email",
                            child: TextFormField(
                              initialValue: user.email,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFF00BF6D).withValues(alpha: 0.05),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5,
                                  vertical: 16.0,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                              ),
                            ),
                          ),
                          UserInfoEditField(
                            text: "Phone",
                            child: TextFormField(
                              initialValue: user.phone,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFF00BF6D).withValues(alpha: 0.05),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5,
                                  vertical: 16.0,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                              ),
                            ),
                          ),
                          UserInfoEditField(
                            text: "Address",
                            child: TextFormField(
                              initialValue: user.address,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFF00BF6D).withValues(alpha: 0.05),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5,
                                  vertical: 16.0,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                              ),
                            ),
                          ),
                          UserInfoEditField(
                            text: "Old Password",
                            child: TextFormField(
                              obscureText: true,
                              initialValue: "", // Senha não deve vir preenchida por segurança
                              decoration: InputDecoration(
                                suffixIcon: const Icon(
                                  Icons.visibility_off,
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: const Color(0xFF00BF6D).withValues(alpha: 0.05),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5,
                                  vertical: 16.0,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                              ),
                            ),
                          ),
                          UserInfoEditField(
                            text: "New Password",
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "New Password",
                                filled: true,
                                fillColor: const Color(0xFF00BF6D).withValues(alpha: 0.05),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5,
                                  vertical: 16.0,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.color!.withValues(alpha: 0.08),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                              shape: const StadiumBorder(),
                            ),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        SizedBox(
                          width: 160,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00BF6D),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {},
                            child: const Text("Save Update"),
                          ),
                        ),
                      ],
                    ),
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

class UserInfoEditField extends StatelessWidget {
  const UserInfoEditField({super.key, required this.text, required this.child});

  final String text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0 / 2),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(text)),
          Expanded(flex: 3, child: child),
        ],
      ),
    );
  }
}
