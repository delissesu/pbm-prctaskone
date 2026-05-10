import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prctaskone/models/product_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String BASE_URL = 'https://task.itprojects.web.id';
  static final _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  static Future<Map<String, dynamic>> login(String nim, String password) async {
    print('POST username $nim');

    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/api/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'username': nim, 'password': password}),
      );

      print('statuc code: ${response.statusCode}');
      print('response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          await saveToken(data['data']['token']);
        }
        return data;
      } else {
        print('status code: ${response.statusCode}');
        return {
          'success': false,
          'message': 'gagal, status: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('error login: $e');
      return {'success': false, 'message': 'terjadi kesalahan jaringan'};
    }
  }

  static Future<List<ProductModel>> getProducts() async {
    final token = await getToken();
    print('produk token: $token');
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/api/products'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('status code: ${response.statusCode}');
      print('response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List productsJson = data['products'];
          return productsJson.map((e) => ProductModel.fromJson(e)).toList();
        } else {
          print('data sukses: ${response.statusCode}');
          return [];
        }
      } else {
        print('get produk gagal, statuc code ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('error: $e');
      return [];
    }
  }

  static Future<bool> addProduct(ProductRequestModel request) async {
    print('add produk: ${request.name}');
    final token = await getToken();
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/api/products'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      print('status code: ${response.statusCode}');
      print('response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        print('gagal menambah produk, status code: ${response.statusCode}');
        return false;
        
      }
    } catch (e) {
      print('error: $e');
      return false;
    }
  }
}
