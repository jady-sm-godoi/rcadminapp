import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcadminapp/models/auth.dart';
import 'package:rcadminapp/models/user_profile.dart';
import 'package:rcadminapp/service/profile_service.dart';

class RcaDrawer extends StatefulWidget {
  const RcaDrawer({super.key});

  @override
  State<RcaDrawer> createState() => _RcaDrawerState();
}

class _RcaDrawerState extends State<RcaDrawer> {
  static const padding = EdgeInsets.symmetric(horizontal: 20);
  late Future<UserProfileModel> _futureProfile;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<Auth>(context, listen: false);
    _futureProfile = ProfileService().fetchProfile(auth);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Color.fromRGBO(135, 118, 78, 1),
        child: FutureBuilder<UserProfileModel>(
          future: _futureProfile,
          builder: (context, snapshot) {
            final name = snapshot.data?.socialName ?? 'Carregando...';
            final email = snapshot.data?.email ?? '';
            final urlImage =
                snapshot.data?.imageUrl ??
                'https://ui-avatars.com/api/?name=User&background=0D8ABC&color=fff';

            return ListView(
              children: <Widget>[
                buildHeader(
                  context,
                  urlImage: urlImage,
                  name: name,
                  email: email,
                ),
                Container(
                  padding: padding,
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      buildMenuItem(
                        active: false,
                        context,
                        text: 'Tesouraria',
                        icon: Icons.monetization_on_outlined,
                        onClicked: () => {},
                      ),
                      const SizedBox(height: 16),
                      buildMenuItem(
                        active: true,
                        context,
                        text: 'Eventos',
                        icon: Icons.event_note_outlined,
                        onClicked: () => {
                          Navigator.of(context).pop(), // Fecha o drawer
                          Navigator.of(context).pushNamed('/events'),
                        },
                      ),
                      const SizedBox(height: 16),
                      buildMenuItem(
                        active: false,
                        context,
                        text: 'Minhas frequências',
                        icon: Icons.check_circle_outline_rounded,
                        onClicked: () => {},
                      ),
                      const SizedBox(height: 16),
                      buildMenuItem(
                        active: false,
                        context,
                        text: 'Meu histórico',
                        icon: Icons.history_edu_outlined,
                        onClicked: () => {},
                      ),
                      const SizedBox(height: 24),
                      const Divider(color: Colors.white70),
                      const SizedBox(height: 24),
                      buildMenuItem(
                        active: false,
                        context,
                        text: 'Calendário de atividades',
                        icon: Icons.calendar_today_outlined,
                        onClicked: () {},
                      ),
                      const SizedBox(height: 24),
                      buildMenuItem(
                        active: true,
                        context,
                        text: 'trocar de senha',
                        icon: Icons.lock_outline,
                        onClicked: () {
                          Navigator.of(context).pop(); // Fecha o drawer
                          Navigator.of(context).pushNamed(
                            '/forgot_password',
                            arguments: true, // Passa 'true' para indicar isChangePassword
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      buildMenuItem(
                        active: true,
                        context,
                        text: 'Sair',
                        icon: Icons.logout,
                        onClicked: () {
                          Provider.of<Auth>(context, listen: false).logout();
                          Navigator.of(
                            context,
                          ).pushNamedAndRemoveUntil('/', (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildMenuItem(
    BuildContext context, {
    required bool active,
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.white;
    const colorInactive = Color.fromARGB(111, 255, 255, 255);

    return ListTile(
      leading: active ? Icon(icon, color: color) : Icon(icon, color: colorInactive),
      title: active
          ? Text(text, style: const TextStyle(color: color, fontSize: 16))
          : Text(
              text,
              style: const TextStyle(color: colorInactive, fontSize: 16),
            ),

      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, String routeName) {
    Navigator.of(context).pop(); // Fecha o drawer
    Navigator.of(context).pushNamed(routeName);
  }

  Widget buildHeader(
    BuildContext context, {
    required String urlImage,
    required String name,
    required String email,
  }) => InkWell(
    onTap: () {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('/profile');
    },
    child: Container(
      padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
      child: Row(
        children: [
          // ProfilePic(image: urlImage, isShowPhotoUpload: false),
          CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
