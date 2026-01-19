import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcadminapp/models/auth.dart';
import 'package:rcadminapp/screens/edit_profile_screen.dart';
import 'package:rcadminapp/service/profile_service.dart';

class EditMail {

  // Construtor privado para impedir instanciação
  EditMail._();

  static Future<void> editEmail(BuildContext context, user) async {

    final TextEditingController emailController = TextEditingController(
      text: user.email,
    );
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                children: [
                  const Text(
                    'Atualizar E-mail',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  const Divider(),
                  Column(
                    children: [
                      const Text(
                      'Importante!',
                      style: TextStyle(fontSize: 16), 
                      ),
                      const SizedBox(height: 8),
                      Text('Dentro do rcadmin, o endereço de e-mail deve ser único, pois é por meio dele que nos comunicamos com outros sistemas, como rdstation e register2event.\nPortanto, para alterar seu endereço de e-mail, você deve escolher um que não esteja listado no rcadmin e após enviar o formulário, uma mensagem com um link de confirmação será enviada para o endereço de e-mail escolhido.\nApós a confirmação, você poderá efetuar login no sistema com o novo endereço de e-mail escolhido.',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      textAlign: TextAlign.justify,
                      ),
                    ]
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Form(
                      key: formKey,
                      child: UserInfoEditField(
                        text: "Novo E-mail",
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          // initialValue: user.sosContact,
                          validator: (value) {
                            if (value == null || value.isEmpty){
                              return 'Informe o e-mail';
                            }
                            if (!value.contains('@')) return 'E-mail inválido';
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromRGBO(36, 59, 85, 0.05),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0 * 1.5,
                              vertical: 16.0,
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.grey),
                        ), 
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                            135,
                            118,
                            78,
                            1,
                          ),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final auth = Provider.of<Auth>(
                              context,
                              listen: false,
                            );
                            final newEmail = emailController.text.trim();

                            Navigator.of(ctx).pop(); // Fecha o modal

                            if (newEmail == user.email) return;

                            try {
                              await ProfileService().updateProfileEmail(auth, {
                                'email': newEmail,
                              });

                              if (!context.mounted) return;
                              ScaffoldMessenger.of(
                                context,
                              ).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Um e-mail de confirmação foi enviado para o novo endereço de e-mail. Confirme e faça login novamente.',
                                  ),
                                ),
                              );
                              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(
                                context,
                              ).hideCurrentSnackBar();
                                                            
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Erro: $e')),
                              );
                            }
                          }
                        },
                        child: const Text('Salvar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}