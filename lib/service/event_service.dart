import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rcadminapp/config/app_config.dart';
import 'package:rcadminapp/models/auth.dart';
import 'package:rcadminapp/utils/app_exception.dart';

class EventService {
  
  Future<List<dynamic>> getEvents(Auth auth) async {
    final uri = Uri.parse('${AppConfig.apiR2eUrl}/event/events');
    String token = auth.token ?? '';

    try {
      var response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

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
          ).timeout(const Duration(seconds: 30));
        }
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['data'];
      }

      throw AppException('Erro ao buscar eventos (${response.statusCode})');
    } catch (e) {
      debugPrint('Erro get eventos: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getRegistrations(Auth auth) async {
    final uri = Uri.parse('${AppConfig.apiR2eUrl}/person/registers');
    String token = auth.token ?? '';

    try {
      var response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

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
          ).timeout(const Duration(seconds: 30));
        }
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['data'];
      }

      throw AppException('Erro ao buscar inscrições (${response.statusCode})');
    } catch (e) {
      debugPrint('Erro get inscrições: $e');
      rethrow;
    }
  }
}