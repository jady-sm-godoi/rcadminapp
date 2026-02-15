import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rcadminapp/models/user_profile.dart';
import 'package:rcadminapp/utils/edit_mail.dart';
import 'package:rcadminapp/utils/profile_pic_update.dart';
import 'package:rcadminapp/widgets/profile_pic.dart';

class UserProfileCard extends StatefulWidget {
  final UserProfileModel user;
  final VoidCallback? onReturn;

  const UserProfileCard({super.key, required this.user, this.onReturn});

  @override
  State<UserProfileCard> createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  File? _localImage;
  late String _imageUrlWithTimestamp;

  @override
  void initState() {
    super.initState();
    _updateImageUrl();
  }

  @override
  void didUpdateWidget(covariant UserProfileCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user.imageUrl != widget.user.imageUrl) {
      _updateImageUrl();
    }
  }

  void _updateImageUrl() {
    if (widget.user.imageUrl.isNotEmpty) {
      // Adiciona timestamp para evitar cache persistente, já que o nome do arquivo não muda
      final separator = widget.user.imageUrl.contains('?') ? '&' : '?';
      _imageUrlWithTimestamp =
          '${widget.user.imageUrl}${separator}v=${DateTime.now().millisecondsSinceEpoch}';
    } else {
      _imageUrlWithTimestamp = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      // margin: EdgeInsets.only(top: 150, bottom: 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfilePic(
              image: _imageUrlWithTimestamp,
              imageFile: _localImage, // Usa a imagem local se disponível
              isShowPhotoUpload: true,
              imageUploadBtnPress: () {
                ProfilePicUpdate.execute(
                  context: context,
                  imageUrl: widget.user.imageUrl,
                  onImageSelected: (file) {
                    // Atualiza o estado local para mostrar a nova foto imediatamente
                    setState(() => _localImage = file);
                    widget.onReturn?.call();
                  },
                  onImageDeleted: () {
                    setState(() => _localImage = null);
                    // Aqui idealmente precisaríamos forçar o ProfilePic a não mostrar a URL antiga
                    // mas o refresh do onReturn deve trazer a URL vazia ou placeholder
                    widget.onReturn?.call();
                  },
                );
              },
            ),
            Text(
              widget.user.socialName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Text(
                  widget.user.email,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                InkWell(
                  onTap: () => EditMail.editEmail(context, widget.user),
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
            // Info(infoKey: 'e-mail', info: user.email),
            Divider(height: 16 * 2.5, color: Colors.grey),
            Info(
              infoKey: 'Data de Nascimento',
              info: '${widget.user.birth.day}/${widget.user.birth.month}/${widget.user.birth.year}',
            ),
            Info(infoKey: 'CPF', info: widget.user.idCard),
            Info(
              infoKey: 'discipulado',
              info:
                  '${widget.user.aspect} - ${widget.user.aspectDate.day}/${widget.user.aspectDate.month}/${widget.user.aspectDate.year}',
            ),
            Divider(height: 16 * 2.5, color: Colors.grey),
            Info(infoKey: 'Telefone', info: widget.user.phone),
            Info(
              infoKey: 'Endereço',
              info:
                  '${widget.user.address}, ${widget.user.number}\n${widget.user.complement} ${widget.user.district} \n${widget.user.zipCode} \n${widget.user.city} - ${widget.user.state} - ${widget.user.country}',
            ),
            Divider(height: 16 * 2.5, color: Colors.grey),
            Info(
              infoKey: 'SOS',
              info: 'Contato: ${widget.user.sosContact}\nTelefone: ${widget.user.sosPhone}',
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.of(
                      context,
                    ).pushNamed('/edit_profile', arguments: widget.user);
                    if (widget.onReturn != null) widget.onReturn!();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(135, 118, 78, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                  ),
                  child: Text(
                    'Editar Perfil',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({super.key, required this.infoKey, required this.info});

  final String infoKey, info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            infoKey,
            style: TextStyle(
              color: Theme.of(
                context,
              ).textTheme.bodyLarge!.color!.withValues(alpha: 0.7),
            ),
          ),
          Text(info, textAlign: TextAlign.right),
        ],
      ),
    );
  }
}
