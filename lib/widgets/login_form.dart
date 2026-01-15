import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcadminapp/models/auth.dart';
import 'package:rcadminapp/utils/validators.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final Map<String, String> _authData = {
    'email': '',
    'password': ''
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
  
  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if(!isValid){
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();

    Auth auth = Provider.of(context, listen: false);
    try{
      await auth.loginRequest(_authData['email']!, _authData['password']!);
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/profile');
      }
    }catch(error){
       if (error is Exception) {
        _showErrorDialog(error.toString().replaceFirst('Exception: ', ''));
      } else {
        _showErrorDialog('Erro inesperado');
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }

     
    // print('Formulário submetido');
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
                "Login",
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
                  labelText: 'senha',
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: Validators.password,
              ),
              SizedBox(height: 20,),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(135, 118, 78, 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(30)),
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0,
                    ),
                    minimumSize: Size(double.infinity, 36)
                  ),
                  child: Text('Entrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
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