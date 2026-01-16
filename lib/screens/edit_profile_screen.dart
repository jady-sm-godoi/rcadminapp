import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcadminapp/models/auth.dart';
import 'package:rcadminapp/models/user_profile.dart';
import 'package:rcadminapp/service/profile_service.dart';
import 'package:rcadminapp/utils/profile_pic_update.dart';
import 'package:rcadminapp/widgets/profile_pic.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _selectedImage;
  bool _imageDeleted = false;
  TextEditingController? _birthDateController;
  DateTime? _selectedBirthDate;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_birthDateController == null) {
      final user =
          ModalRoute.of(context)!.settings.arguments as UserProfileModel;
      _selectedBirthDate = user.birth;
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
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          UserInfoEditField(
                            text: "Name",
                            child: TextFormField(
                              initialValue: user.socialName,
                              onSaved: (value) => _formData['social_name'] = value ?? '',
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(36, 59, 85, 0.05),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5,
                                  vertical: 16.0,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          UserInfoEditField(
                            text: "Telefone",
                            child: TextFormField(
                              initialValue: user.phone,
                              onSaved: (value) => _formData['phone'] = value ?? '',
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(36, 59, 85, 0.05),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5,
                                  vertical: 16.0,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text("Endereço completo"),
                          UserInfoEditField(
                            text: "Logradouro",
                            child: TextFormField(
                              initialValue: user.address,
                              onSaved: (value) => _formData['address'] = value ?? '',
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(36, 59, 85, 0.05),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5,
                                  vertical: 16.0,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          UserInfoEditField(
                            text: "Número",
                            child: TextFormField(
                              initialValue: user.number,
                              onSaved: (value) => _formData['number'] = value ?? '',
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(36, 59, 85, 0.05),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5,
                                  vertical: 16.0,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          UserInfoEditField(
                            text: "Complemento",
                            child: TextFormField(
                              initialValue: user.complement,
                              onSaved: (value) => _formData['complement'] = value ?? '',
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(36, 59, 85, 0.05),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5,
                                  vertical: 16.0,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          UserInfoEditField(
                            text: "Bairro",
                            child: TextFormField(
                              initialValue: user.district,
                              onSaved: (value) => _formData['district'] = value ?? '',
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(36, 59, 85, 0.05),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5,
                                  vertical: 16.0,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          UserInfoEditField(
                            text: "CEP",
                            child: TextFormField(
                              initialValue: user.zipCode,
                              onSaved: (value) => _formData['zip_code'] = value ?? '',
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(36, 59, 85, 0.05),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5,
                                  vertical: 16.0,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          UserInfoEditField(
                            text: "Cidade",
                            child: TextFormField(
                              initialValue: user.city,
                              onSaved: (value) => _formData['city'] = value ?? '',
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(36, 59, 85, 0.05),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5,
                                  vertical: 16.0,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          UserInfoEditField(
                            text: "UF",
                            child: TextFormField(
                              initialValue: user.state,
                              onSaved: (value) => _formData['state'] = value ?? '',
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(36, 59, 85, 0.05),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5,
                                  vertical: 16.0,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          UserInfoEditField(
                            text: "País",
                            child: TextFormField(
                              initialValue: user.country,
                              onSaved: (value) => _formData['country'] = value ?? '',
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(36, 59, 85, 0.05),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5,
                                  vertical: 16.0,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          UserInfoEditField(
                            text: "SOS Contato",
                            child: TextFormField(
                              initialValue: user.sosContact,
                              onSaved: (value) => _formData['sos_contact'] = value ?? '',
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(36, 59, 85, 0.05),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5,
                                  vertical: 16.0,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          UserInfoEditField(
                            text: "SOS Telefone",
                            child: TextFormField(
                              initialValue: user.sosPhone,
                              onSaved: (value) => _formData['sos_phone'] = value ?? '',
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(36, 59, 85, 0.05),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5,
                                  vertical: 16.0,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
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
                          width: 160,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(135, 118, 78, 1),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;
                              _formKey.currentState!.save();

                              // Adiciona campos que não estão no formulário mas são necessários
                              _formData['gender'] = user.gender;

                              final auth = Provider.of<Auth>(context, listen: false);

                              try {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Salvando dados...')),
                                );

                                await ProfileService().updateProfileData(auth, _formData);

                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Perfil atualizado com sucesso!')),
                                );
                                Navigator.of(context).pop();
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
                              }
                            },
                            child: const Text("Salvar"),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: TextStyle(color: Color.fromRGBO(36, 59, 85, 0.6))),
          const SizedBox(height: 5.0),
          child,
        ],
      ),
      // child: Row(
      //   children: [
      //     Expanded(flex: 2, child: Text(text)),
      //     Expanded(flex: 3, child: child),
      //   ],
      // ),
    );
  }
}
