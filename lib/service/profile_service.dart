import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rcadminapp/config/app_config.dart';
import 'package:rcadminapp/models/auth.dart';
import 'package:rcadminapp/models/user_profile.dart';
import 'package:rcadminapp/utils/app_exception.dart';

class ProfileService {

  Future<UserProfileModel> fetchProfile(Auth auth) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/user/profile/detail');
    String token = auth.token ?? '';

    try{
      var response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      // Se der 401 (Não autorizado), tenta renovar o token
      if (response.statusCode == 401) {
        final success = await auth.tryRefreshToken();
        if (success) {
          token = auth.token ?? '';
          response = await http.get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ).timeout(const Duration(seconds: 10));
        }
      }

      debugPrint('StatusCode Profilerequest: ${response.statusCode}');
      debugPrint('ResponseBody Profilerequest: ${response.body}');

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

  Future<void> uploadProfileImage(Auth auth, File imageFile) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/user/profile/image/upload');

    // Função auxiliar para criar e enviar a requisição, pois MultipartRequest é de uso único
    Future<http.Response> sendRequest(String token) async {
      final request = http.MultipartRequest('PATCH', uri);
      request.headers['Authorization'] = 'Bearer $token';
      
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      
      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      return http.Response.fromStream(streamedResponse);
    }

    try {
      var response = await sendRequest(auth.token ?? '');

      if (response.statusCode == 401) {
        final success = await auth.tryRefreshToken();
        if (success) {
          response = await sendRequest(auth.token ?? '');
        }
      }

      if (response.statusCode == 200) {
        return;
      }

      debugPrint('Erro upload body: ${response.body}');
      throw AppException('Erro ao enviar imagem (${response.statusCode})');
    } catch (e) {
      debugPrint('Erro upload imagem: $e');
      rethrow;
    }
  }

  Future<void> deleteProfileImage(Auth auth) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/user/profile/image/delete');
    String token = auth.token ?? '';

    try {
      var response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 401) {
        final success = await auth.tryRefreshToken();
        if (success) {
          token = auth.token ?? '';
          response = await http.delete(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
            },
          ).timeout(const Duration(seconds: 10));
        }
      }

      if (response.statusCode == 200) {
        return;
      }

      debugPrint('Erro delete body: ${response.body}');
      throw AppException('Erro ao deletar imagem (${response.statusCode})');
    } catch (e) {
      debugPrint('Erro delete imagem: $e');
      rethrow;
    }
  }
}

