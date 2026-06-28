import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/task.dart';
import '../models/user.dart';

class ApiService {
  // Android emulator can access the computer's localhost using 10.0.2.2.
  // For a real phone, replace this with your computer IP address.
  static const String baseUrl = 'http://localhost/application_assignment3/api';

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return _post('register.php', {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<User> login({required String email, required String password}) async {
    final response = await _post('login.php', {
      'email': email,
      'password': password,
    });

    if (response['success'] == true) {
      return User.fromJson(response['data']);
    }
    throw Exception(response['message'] ?? 'Invalid login');
  }

  Future<List<Task>> getTasks(int userId) async {
    final response = await _post('get_tasks.php', {'user_id': userId});
    if (response['success'] == true) {
      final tasks = response['data'] as List<dynamic>;
      return tasks.map((item) => Task.fromJson(item)).toList();
    }
    throw Exception(response['message'] ?? 'Unable to load tasks');
  }

  Future<Map<String, dynamic>> addTask({
    required int userId,
    required String title,
    required String description,
    required String dueDate,
    required String status,
  }) {
    return _post('add_task.php', {
      'user_id': userId,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'status': status,
    });
  }

  Future<Map<String, dynamic>> updateTask({
    required int taskId,
    required int userId,
    required String title,
    required String description,
    required String dueDate,
    required String status,
  }) {
    return _post('update_task.php', {
      'id': taskId,
      'user_id': userId,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'status': status,
    });
  }

  Future<Map<String, dynamic>> deleteTask({
    required int taskId,
    required int userId,
  }) {
    return _post('delete_task.php', {'id': taskId, 'user_id': userId});
  }

  Future<Map<String, dynamic>> _post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _headers,
        body: jsonEncode(body),
      );
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      return {
        'success': false,
        'message': 'Could not connect to the server. Check your API URL.',
      };
    }
  }
}
