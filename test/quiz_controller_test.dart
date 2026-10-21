import 'package:flutter_test/flutter_test.dart';

import 'package:uts_affan/core/data/quiz_bank.dart';
import 'package:uts_affan/models/question.dart';
import 'package:uts_affan/state/quiz_controller.dart';

void main() {
  QuizController makeController() => QuizController();

  test('kuis dimulai dengan seluruh soal dan status berjalan', () {
    final c = makeController();
    addTearDown(c.dispose);

    c.start(playerName: '  Affan  ', withTimer: false);

    expect(c.status, QuizStatus.running);
    expect(c.currentIndex, 0);
    expect(c.totalQuestions, QuizBank.questions.length);
    expect(c.playerName, 'Affan');
    expect(c.score, 0);
  });

  test('jawaban benar menambah skor dan streak, jawaban salah mereset streak', () {
    final c = makeController();
    addTearDown(c.dispose);
    c.start(playerName: 'Ayu', withTimer: false);

    c.selectAnswer(c.currentQuestion.correctIndex);
    expect(c.status, QuizStatus.answered);
    expect(c.score, QuizController.basePoints);
    expect(c.streak, 1);
    expect(c.bestStreak, 1);

    c.next();
    c.selectAnswer(c.currentQuestion.correctIndex);
    expect(c.streak, 2);
    expect(c.bestStreak, 2);
    expect(c.score, 2 * QuizController.basePoints);

    // Salah (jawaban otomatis waktu habis memakai index -1).
    c.next();
    c.selectAnswer(-1);
    expect(c.streak, 0);
    expect(c.bestStreak, 2);
    expect(c.score, 2 * QuizController.basePoints);
  });

  test('mode timer memberi bonus sesuai sisa waktu', () {
    final c = makeController();
    addTearDown(c.dispose);
    c.start(playerName: 'Bima', withTimer: true);

    expect(c.timeLeft, QuizController.secondsPerQuestion);
    final expected =
        QuizController.basePoints +
        c.timeLeft * QuizController.timeBonusPerSecond;
    c.selectAnswer(c.currentQuestion.correctIndex);
    expect(c.score, expected);
  });

  test('jawaban tersimpan sampai selesai lalu buildResult akurat', () {
    final c = makeController();
    addTearDown(c.dispose);
    c.start(playerName: 'Affan', withTimer: false);

    final total = c.totalQuestions;
    for (var i = 0; i < total; i++) {
      // Genap: benar, ganjil: salah.
      c.selectAnswer(i.isEven ? c.currentQuestion.correctIndex : -1);
      c.next();
    }

    expect(c.status, QuizStatus.finished);
    expect(c.correctCount, (total / 2).ceil());

    final result = c.buildResult();
    expect(result.name, 'Affan');
    expect(result.total, total);
    expect(result.correct, (total / 2).ceil());
    expect(result.score, (total / 2).ceil() * QuizController.basePoints);
    expect(result.accuracy, closeTo(0.5, 0.01));

    // Setelah selesai, jawaban baru diabaikan.
    final frozen = c.score;
    c.selectAnswer(c.currentQuestion.correctIndex);
    expect(c.score, frozen);
  });

  test('filter kategori mengubah daftar soal', () {
    final c = makeController();
    addTearDown(c.dispose);

    c.start(
      playerName: 'Citra',
      withTimer: false,
      categories: const [QuizCategory.sains],
    );

    expect(
      c.totalQuestions,
      QuizBank.questions
          .where((q) => q.category == QuizCategory.sains)
          .length,
    );
    expect(c.questions.every((q) => q.category == QuizCategory.sains), isTrue);
  });

  test('mode acak mengacak urutan namun isi soal tetap sama', () {
    final c = makeController();
    addTearDown(c.dispose);

    c.start(playerName: 'Dewi', withTimer: false, shuffle: true);

    final asli = QuizBank.questions.map((q) => q.text).toSet();
    final acak = c.questions.map((q) => q.text).toSet();
    expect(acak, asli);
    expect(c.shuffled, isTrue);
  });

  test('restart memakai kategori dan mode terakhir', () {
    final c = makeController();
    addTearDown(c.dispose);

    c.start(
      playerName: 'Eka',
      withTimer: true,
      categories: const [QuizCategory.sejarah, QuizCategory.teknologi],
      shuffle: true,
    );
    c.selectAnswer(c.currentQuestion.correctIndex);
    c.next();

    c.restart();

    expect(c.status, QuizStatus.running);
    expect(c.currentIndex, 0);
    expect(c.score, 0);
    expect(c.withTimer, isTrue);
    expect(c.shuffled, isTrue);
    expect(
      c.totalQuestions,
      QuizBank.questions
          .where(
            (q) =>
                q.category == QuizCategory.sejarah ||
                q.category == QuizCategory.teknologi,
          )
          .length,
    );
  });
}
