import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/navigation/app_routes.dart';
import '../core/responsive/responsive.dart';
import '../core/theme/app_type.dart';
import '../state/quiz_controller.dart';
import '../widgets/category_chip.dart';
import '../widgets/decor_background.dart';
import '../widgets/micro_label.dart';
import '../widgets/neo_card.dart';
import '../widgets/primary_button.dart';
import '../widgets/score_ring.dart';
import '../widgets/secondary_button.dart';
import '../widgets/stat_grid.dart';
import '../widgets/stat_tile.dart';
import 'quiz_screen.dart';
import 'review_screen.dart';
import 'welcome_screen.dart';

/// Layar hasil akhir (StatelessWidget: seluruh state berasal dari QuizController).
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  Color _gradeColor(BuildContext context, double accuracy) {
    final palette = surfaceOf(context);
    if (accuracy >= 0.75) return palette.success;
    if (accuracy >= 0.5) return palette.muted;
    return palette.danger;
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    final quiz = context.watch<QuizController>();
    final result = quiz.buildResult();
    final gradeColor = _gradeColor(context, result.accuracy);

    return Scaffold(
      body: DecorBackground(
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: context.gap(30)),
            child: ContentMaxWidth(
              padding: EdgeInsets.symmetric(horizontal: context.gap(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.gap(16)),
                  Row(
                    children: [
                      MicroLabel('Hasil kuis', color: palette.accent),
                      const Spacer(),
                      Text(
                        result.usedTimer ? 'MODE TIMER' : 'TANPA TIMER',
                        style: AppType.labelStyle(
                          fontSize: context.fs(10),
                          color: palette.textSoft,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.gap(18)),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: context.sz(230)),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          ScoreRing(
                            progress: result.accuracy,
                            size: 210,
                            progressColor: gradeColor,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TweenAnimationBuilder<int>(
                                  tween: IntTween(begin: 0, end: result.score),
                                  duration: const Duration(milliseconds: 1300),
                                  curve: Curves.easeOutExpo,
                                  builder: (context, value, _) => Text(
                                    '$value',
                                    style: AppType.displayStyle(
                                      fontSize: context.fs(44),
                                      color: palette.text,
                                      weight: FontWeight.w800,
                                      letterSpacing: -1.5,
                                    ),
                                  ),
                                ),
                                MicroLabel(
                                  'total skor',
                                  color: palette.textSoft,
                                  fontSize: 10,
                                  withBullet: false,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: context.sz(-26),
                            right: context.sz(-6),
                            child: SvgPicture.asset(
                              'assets/images/trophy.svg',
                              width: context.sz(76),
                              semanticsLabel: 'Piala',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: context.gap(22)),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '${result.correct} dari ${result.total} benar Â· '
                          '${(result.accuracy * 100).round()}% ketepatan',
                          style: AppType.bodyStyle(
                            fontSize: context.fs(13),
                            color: palette.textSoft,
                          ),
                        ),
                        SizedBox(height: context.gap(14)),
                        Text(
                          'Halo, ${result.name}!',
                          textAlign: TextAlign.center,
                          style: AppType.displayStyle(
                            fontSize: context.fs(30),
                            color: palette.text,
                            weight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),
                        SizedBox(height: context.gap(10)),
                        CategoryChip(
                          label: 'predikat: ${result.grade}',
                          color: gradeColor,
                          filled: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.gap(24)),
                  StatGrid(
                    children: [
                      StatTile(
                        label: 'Skor',
                        value: '${result.score}',
                        icon: Icons.workspace_premium_rounded,
                        accent: palette.accent,
                      ),
                      StatTile(
                        label: 'Jawaban benar',
                        value: '${result.correct}',
                        icon: Icons.check_rounded,
                        accent: palette.success,
                      ),
                      StatTile(
                        label: 'Jawaban salah',
                        value: '${result.total - result.correct}',
                        icon: Icons.close_rounded,
                        accent: palette.danger,
                      ),
                      StatTile(
                        label: 'Streak terbaik',
                        value: '${result.bestStreak}',
                        icon: Icons.local_fire_department_rounded,
                        accent: palette.accentAlt,
                      ),
                      StatTile(
                        label: 'Ketepatan',
                        value: '${(result.accuracy * 100).round()}%',
                        icon: Icons.track_changes_rounded,
                        accent: palette.muted,
                      ),
                      StatTile(
                        label: 'Waktu',
                        value: _formatDuration(result.elapsedSeconds),
                        icon: Icons.schedule_rounded,
                        accent: palette.accentAlt,
                      ),
                    ],
                  ),
                  SizedBox(height: context.gap(26)),
                  NeoCard(
                    color: palette.surfaceAlt,
                    shadowOffset: 4,
                    padding: EdgeInsets.all(context.gap(16)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.insights_rounded,
                          size: context.sz(22),
                          color: palette.accent,
                        ),
                        SizedBox(width: context.gap(12)),
                        Expanded(
                          child: Text(
                            'Skor dihitung dari ${result.total} soal '
                            '${result.usedTimer ? '+ bonus sisa waktu tiap jawaban benar' : 'tanpa bonus waktu'}.'
                            ' Pelajari pembahasan untuk soal yang belum tepat.',
                            style: AppType.bodyStyle(
                              fontSize: context.fs(12.5),
                              color: palette.text,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.gap(22)),
                  SecondaryButton(
                    label: 'Lihat Pembahasan',
                    icon: Icons.menu_book_rounded,
                    onPressed: () =>
                        Navigator.of(context)
                            .push(fadeSlideRoute(const ReviewScreen())),
                  ),
                  SizedBox(height: context.gap(12)),
                  PrimaryButton(
                    label: 'Ulangi Kuis',
                    icon: Icons.replay_rounded,
                    onPressed: () {
                      quiz.restart();
                      Navigator.of(context)
                          .pushReplacement(fadeSlideRoute(const QuizScreen()));
                    },
                  ),
                  SizedBox(height: context.gap(10)),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        fadeSlideRoute(const WelcomeScreen()),
                        (route) => false,
                      ),
                      child: Text(
                        'KEMBALI KE BERANDA',
                        style: AppType.labelStyle(
                          fontSize: context.fs(12),
                          color: palette.textSoft,
                          letterSpacing: 1.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
