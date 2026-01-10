import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rcadminapp/config/app_config.dart';

class Auth with ChangeNotifier{

  static const _url = '${AppConfig.apiBaseUrl}/user/auth/login';

  Future<void> loginRequest(String email, String password) async {
    final response = await http.post(
      Uri.parse(_url),
      body: jsonEncode({
        'email': email,
        'password': password
      })
    );
    print(jsonDecode(response.body));

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      final apiMessage = body['detail'];

      String errorMessage;

      switch (apiMessage) {
        case 'Invalid credentials.':
          errorMessage = 'Email ou senha inválidos';
          break;
        default:
          errorMessage = 'Erro ao realizar login';
      }

      throw Exception(errorMessage);
    }

  }
}