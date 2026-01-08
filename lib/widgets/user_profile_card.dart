import 'package:flutter/material.dart';
import 'package:rcadminapp/models/user_profile.dart';

class UserProfileCard extends StatelessWidget {
  final UserProfileModel user;

  const UserProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: user.imageUrl.isNotEmpty
                          ? NetworkImage(user.imageUrl)
                          : null,
                      child: user.imageUrl.isEmpty
                          ? Icon(Icons.person, size: 60, color: const Color.fromARGB(255, 136, 76, 76))
                          : null,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Nome: ${user.socialName}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Email: ${user.email}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Telefone: ${user.phone}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Gênero: ${user.gender}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Data de Nascimento: ${user.birth.day}/${user.birth.month}/${user.birth.year}',
                      style: TextStyle(fontSize: 16)),  
                  SizedBox(height: 8),
                  Text('Cidade: ${user.city} - ${user.state}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('País: ${user.country}',
                      style: TextStyle(fontSize: 16)),  
                ]
            ),
      ),
    );
  }
}