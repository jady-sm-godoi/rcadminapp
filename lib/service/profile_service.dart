import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rcadminapp/config/app_config.dart';
import 'package:rcadminapp/models/user_profile.dart';
import 'package:rcadminapp/utils/app_exception.dart';

class ProfileService {

  Future<UserProfileModel> fetchProfile(String token) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/user/profile/detail');

    try{
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      debugPrint('StatusCode: ${response.statusCode}');
      debugPrint('ResponseBody: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> json =
            jsonDecode(utf8.decode(response.bodyBytes));
        return UserProfileModel.fromJson(json);
      }
      if(response.statusCode == 401){
        throw AppException('Sessão expirada. Faça login novamente.');
      }
      if(response.statusCode == 403){
        throw AppException('Você não tem permissão para acessar este perfil.');
      }
      if(response.statusCode >= 500){
        throw AppException('Erro interno do servidor. Tente mais tarde.');
      }

      throw AppException('Erro inesperado (${response.statusCode})');

    } on TimeoutException{
      throw AppException('Tempo de conexão esgotado.');
    } on SocketException{
      throw AppException('Sem conexão com a internet.');
    }catch(e){
      debugPrint('Erro na requisição HTTP: $e');
      rethrow;
    }
  }
}
