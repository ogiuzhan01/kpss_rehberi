import 'dart:async';
import 'package:flutter/material.dart';
import 'db_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KpssApp());
}

class KpssApp extends StatelessWidget {
  const KpssApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KPSS Rehberi',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A0E4E),
          primary: const Color(0xFF6B2D5C),
          secondary: const Color(0xFFE55812),
          surface: const Color(0xFFF8F9FA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F5F7),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF4A0E4E),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class Question {
  final int id;
  final String lessonTitle;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  Question({
    required this.id,
    required this.lessonTitle,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      lessonTitle: map['lessonTitle'],
      questionText: map['questionText'],
      options: [
        map['optionA'],
        map['optionB'],
        map['optionC'],
        map['optionD'],
        map['optionE'],
      ],
      correctOptionIndex: map['correctOptionIndex'],
      explanation: map['explanation'],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KPSS Soru Bankası'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Karşılama Paneli
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A0E4E), Color(0xFF812675)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hoş Geldin! 👋',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Bugün hedeflerine bir adım daha yaklaş.',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Yanlışlar Kutusu Kartı
            Card(
              elevation: 0,
              color: const Color(0xFFFFF0F0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.red.shade200, width: 1.5),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_fix_high_rounded, color: Colors.red, size: 26),
                ),
                title: const Text(
                  'Yanlışlarımı Temizle',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.red),
                ),
                subtitle: const Text('Hatalı çözdüğün soruları tekrar incele'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.red, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuizPage(lessonTitle: 'Yanlışlarım', isWrongMode: true),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Dersler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),

            // Ders Listesi
            _buildLessonCard(context, 'Tarih', Icons.menu_book_rounded, const Color(0xFFE5A93C)),
            _buildLessonCard(context, 'Coğrafya', Icons.public_rounded, const Color(0xFF2E7D32)),
            _buildLessonCard(context, 'Türkçe', Icons.edit_note_rounded, const Color(0xFF1976D2)),
            _buildLessonCard(context, 'Matematik', Icons.calculate_rounded, const Color(0xFFD32F2F)),
            _buildLessonCard(context, 'Vatandaşlık', Icons.gavel_rounded, const Color(0xFF7B1FA2)),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard(BuildContext context, String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        subtitle: const Text('Konu testleri ve pratik sorular'),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPage(lessonTitle: title),
            ),
          );
        },
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final String lessonTitle;
  final bool isWrongMode;

  const QuizPage({super.key, required this.lessonTitle, this.isWrongMode = false});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> questions = [];
  bool isLoading = true;

  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  bool isAnswered = false;

  int correctAnswers = 0;
  int wrongAnswers = 0;

  Timer? timer;
  int secondsRemaining = 60;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    List<Map<String, dynamic>> data;
    if (widget.isWrongMode) {
      data = await DatabaseHelper.instance.getWrongQuestions();
    } else {
      data = await DatabaseHelper.instance.getQuestionsByLesson(widget.lessonTitle);
    }

    setState(() {
      questions = data.map((q) => Question.fromMap(q)).toList();
      isLoading = false;
    });

    if (questions.isNotEmpty) {
      startTimer();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    secondsRemaining = 60;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer?.cancel();
        if (!isAnswered) {
          setState(() {
            isAnswered = true;
            wrongAnswers++;
          });
          DatabaseHelper.instance.addWrongQuestion(questions[currentQuestionIndex].id);
        }
      }
    });
  }

  void answerQuestion(int index) {
    if (isAnswered) return;
    timer?.cancel();
    final currentQuestion = questions[currentQuestionIndex];

    setState(() {
      selectedOptionIndex = index;
      isAnswered = true;
      if (index == currentQuestion.correctOptionIndex) {
        correctAnswers++;
        DatabaseHelper.instance.removeWrongQuestion(currentQuestion.id);
      } else {
        wrongAnswers++;
        DatabaseHelper.instance.addWrongQuestion(currentQuestion.id);
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOptionIndex = null;
        isAnswered = false;
      });
      startTimer();
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Test Tamamlandı! 🎉', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 60),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Chip(
                    label: Text('Doğru: $correctAnswers'),
                    backgroundColor: Colors.green.shade100,
                    side: BorderSide.none,
                  ),
                  Chip(
                    label: Text('Yanlış: $wrongAnswers'),
                    backgroundColor: Colors.red.shade100,
                    side: BorderSide.none,
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A0E4E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Ana Ekrana Dön'),
              ),
            )
          ],
        ),
      );
    }
  }

  final List<String> optionLetters = ['A', 'B', 'C', 'D', 'E'];

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.lessonTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.lessonTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.isWrongMode ? Icons.verified_rounded : Icons.folder_open_rounded,
                  size: 70,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  widget.isWrongMode
                      ? 'Harika! Henüz yanlış yaptığın soru bulunmuyor. 🎉'
                      : 'Bu derse ait henüz soru eklenmemiş.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lessonTitle),
      ),
      body: Column(
        children: [
          // İlerleme Çubuğu (Linear Progress)
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.purple.shade100,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF812675)),
            minHeight: 6,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Soru Sayacı ve Zamanlayıcı
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Soru ${currentQuestionIndex + 1} / ${questions.length}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: secondsRemaining <= 10 ? Colors.red.shade100 : Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 16,
                              color: secondsRemaining <= 10 ? Colors.red : const Color(0xFF4A0E4E),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$secondsRemaining sn',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: secondsRemaining <= 10 ? Colors.red : const Color(0xFF4A0E4E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Soru Kartı
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      currentQuestion.questionText,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, height: 1.4),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Şıklar Listesi
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentQuestion.options.length,
                      itemBuilder: (context, index) {
                        Color cardColor = Colors.white;
                        Color textColor = Colors.black87;
                        Color avatarBg = Colors.purple.shade50;
                        Color avatarTextColor = const Color(0xFF4A0E4E);

                        if (isAnswered) {
                          if (index == currentQuestion.correctOptionIndex) {
                            cardColor = const Color(0xFFE8F5E9);
                            textColor = Colors.green.shade900;
                            avatarBg = Colors.green;
                            avatarTextColor = Colors.white;
                          } else if (index == selectedOptionIndex) {
                            cardColor = const Color(0xFFFFEBEE);
                            textColor = Colors.red.shade900;
                            avatarBg = Colors.red;
                            avatarTextColor = Colors.white;
                          }
                        }

                        return GestureDetector(
                          onTap: () => answerQuestion(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isAnswered && index == currentQuestion.correctOptionIndex
                                    ? Colors.green.shade300
                                    : (isAnswered && index == selectedOptionIndex
                                        ? Colors.red.shade300
                                        : Colors.grey.shade200),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: avatarBg,
                                  child: Text(
                                    optionLetters[index],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: avatarTextColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    currentQuestion.options[index],
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Çözüm Açıklaması ve İlerle Butonu
                  if (isAnswered) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb_rounded, color: Colors.amber, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Çözüm: ${currentQuestion.explanation}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A0E4E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      child: Text(
                        currentQuestionIndex == questions.length - 1 ? 'Testi Bitir' : 'Sonraki Soru',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}