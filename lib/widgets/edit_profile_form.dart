import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcadminapp/models/auth.dart';
import 'package:rcadminapp/models/user_profile.dart';
import 'package:rcadminapp/service/profile_service.dart';

class EditProfileForm extends StatefulWidget {
   final UserProfileModel user;

  const EditProfileForm({super.key, required this.user});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  InputDecoration get _inputDecoration => const InputDecoration(
    filled: true,
    fillColor: Color.fromRGBO(36, 59, 85, 0.05),
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16.0 * 1.5,
      vertical: 16.0,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    // Adiciona campos que não estão no formulário mas são necessários
    _formData['gender'] = widget.user.gender;

    final auth = Provider.of<Auth>(context, listen: false);

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Salvando dados...')),
      );

      await ProfileService().updateProfileData(auth, _formData);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil atualizado com sucesso!'),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              UserInfoEditField(
                text: "Name",
                child: TextFormField(
                  initialValue: widget.user.socialName,
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
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              UserInfoEditField(
                text: "Telefone",
                child: TextFormField(
                  initialValue: widget.user.phone,
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
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              Text("Endereço completo"),
              UserInfoEditField(
                text: "Logradouro",
                child: TextFormField(
                  initialValue: widget.user.address,
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
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              UserInfoEditField(
                text: "Número",
                child: TextFormField(
                  initialValue: widget.user.number,
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
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              UserInfoEditField(
                text: "Complemento",
                child: TextFormField(
                  initialValue: widget.user.complement,
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
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              UserInfoEditField(
                text: "Bairro",
                child: TextFormField(
                  initialValue: widget.user.district,
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
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              UserInfoEditField(
                text: "CEP",
                child: TextFormField(
                  initialValue: widget.user.zipCode,
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
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              UserInfoEditField(
                text: "Cidade",
                child: TextFormField(
                  initialValue: widget.user.city,
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
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              UserInfoEditField(
                text: "UF",
                child: TextFormField(
                  initialValue: widget.user.state,
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
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              UserInfoEditField(
                text: "País",
                child: TextFormField(
                  initialValue: widget.user.country,
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
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              UserInfoEditField(
                text: "SOS Contato",
                child: TextFormField(
                  initialValue: widget.user.sosContact,
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
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              UserInfoEditField(
                text: "SOS Telefone",
                child: TextFormField(
                  initialValue: widget.user.sosPhone,
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
                      borderRadius: BorderRadius.all(Radius.circular(12)),
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
                onPressed: _submitForm,
                child: const Text("Salvar"),
              ),
            ),
          ],
        ),
      ],
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
    );
  }
}
