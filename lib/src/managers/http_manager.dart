import 'dart:async' show Future;
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../app_config.dart';
import 'token_manager.dart';

class HttpManager {
  Future<dynamic> get(url) async {
    final headers = await _getHeaders();
    final response =
        await http.Client().get(Uri.parse(AppConfig.API_URL + url ), headers: headers);
    final parsed = jsonDecode(response.body);
    final success = parsed["success"];

    if (!success) {
      throw new Exception(parsed["message"]);
    }
    return parsed;
  }

  Future<dynamic> put(url) async {
    final headers = await _getHeaders();
    final response =
        await http.Client().put(Uri.parse(AppConfig.API_URL + url), headers: headers);
    final parsed = jsonDecode(response.body);
    final success = parsed["success"];

    if (!success) {
      throw new Exception("error al crear");
    }
    return parsed;
  }

  Future<dynamic> delete(url) async {
    final headers = await _getHeaders();
    final response =
    await http.Client().delete(Uri.parse(AppConfig.API_URL + url), headers: headers);
    print(response.body);
    final parsed = jsonDecode(response.body);
    final success = parsed["success"];

    if (!success) {
      throw new Exception("error al eliminar");
    }
    return parsed;
  }

  Future<dynamic> post(url, data) async {
    final headers = await _getHeaders();
    final response = await http.Client().post(Uri.parse(AppConfig.API_URL + url),
        body: jsonEncode(data), headers: headers);
    final parsed = jsonDecode(response.body);
    final success = parsed["success"];

    if (!success) {
      throw new Exception(parsed["message"]);
    }
    return parsed;
  }

  Future<dynamic> postForm(url, data) async {
    final dio = Dio();
    Options? options;
    final token = await TokenManager.getInstance()!.getToken();
    if (token != null) {
      options =
          Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    }

    try {
      final response =
          await dio.post(AppConfig.API_URL + url, data: data, options: options);
      final parsed = response.data;
      final success = parsed["success"];

      if (!success) {
        throw new Exception("error al crear");
      }
      return parsed;
    } catch (e) {
      throw new Exception("error al crear");
    }
  }

  Future<dynamic> putForm(url, data) async {
    final dio = Dio();
    Options? options;
    final token = await TokenManager.getInstance()!.getToken();
    if (token != null) {
      options =
          Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    }

    try {
      final response =
      await dio.put(AppConfig.API_URL + url, data: data, options: options);
      final parsed = response.data;
      final success = parsed["success"];
      if (!success) {
        throw new Exception("error al crear");
      }
      return parsed;
    } catch (e) {
      throw new Exception("error al crear");
    }
  }
  _getHeaders() async {
    final token = await TokenManager.getInstance()!.getToken();
    print(token);
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
  }
}
