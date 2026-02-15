import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcadminapp/models/auth.dart';
import 'package:rcadminapp/models/user_profile.dart';
import 'package:rcadminapp/service/profile_service.dart';
import 'package:rcadminapp/widgets/rca_background.dart';
import 'package:rcadminapp/widgets/rca_drawer.dart';
import 'package:rcadminapp/widgets/rca_header_bar.dart';
import 'package:rcadminapp/widgets/user_profile_card.dart';

class ProfileScreem extends StatefulWidget {
  const ProfileScreem({super.key});

  @override
  State<ProfileScreem> createState() => _ProfileScreemState();
}

class _ProfileScreemState extends State<ProfileScreem> {
  late Future<UserProfileModel> _futureProfile;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<Auth>(context, listen: false);
    _futureProfile = ProfileService().fetchProfile(auth);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: RcaHeaderBar(subtitle: 'Meu perfil de aluno',),
      endDrawer: RcaDrawer(),
      body: RcaBackground(
        addPaddingTop: true,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                FutureBuilder(
                  future: _futureProfile,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
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
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  final auth = Provider.of<Auth>(
                                    context,
                                    listen: false,
                                  );
                                  _futureProfile = ProfileService().fetchProfile(
                                    auth,
                                  );
                                });
                              },
                              child: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      );
                    }
                    return UserProfileCard(
                      user: snapshot.data!,
                      onReturn: () {
                        setState(() {
                          final auth = Provider.of<Auth>(context, listen: false);
                          _futureProfile = ProfileService().fetchProfile(auth);
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
