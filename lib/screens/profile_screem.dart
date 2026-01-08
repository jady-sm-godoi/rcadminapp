import 'package:flutter/material.dart';
import 'package:rcadminapp/models/user_profile.dart';
import 'package:rcadminapp/service/profile_service.dart';
import 'package:rcadminapp/widgets/user_profile_card.dart';

class ProfileScreem extends StatefulWidget {
  const ProfileScreem({super.key});

  @override
  State<ProfileScreem> createState() => _ProfileScreemState();
}

class _ProfileScreemState extends State<ProfileScreem> {

  late Future<UserProfileModel> _futureProfile;
  final String _token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxNTEsInR5cGUiOiJhY2Nlc3MiLCJpYXQiOjE3Njc4NzYxMjgsImV4cCI6MTc2Nzg3NzAyOH0.3kUHml-4INGXJft0HcE5b4WJN9WSfZ1PuPSrkRlSgJQ';

  @override
  void initState() {
    super.initState();
    _futureProfile = ProfileService().fetchProfile(_token);
  }
  

  @override
  Widget build(BuildContext context) {

    // Recupera os argumentos passados pela navegação: credenciais de login
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
    final usuario = args != null ? args['usuario'] : 'N/A';
    final senha = args != null ? args['senha'] : 'N/A';

    print('Usuário: $usuario, Senha: $senha');

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        ),
      body: FutureBuilder(future: _futureProfile, builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16,),
                ElevatedButton(onPressed: (){
                  setState(() {
                    _futureProfile = ProfileService().fetchProfile(_token);
                  });
                }, child: const Text('Tentar novamente'),
                )
              ],
            ),
          );
        }

        return UserProfileCard(user: snapshot.data!);
      }),
    );
  }
}