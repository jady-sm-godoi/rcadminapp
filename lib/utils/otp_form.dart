import 'package:flutter/material.dart';
import 'package:rcadminapp/service/profile_service.dart';
import 'package:rcadminapp/widgets/edit_profile_form.dart';
import 'package:rcadminapp/widgets/rca_bottom_modal.dart';

class OtpForm {

  // Construtor privado para impedir instanciação
  OtpForm._();

  static Future<void> otpFormModal(BuildContext context, email, password) async {

    final TextEditingController otpController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    RcaBottomModal.show(
      context: context,
      title: 'Digite o código OTP',
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Form(
          key: formKey,
          child: UserInfoEditField(
            text: "otp",
            child: TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              // initialValue: user.sosContact,
              validator: (value) {
                if (value == null || value.isEmpty){
                  return 'Informe o codigo para troca de e-mail';
                }
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
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
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
              
              final otpUser = otpController.text.trim();

              Navigator.of(context).pop(); // Fecha o modal

              try {
                final responseOtp = await ProfileService().verifyOtp(
                  {
                    'email': email,
                    'otp': otpUser,
                  },
                );

                final data = responseOtp['data'];
                // print(  'OTP verification response data: $data');
                final resetToken = (data is Map) ? data['reset_token'] : null;

                if (resetToken == null || resetToken.toString().isEmpty) {
                  throw 'Token de verificação não recebido.';
                }

                await ProfileService().resetPassword(
                  {
                    'email': email,
                    'reset_token': resetToken,
                    'new_password': password
                  },
                );

                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Password alterada com sucesso! Faça login novamente.',
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
                  SnackBar(content: Text('Erro: ${e.toString().replaceFirst('Exception: ', '')}')),
                );
              }
            }
          },
          child: const Text('Enviar'),
        ),
      ],
    );
  }
}