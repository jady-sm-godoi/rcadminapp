import 'package:flutter/material.dart';
import 'package:rcadminapp/models/user_profile.dart';
import 'package:rcadminapp/widgets/profile_pic.dart';

class UserProfileCard extends StatelessWidget {
  final UserProfileModel user;

  const UserProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(top: 150,bottom: 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
        children: [
          ProfilePic(image: user.imageUrl),
          Text(user.socialName,
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold
            )
          ),
          Divider(height: 16 * 2.5, color: Colors.grey),
          Info(infoKey: 'Data de Nascimento', info: '${user.birth.day}/${user.birth.month}/${user.birth.year}'),
          Info(infoKey: 'CPF', info: user.idCard),
          Info(infoKey: 'discipulado', info: '${user.aspect} - ${user.aspectDate.day}/${user.aspectDate.month}/${user.aspectDate.year}'),
          Divider(height: 16 * 2.5, color: Colors.grey),
          Info(infoKey: 'e-mail', info: user.email),
          Info(infoKey: 'Telefone', info: user.phone),
          Info(infoKey:'Endereço', info: '${user.address}, ${user.number}\n${user.complement} ${user.district} \n${user.zipCode} \n${user.city} - ${user.state} - ${user.country}'),
          Divider(height: 16 * 2.5, color: Colors.grey),
          Info(infoKey: 'SOS', info: 'Contato: ${user.sosContact}\nTelefone: ${user.sosPhone}'),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/edit_profile', arguments: user);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(135, 118, 78, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
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
          )
          ]
        ),
      )
    );
  }
}

class Info extends StatelessWidget {
  const Info({
    super.key,
    required this.infoKey,
    required this.info,
  });

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
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color!
                  .withValues(alpha: 0.7),
            ),
          ),
          Text(info, textAlign: TextAlign.right),
        ],
      ),
    );
  }
}