import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/data/quiz_bank.dart';
import '../models/question.dart';

enum QuizStatus { idle, running, answered, finished }

/// State management pusat: progres jawaban tersimpan di atas MaterialApp,
/// sehingga tidak hilang saat layar dirotasi atau pengguna berpindah halaman.
class QuizController extends ChangeNotifier {
  QuizController()
    : _questions = List.unmodifiable(QuizBank.questions),
      _answers = List<int?>.filled(QuizBank.questions.length, null);

  final List<Question> _questions;
  final List<int?> _answers;

  List<Question> get questions => _questions;
  List<int?> get answers => List.unmodifiable(_answers);

  String _playerName = '';
  QuizStatus _status = QuizStatus.idle;
  int _currentIndex = 0;
  int _score = 0;
  int _streak = 0;
  int _bestStreak = 0;
  int _timeLeft = 0;
  int _elapsed = 0;
  bool _withTimer = false;
  bool _justAnswered = false;
  Timer? _ticker;

  static const int secondsPerQuestion = 20;
  static const int basePoints = 100;
  static const int timeBonusPerSecond = 3;

  String get playerName => _playerName;
  QuizStatus get status => _status;
  int get currentIndex => _currentIndex;
  Question get currentQuestion => _questions[_currentIndex];
  int get totalQuestions => _questions.length;
  int get timeLeft => _timeLeft;
  int get elapsedSeconds => _elapsed;
  bool get withTimer => _withTimer;
  bool get justAnswered => _justAnswered;
  int get score => _score;
  int get streak => _streak;
  int get bestStreak => _bestStreak;

  int? get currentAnswer => _answers[_currentIndex];
  bool get isLastQuestion => _currentIndex >= _questions.length - 1;

  int get correctCount {
    var n = 0;
    for (var i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i].correctIndex) n++;
    }
    return n;
  }

  int get answeredCount => _answers.where((a) => a != null).length;

  double get progress => answeredCount / _questions.length;

  void start({required String playerName, required bool withTimer}) {
    _playerName = playerName.trim();
    _withTimer = withTimer;
    _status = QuizStatus.running;
    _currentIndex = 0;
    _score = 0;
    _streak = 0;
    _bestStreak = 0;
    _elapsed = 0;
    _justAnswered = false;
    _answers.setAll(0, List<int?>.filled(_questions.length, null));
    _resetTimer();
    _startTicker();
    notifyListeners();
  }

  /// Memilih jawaban. Bisa dipanggil UI maupun timer otomatis.
  void selectAnswer(int optionIndex) {
    if (_status != QuizStatus.running) return;

    _answers[_currentIndex] = optionIndex;
    final q = _questions[_currentIndex];
    final benar = optionIndex == q.correctIndex;

    if (benar) {
      _streak++;
      _bestStreak = _streak > _bestStreak ? _streak : _bestStreak;
      final bonus = _withTimer ? _timeLeft * timeBonusPerSecond : 0;
      _score += basePoints + bonus;
    } else {
      _streak = 0;
    }

    _status = QuizStatus.answered;
    _justAnswered = true;
    _stopTicker();
    notifyListeners();
  }

  /// Lanjut ke soal berikutnya / selesaikan kuis.
  void next() {
    if (_status != QuizStatus.answered) return;
    if (isLastQuestion) {
      _status = QuizStatus.finished;
      _stopTicker();
      notifyListeners();
      return;
    }
    _currentIndex++;
    _justAnswered = false;
    _status = QuizStatus.running;
    _resetTimer();
    _startTicker();
    notifyListeners();
  }

  void restart() {
    start(
      playerName: _playerName.isEmpty ? 'Peserta' : _playerName,
      withTimer: _withTimer,
    );
  }

  QuizResult buildResult() {
    return QuizResult(
      name: _playerName,
      correct: correctCount,
      total: _questions.length,
      score: _score,
      bestStreak: _bestStreak,
      usedTimer: _withTimer,
      elapsedSeconds: _elapsed,
      answers: List.unmodifiable(_answers),
    );
  }

  void resetToIdle() {
    _stopTicker();
    _status = QuizStatus.idle;
    _currentIndex = 0;
    _playerName = '';
    _score = 0;
    _streak = 0;
    _bestStreak = 0;
    _justAnswered = false;
    _answers.setAll(0, List<int?>.filled(_questions.length, null));
    notifyListeners();
  }

  void _resetTimer() {
    _timeLeft = secondsPerQuestion;
  }

  void _startTicker() {
    _stopTicker();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed++;
      if (!_withTimer) {
        notifyListeners();
        return;
      }
      if (_timeLeft <= 1) {
        // Waktu habis -> dianggap salah, tapi jawaban tetap tercatat.
        _timeLeft = 0;
        selectAnswer(-1);
        return;
      }
      _timeLeft--;
      notifyListeners();
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void dispose() {
    _stopTicker();
    super.dispose();
  }
}
