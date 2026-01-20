import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcadminapp/models/auth.dart';
import 'package:rcadminapp/service/profile_service.dart';
import 'package:rcadminapp/widgets/edit_profile_form.dart';
import 'package:rcadminapp/widgets/rca_bottom_modal.dart';

class EditMail {
  // Construtor privado para impedir instanciação
  EditMail._();

  static Future<void> execute(
    GlobalKey<FormState> formKey, 
    TextEditingController emailController, 
    context, 
    user,
    ) async {
    if (formKey.currentState!.validate()) {
      final auth = Provider.of<Auth>(context, listen: false);
      final newEmail = emailController.text.trim();

      Navigator.of(context).pop(); // Fecha o modal

      if (newEmail == user.email) return;

      try {
        await ProfileService().updateProfileEmail(auth, {'email': newEmail});

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    }
  }

  static Future<void> editEmail(BuildContext context, user) async {
    final TextEditingController emailController = TextEditingController(
      text: user.email,
    );
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    RcaBottomModal.show(
      context: context,
      title: 'Atualizar E-mail',
      content: Column(
        children: [
          Column(
            children: [
              const Text('Importante!', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(
                'Dentro do rcadmin, o endereço de e-mail deve ser único, pois é por meio dele que nos comunicamos com outros sistemas, como rdstation e register2event.\nPortanto, para alterar seu endereço de e-mail, você deve escolher um que não esteja listado no rcadmin e após enviar o formulário, uma mensagem com um link de confirmação será enviada para o endereço de e-mail escolhido.\nApós a confirmação, você poderá efetuar login no sistema com o novo endereço de e-mail escolhido.',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                textAlign: TextAlign.justify,
              ),
            ],
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
                    if (value == null || value.isEmpty) {
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
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(135, 118, 78, 1),
            foregroundColor: Colors.white,
          ),
          onPressed: () => execute(formKey, emailController, context, user),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
