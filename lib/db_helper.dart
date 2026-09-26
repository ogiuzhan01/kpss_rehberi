import 'dart0:convert' if (dart.library.html) 'dart:convert';
import 'dart:convert';
import 'package:flutter/services.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  List<Map<String, dynamic>> _allQuestions = [];
  final Set<int> _wrongQuestionIds = {};

  // JSON dosyasından verileri her çağrıldığında taze okumak için
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

  // Derse Göre Soru Getirme
  Future<List<Map<String, dynamic>>> getQuestionsByLesson(String lessonTitle) async {
    final questions = await _loadJsonData();
    
    // Ders ismini küçük/büyük harf ve boşluk duyarlılığını kaldırarak eşleştiriyoruz
    return questions.where((q) {
      final title = q['lessonTitle']?.toString().trim().toLowerCase() ?? '';
      return title == lessonTitle.trim().toLowerCase();
    }).toList();
  }

  // Yanlış Soruyu Kaydetme
  void addWrongQuestion(int id) {
    _wrongQuestionIds.add(id);
  }

  // Doğru Çözülünce Yanlış Listesinden Çıkarma
  void removeWrongQuestion(int id) {
    _wrongQuestionIds.remove(id);
  }

  // Yanlış Yapılan Tüm Soruları Getirme
  Future<List<Map<String, dynamic>>> getWrongQuestions() async {
    final questions = await _loadJsonData();
    return questions
        .where((q) => _wrongQuestionIds.contains(q['id']))
        .toList();
  }
}