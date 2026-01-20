import 'package:flutter/material.dart';
import 'package:rcadminapp/service/profile_service.dart';
import 'package:rcadminapp/utils/otp_form.dart';
import 'package:rcadminapp/utils/validators.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
    'password_repeat': ''
  };

  void _showErrorDialog(String msg){
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog(
        title: Text('Ocorreu um erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), 
            child: Text('Fechar'),
          )
        ],
      ),
    );
  }
  
  Future<void> _submit(dynamic context) async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if(!isValid){
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();

    if (_authData['password'] != _authData['password_repeat']) {
      _showErrorDialog('As senhas não coincidem');
      setState(() => _isLoading = false);
      return;
    }
    final emailData = {
      'email': _authData['email']!,
    };

    try{
      await ProfileService().changePassword(emailData);

      if (!context.mounted) return;
      OtpForm.otpFormModal(context, _authData['email']!, _authData['password']!);

    } catch (error) {
      if (!context.mounted) return;
      _showErrorDialog(error.toString().replaceFirst('Exception: ', ''));
    }

    if (!context.mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        height: 400,
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Troque sua senha",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(135, 118, 78, 1)
                )
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'e-mail',
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: Validators.email,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'nova senha',
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: Validators.password,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'repita a nova senha',
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                onSaved: (value) => _authData['password_repeat'] = value ?? '',
                validator: Validators.password,
              ),
              SizedBox(height: 20,),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () => _submit(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(135, 118, 78, 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(30)),
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0,
                    ),
                    minimumSize: Size(double.infinity, 36)
                  ),
                  child: Text('Enviar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  child: Text(
                    'Login',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .color!
                              .withValues(alpha:0.64),
                        ),
                  ),
                ),
            ],
          )
        ),
      ),
    );
  }
}