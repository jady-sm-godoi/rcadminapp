import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rcadminapp/models/auth.dart';
import 'package:rcadminapp/service/profile_service.dart';

class ProfilePicUpdate {
  // Construtor privado para impedir instanciação
  ProfilePicUpdate._();

  static Future<void> execute({
    required BuildContext context,
    required Function(File?) onImageSelected,
    required Function() onImageDeleted,
  }) async {
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
                ),
              ],
            ),
          );
        },
      );

      if (source == null) return;

      final auth = Provider.of<Auth>(context, listen: false);

      if (source == 'delete') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Removendo imagem...')));

        await ProfileService().deleteProfileImage(auth);

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagem removida com sucesso!')),
        );
        onImageDeleted();
        return;
      }

      final XFile? image = await picker.pickImage(
        source: source as ImageSource,
        imageQuality: 50,
      );

      if (image == null) return;

      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enviando imagem...')));

      await ProfileService().uploadProfileImage(auth, File(image.path));

      if (!context.mounted) return;

      // Remove a mensagem de "Enviando..." para que a de sucesso apareça imediatamente
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagem atualizada com sucesso!')),
      );
      
      onImageSelected(File(image.path));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }
  
}