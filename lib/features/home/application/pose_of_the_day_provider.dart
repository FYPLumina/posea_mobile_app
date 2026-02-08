import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:posea_mobile_app/features/poses/data/models/pose_model.dart';
import 'package:posea_mobile_app/features/poses/data/datasources/pose_image_api_service.dart';
import 'package:posea_mobile_app/features/auth/application/auth_provider.dart';

class PoseOfTheDayProvider extends ChangeNotifier {
  final PoseImageApiService apiService;
  final AuthProvider authProvider;

  Pose? _pose;
  Pose? get pose => _pose;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  PoseOfTheDayProvider({required this.apiService, required this.authProvider});

  Future<void> fetchPoseOfTheDay() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final token = authProvider.token;
      if (token == null) {
        _error = 'No access token';
        _loading = false;
        notifyListeners();
        return;
      }
      final url = Uri.parse('${apiService.baseUrl}/pose/pose_of_the_day');
      final response = await apiService._getPoseOfTheDay(url, token);
      if (response['success'] == true && response['data'] != null) {
        _pose = Pose.fromJson(response['data']);
      } else {
        _pose = null;
        _error = response['error'] ?? 'No pose selected today';
      }
    } catch (e) {
      _error = e.toString();
      _pose = null;
    }
    _loading = false;
    notifyListeners();
  }
}

extension on PoseImageApiService {
  Future<Map<String, dynamic>> _getPoseOfTheDay(Uri url, String token) async {
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
