import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rcadminapp/config/app_config.dart';

class Auth with ChangeNotifier{

  static const _url = '${AppConfig.apiBaseUrl}/user/auth/login';
  String? _token;
  String? _refreshToken;

  String? get token => _token;
  bool get isAuth => _token != null;

  Future<void> loginRequest(String email, String password) async {
    final response = await http.post(
      Uri.parse(_url),
      body: jsonEncode({
        'email': email,
        'password': password
      })
    );
    // print('Esse é o response body da autenticação: ${jsonDecode(response.body)}');
    
    final responseData = jsonDecode(response.body);

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

    _token = responseData['access_token'];
    _refreshToken = responseData['refresh_token'];

    // print('token: $_token');
    // print('refresh token: $_refreshToken');

    notifyListeners();
  }

  Future<bool> tryRefreshToken() async {
    if (_refreshToken == null) return false;
    // print('refresh token acionado: $_refreshToken');
    // Assumindo endpoint de refresh padrão baseado na URL de login
    final url = '${AppConfig.apiBaseUrl}/user/auth/refresh'; 
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({'refresh_token': _refreshToken}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _token = responseData['access_token'];
        // Atualiza o refresh token se a API retornar um novo (rotação de refresh token)
        if (responseData['refresh_token'] != null) {
          _refreshToken = responseData['refresh_token'];
        }
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Erro ao renovar token: $e');
    }
    return false;
  }

  void logout() {
    _token = null;
    _refreshToken = null;
    notifyListeners();
  }
}