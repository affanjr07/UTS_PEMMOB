import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/navigation/app_routes.dart';
import '../core/responsive/responsive.dart';
import '../core/theme/app_type.dart';
import '../models/question.dart';
import '../state/quiz_controller.dart';
import '../widgets/category_chip.dart';
import '../widgets/micro_label.dart';
import '../widgets/neo_card.dart';
import '../widgets/option_tile.dart';
import '../widgets/primary_button.dart';
import '../widgets/segmented_progress.dart';
import '../widgets/timer_dial.dart';
import 'result_screen.dart';

/// Halaman pengerjaan soal (StatefulWidget: animasi transisi & umpan balik jawaban).
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? _pending;
  bool _showExplanation = false;

  static const _delayBeforeLock = Duration(milliseconds: 430);

  Future<void> _pick(int index) async {
    final quiz = context.read<QuizController>();
    if (quiz.status != QuizStatus.running || _pending != null) return;
    setState(() => _pending = index);
    await Future<void>.delayed(_delayBeforeLock);
    if (!mounted) return;
    quiz.selectAnswer(index);
    setState(() {
      _pending = null;
      _showExplanation = true;
    });
  }

  void _next() {
    final quiz = context.read<QuizController>();
    if (quiz.isLastQuestion) {
      quiz.next();
      Navigator.of(context)
          .pushReplacement(fadeSlideRoute(const ResultScreen()));
    } else {
      quiz.next();
      setState(() => _showExplanation = false);
    }
  }

  Future<void> _confirmExit() async {
    final palette = surfaceOf(context);
    final result = await showModalBottomSheet<bool>(
      context: context,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          context.gap(22),
          context.gap(20),
          context.gap(22),
          context.gap(26) + context.mq.viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MicroLabel('Konfirmasi', color: palette.accent),
            SizedBox(height: context.gap(12)),
            Text(
              'Keluar dari kuis?',
              style: AppType.displayStyle(
                fontSize: context.fs(24),
                color: palette.text,
                weight: FontWeight.w700,
              ),
            ),
            SizedBox(height: context.gap(8)),
            Text(
              'Progres jawabanmu tersimpan dan bisa dilanjutkan kembali dari halaman awal.',
              style: AppType.bodyStyle(
                fontSize: context.fs(13.5),
                color: palette.textSoft,
              ),
            ),
            SizedBox(height: context.gap(20)),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'Tetap di sini',
                    color: palette.surface,
                    textColor: palette.text,
                    height: 50,
                    onPressed: () => Navigator.pop(sheetContext, false),
                  ),
                ),
                SizedBox(width: context.gap(12)),
                Expanded(
                  child: PrimaryButton(
                    label: 'Keluar',
                    color: palette.danger,
                    textColor: palette.surface,
                    height: 50,
                    onPressed: () => Navigator.pop(sheetContext, true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    if (result == true && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    final quiz = context.watch<QuizController>();
    final question = quiz.currentQuestion;
    final answered = quiz.status == QuizStatus.answered;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        body: SafeArea(
          child: ContentMaxWidth(
            padding: EdgeInsets.symmetric(horizontal: context.gap(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.gap(14)),
                _buildHeader(context, quiz, palette),
                SizedBox(height: context.gap(16)),
                SegmentedProgress(
                  total: quiz.totalQuestions,
                  current: quiz.currentIndex,
                  filled: quiz.answeredCount,
                ),
                SizedBox(height: context.gap(18)),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 380),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, anim) {
                      final curved = CurvedAnimation(
                        parent: anim,
                        curve: Curves.easeOutCubic,
                      );
                      return FadeTransition(
                        opacity: curved,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.08, 0),
                            end: Offset.zero,
                          ).animate(curved),
                          child: child,
                        ),
                      );
                    },
                    child: _QuestionBody(
                      key: ValueKey(quiz.currentIndex),
                      question: question,
                      quiz: quiz,
                      pending: _pending,
                      showExplanation: _showExplanation,
                      onPick: _pick,
                    ),
                  ),
                ),
                _buildBottomBar(context, quiz, palette, answered),
                SizedBox(height: context.gap(16)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    QuizController quiz,
    SurfacePalette palette,
  ) {
    return Row(
      children: [
        _IconSquare(icon: Icons.arrow_back_rounded, onTap: _confirmExit),
        SizedBox(width: context.gap(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SOAL ${quiz.currentIndex + 1} DARI ${quiz.totalQuestions}',
                style: AppType.labelStyle(
                  fontSize: context.fs(11.5),
                  color: palette.text,
                  letterSpacing: 1.8,
                ),
              ),
              SizedBox(height: context.gap(3)),
              Text(
                quiz.playerName.isEmpty ? 'Peserta' : quiz.playerName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppType.bodyStyle(
                  fontSize: context.fs(12),
                  color: palette.textSoft,
                ),
              ),
            ],
          ),
        ),
        if (quiz.streak >= 2)
          Padding(
            padding: EdgeInsets.only(right: context.gap(10)),
            child: CategoryChip(
              label: 'streak ${quiz.streak}',
              color: palette.accent,
              filled: true,
            ),
          ),
        if (quiz.withTimer)
          TimerDial(
            secondsLeft: quiz.timeLeft,
            secondsTotal: QuizController.secondsPerQuestion,
          )
        else
          Container(
            height: context.sz(42),
            padding: EdgeInsets.symmetric(horizontal: context.gap(12)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(context.sz(14)),
              border: Border.all(color: palette.border, width: context.sz(1.5)),
            ),
            child: Text(
              '${quiz.score}',
              style: AppType.displayStyle(
                fontSize: context.fs(17),
                color: palette.accent,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    QuizController quiz,
    SurfacePalette palette,
    bool answered,
  ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 340),
      switchInCurve: Curves.easeOutBack,
      transitionBuilder: (child, anim) {
        final curved = CurvedAnimation(
          parent: anim,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.4),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
      child: answered
          ? PrimaryButton(
              key: const ValueKey('next'),
              label: quiz.isLastQuestion ? 'Lihat Hasil' : 'Soal Berikutnya',
              icon: Icons.arrow_forward_rounded,
              onPressed: _next,
            )
          : Column(
              key: const ValueKey('hint'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.touch_app_rounded,
                      size: context.sz(15),
                      color: palette.textSoft,
                    ),
                    SizedBox(width: context.gap(7)),
                    Expanded(
                      child: Text(
                        quiz.withTimer
                            ? 'Pilih satu jawaban sebelum waktu habis'
                            : 'Pilih satu jawaban untuk lanjut',
                        style: AppType.bodyStyle(
                          fontSize: context.fs(12.5),
                          color: palette.textSoft,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.gap(12)),
                Container(
                  width: double.infinity,
                  height: context.sz(56),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: palette.surfaceAlt.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(context.sz(16)),
                    border: Border.all(
                      color: palette.border.withValues(alpha: 0.4),
                      width: context.sz(1.6),
                    ),
                  ),
                  child: Text(
                    'JAWABAN BELUM DIPILIH',
                    style: AppType.labelStyle(
                      fontSize: context.fs(12),
                      color: palette.textSoft.withValues(alpha: 0.8),
                      letterSpacing: 1.6,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _IconSquare extends StatelessWidget {
  const _IconSquare({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.sz(42),
        height: context.sz(42),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: palette.surface,
          shape: BoxShape.circle,
          border: Border.all(color: palette.border, width: context.sz(1.6)),
          boxShadow: [
            BoxShadow(
              color: palette.shadow,
              offset: Offset(context.sz(3), context.sz(3)),
              blurRadius: 0,
            ),
          ],
        ),
        child: Icon(icon, size: context.sz(20), color: palette.text),
      ),
    );
  }
}

class _QuestionBody extends StatelessWidget {
  const _QuestionBody({
    super.key,
    required this.question,
    required this.quiz,
    required this.pending,
    required this.showExplanation,
    required this.onPick,
  });

  final Question question;
  final QuizController quiz;
  final int? pending;
  final bool showExplanation;
  final ValueChanged<int> onPick;

  OptionState _stateFor(int i) {
    if (pending != null) {
      return i == pending ? OptionState.selected : OptionState.idle;
    }
    if (quiz.status == QuizStatus.answered) {
      if (i == question.correctIndex) return OptionState.correct;
      if (i == quiz.currentAnswer) return OptionState.wrong;
      return OptionState.dimmed;
    }
    return OptionState.idle;
  }

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);

    return SingleChildScrollView(
      key: const ValueKey('question-scroll'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CategoryChip(
                label: question.category.label,
                color: palette.accentAlt,
                filled: true,
              ),
              SizedBox(width: context.gap(9)),
              MicroLabel(
                'poin ${QuizController.basePoints}',
                color: palette.textSoft,
                fontSize: 10,
              ),
            ],
          ),
          SizedBox(height: context.gap(14)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${quiz.currentIndex + 1}'.padLeft(2, '0'),
                style: AppType.displayStyle(
                  fontSize: context.fs(54),
                  color: palette.accent,
                  weight: FontWeight.w800,
                  letterSpacing: -2,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: context.gap(9),
                  left: context.gap(6),
                ),
                child: Text(
                  '/${quiz.totalQuestions}',
                  style: AppType.displayStyle(
                    fontSize: context.fs(18),
                    color: palette.textSoft,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.gap(6)),
          Text(
            question.text,
            style: AppType.displayStyle(
              fontSize: context.fs(19),
              color: palette.text,
              weight: FontWeight.w700,
              height: 1.32,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: context.gap(18)),
          for (var i = 0; i < question.options.length; i++)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 700),
              builder: (context, value, child) {
                final t = Curves.easeOutCubic.transform(
                  Interval(
                    i * 0.07,
                    (i * 0.07 + 0.5).clamp(0.0, 1.0),
                  ).transform(value.clamp(0.0, 1.0)),
                );
                return Opacity(
                  opacity: t,
                  child: Transform.translate(
                    offset: Offset(0, 16 * (1 - t)),
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: context.gap(11)),
                child: OptionTile(
                  letter: String.fromCharCode(65 + i),
                  text: question.options[i],
                  state: _stateFor(i),
                  index: i,
                  onTap: () => onPick(i),
                ),
              ),
            ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 360),
            switchInCurve: Curves.easeOutCubic,
            transitionBuilder: (child, anim) {
              final curved = CurvedAnimation(
                parent: anim,
                curve: Curves.easeOutCubic,
              );
              return FadeTransition(
                opacity: curved,
                child: SizeTransition(
                  sizeFactor: curved,
                  alignment: Alignment.topCenter,
                  child: child,
                ),
              );
            },
            child: showExplanation
                ? Padding(
                    padding: EdgeInsets.only(top: context.gap(4)),
                    child: NeoCard(
                      key: const ValueKey('explanation'),
                      color: palette.surfaceAlt,
                      shadowOffset: 3,
                      radius: 16,
                      padding: EdgeInsets.all(context.gap(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MicroLabel(
                            'Pembahasan',
                            color: palette.accent,
                            bulletColor: palette.accent,
                            fontSize: 10,
                          ),
                          SizedBox(height: context.gap(8)),
                          Text(
                            question.explanation,
                            style: AppType.bodyStyle(
                              fontSize: context.fs(13),
                              color: palette.text,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          SizedBox(height: context.gap(8)),
        ],
      ),
    );
  }
}
