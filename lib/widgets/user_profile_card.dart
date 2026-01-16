import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcadminapp/models/auth.dart';
import 'package:rcadminapp/models/user_profile.dart';
import 'package:rcadminapp/screens/edit_profile_screen.dart';
import 'package:rcadminapp/service/profile_service.dart';
import 'package:rcadminapp/utils/edit_mail.dart';
import 'package:rcadminapp/utils/profile_pic_update.dart';
import 'package:rcadminapp/widgets/profile_pic.dart';

class UserProfileCard extends StatelessWidget {
  final UserProfileModel user;
  final VoidCallback? onReturn;

  const UserProfileCard({super.key, required this.user, this.onReturn});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(top: 150, bottom: 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfilePic(
              image: user.imageUrl,
              isShowPhotoUpload: true,
              imageUploadBtnPress: () {
                ProfilePicUpdate.execute(
                  context: context,
                  onImageSelected: (_) => onReturn?.call(),
                  onImageDeleted: () => onReturn?.call(),
                );
              },
            ),
            Text(
              user.socialName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Text(
                  user.email,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                InkWell(
                  onTap: () => EditMail.editEmail(context, user),
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
              info: '${user.birth.day}/${user.birth.month}/${user.birth.year}',
            ),
            Info(infoKey: 'CPF', info: user.idCard),
            Info(
              infoKey: 'discipulado',
              info:
                  '${user.aspect} - ${user.aspectDate.day}/${user.aspectDate.month}/${user.aspectDate.year}',
            ),
            Divider(height: 16 * 2.5, color: Colors.grey),
            Info(infoKey: 'Telefone', info: user.phone),
            Info(
              infoKey: 'Endereço',
              info:
                  '${user.address}, ${user.number}\n${user.complement} ${user.district} \n${user.zipCode} \n${user.city} - ${user.state} - ${user.country}',
            ),
            Divider(height: 16 * 2.5, color: Colors.grey),
            Info(
              infoKey: 'SOS',
              info: 'Contato: ${user.sosContact}\nTelefone: ${user.sosPhone}',
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
                    ).pushNamed('/edit_profile', arguments: user);
                    if (onReturn != null) onReturn!();
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
