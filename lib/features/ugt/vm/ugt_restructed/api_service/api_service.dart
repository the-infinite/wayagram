import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://services.staging.wayagram.ng/school-contest/api/v1";
  Future<List> fetchUser() async {
    final response = await http.get(Uri.parse('$baseUrl/category/getAll'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      //return data.map((item) => ContestCategory.fromJson(item)).toList();
      return data;
    } else {
      throw Exception('Failed to load the User');
    }
  }

  /*Future<CreateUser> createUser(String name, String job) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "job": job}),
    );
    if (kDebugMode) {
      debugPrint("response => ${response.body}");
    }
    if (response.statusCode == 201) {
      return CreateUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }*/
}