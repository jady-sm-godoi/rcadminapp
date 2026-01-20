import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcadminapp/models/auth.dart';
import 'package:rcadminapp/service/profile_service.dart';
import 'package:rcadminapp/utils/otp_form.dart';
import 'package:rcadminapp/utils/validators.dart';

class ForgotPasswordForm extends StatefulWidget {
  final bool isChangePassword;

  const ForgotPasswordForm({super.key, this.isChangePassword = false});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
    'password_repeat': '',
    'old_password': '',
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

    try{
      if (widget.isChangePassword) {
        final auth = Provider.of<Auth>(context, listen: false);
        
        // Envia os dados para troca de senha (estando logado)
        await ProfileService().changePassword(auth, {
          // A API espera old_password e new_password
          'old_password': _authData['old_password']!,
          'new_password': _authData['password']!
        });

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha alterada com sucesso!')),
        );
        // Navigator.of(context).pop(); // Fecha a tela/modal
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);

      } else {
        // Fluxo de "Esqueci minha senha" (não logado ou reset via OTP)
        final emailData = {'email': _authData['email']!};
        await ProfileService().forgotPassword(emailData);

        if (!context.mounted) return;
        OtpForm.otpFormModal(context, _authData['email']!, _authData['password']!);
      }

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
                widget.isChangePassword ? "Alterar Senha" : "Troque sua senha",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(135, 118, 78, 1)
                )
              ),
              SizedBox(height: 16),
              if (!widget.isChangePassword)
                TextFormField(
                decoration: InputDecoration(
                  labelText: 'e-mail',
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: Validators.email,
              ),
              if (widget.isChangePassword)
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'senha antiga',
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                onSaved: (oldPassword) => _authData['old_password'] = oldPassword ?? '',
                validator: Validators.password,
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
                  child: Text(widget.isChangePassword ? 'Salvar' : 'Enviar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  ),
                ),
                if (!widget.isChangePassword)
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