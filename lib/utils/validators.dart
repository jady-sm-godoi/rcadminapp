class Validators {
  static String? email(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'E-mail obrigatório';
    }

    if (!email.contains('@') || !email.contains('.')) {
      return 'E-mail inválido';
    }

    return null;
  }

  static String? password(String? value) {
    final password = value?.trim() ?? '';

    if (password.isEmpty) {
      return 'Senha obrigatória';
    }

    if (password.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }

    return null;
  }
}
