import 'dart:convert';
import 'package:flutter/services.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  List<Map<String, dynamic>> _allQuestions = [];
  final Set<int> _wrongQuestionIds = {};

  Future<List<Map<String, dynamic>>> _loadJsonData() async {
    try {
      final String response = await rootBundle.loadString('assets/questions.json');
      final List<dynamic> data = json.decode(response);
      _allQuestions = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print("JSON okuma hatası: $e");
    }
    return _allQuestions;
  }

  Future<List<Map<String, dynamic>>> getQuestionsByLesson(String lessonTitle) async {
    final questions = await _loadJsonData();
    return questions.where((q) {
      final title = q['lessonTitle']?.toString().trim().toLowerCase() ?? '';
      return title == lessonTitle.trim().toLowerCase();
    }).toList();
  }

  void addWrongQuestion(int id) {
    _wrongQuestionIds.add(id);
  }

  void removeWrongQuestion(int id) {
    _wrongQuestionIds.remove(id);
  }

  Future<List<Map<String, dynamic>>> getWrongQuestions() async {
    final questions = await _loadJsonData();
    return questions
        .where((q) => _wrongQuestionIds.contains(q['id']))
        .toList();
  }
}