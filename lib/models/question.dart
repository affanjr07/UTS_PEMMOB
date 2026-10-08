enum QuizCategory {
  budaya('Budaya', 'BUD'),
  sejarah('Sejarah', 'SEJ'),
  sains('Sains', 'SAN'),
  teknologi('Teknologi', 'TEK'),
  geografi('Geografi', 'GEO');

  const QuizCategory(this.label, this.code);

  final String label;
  final String code;
}

class Question {
  const Question({
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.category,
    required this.explanation,
  });

  final String text;
  final List<String> options;
  final int correctIndex;
  final QuizCategory category;
  final String explanation;
}

class QuizResult {
  const QuizResult({
    required this.name,
    required this.correct,
    required this.total,
    required this.score,
    required this.bestStreak,
    required this.usedTimer,
    required this.elapsedSeconds,
    required this.answers,
  });

  final String name;
  final int correct;
  final int total;
  final int score;
  final int bestStreak;
  final bool usedTimer;
  final int elapsedSeconds;

  /// Daftar index jawaban user (null = tidak terjawab).
  final List<int?> answers;

  double get accuracy => total == 0 ? 0 : correct / total;

  String get grade {
    if (accuracy >= 0.9) return 'Sangat Paham';
    if (accuracy >= 0.75) return 'Paham';
    if (accuracy >= 0.5) return 'Cukup';
    if (accuracy >= 0.25) return 'Perlu Remedial';
    return 'Ayo Belajar Lagi';
  }
}
