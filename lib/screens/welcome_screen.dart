import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/navigation/app_routes.dart';
import '../core/responsive/responsive.dart';
import '../core/theme/app_type.dart';
import '../state/quiz_controller.dart';
import '../state/theme_controller.dart';
import '../widgets/brand_logo.dart';
import '../widgets/decor_background.dart';
import '../widgets/marquee_ticker.dart';
import '../widgets/micro_label.dart';
import '../widgets/neo_card.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import 'quiz_screen.dart';

/// Halaman pembuka: input nama peserta + pengaturan sebelum mulai.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();

  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat(reverse: true);

  String? _error;
  bool _useTimer = true;

  @override
  void initState() {
    super.initState();
    _entrance.forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _shake.dispose();
    _float.dispose();
    _nameController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  Widget _stagger(int index, Widget child, {double from = 26}) {
    final start = (index * 0.075).clamp(0.0, 0.7);
    final curve = Interval(
      start,
      (start + 0.45).clamp(0.0, 1.0),
      curve: Curves.easeOutCubic,
    );
    return AnimatedBuilder(
      animation: _entrance,
      builder: (context, _) {
        final t = curve.transform(_entrance.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, from * (1 - t)),
            child: child,
          ),
        );
      },
    );
  }

  void _startQuiz() {
    final name = _nameController.text.trim();
    if (name.length < 2) {
      setState(() => _error = 'Nama minimal 2 karakter, ya!');
      _shake.forward(from: 0);
      _nameFocus.requestFocus();
      return;
    }
    setState(() => _error = null);
    context.read<QuizController>().start(
      playerName: name,
      withTimer: _useTimer,
    );
    Navigator.of(context).push(fadeSlideRoute(const QuizScreen()));
  }

  void _resumeQuiz() {
    Navigator.of(context).push(fadeSlideRoute(const QuizScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    final themeCtrl = context.watch<ThemeController>();
    final quiz = context.watch<QuizController>();
    final canResume = quiz.status == QuizStatus.running;

    return Scaffold(
      body: DecorBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              MarqueeTicker(
                text: 'KUIS PILIHAN GANDA  •  12 SOAL  •  5 KATEGORI  •  ',
                backgroundColor: palette.text,
                textColor: palette.background,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: context.gap(28)),
                  child: ContentMaxWidth(
                    padding: EdgeInsets.symmetric(horizontal: context.gap(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: context.gap(16)),
                        _stagger(
                          0,
                          Row(
                            children: [
                              const BrandLogo(size: 52),
                              SizedBox(width: context.gap(12)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'NALAR NUSANTARA',
                                      style: AppType.labelStyle(
                                        fontSize: context.fs(12),
                                        color: palette.text,
                                        letterSpacing: 2.2,
                                      ),
                                    ),
                                    Text(
                                      'Kuis Pengetahuan Umum',
                                      style: AppType.bodyStyle(
                                        fontSize: context.fs(11.5),
                                        color: palette.textSoft,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _ThemeToggle(controller: themeCtrl),
                            ],
                          ),
                        ),
                        SizedBox(height: context.gap(22)),
                        _stagger(1, _HeroIllustration(controller: _float)),
                        SizedBox(height: context.gap(24)),
                        _stagger(
                          2,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MicroLabel(
                                'Uji pengetahuanmu',
                                color: palette.accent,
                                bulletColor: palette.accent,
                              ),
                              SizedBox(height: context.gap(10)),
                              Text(
                                'Seberapa\nPaham Kamu?',
                                style: AppType.displayStyle(
                                  fontSize: context.fs(38),
                                  color: palette.text,
                                  weight: FontWeight.w800,
                                  height: 0.98,
                                  letterSpacing: -1.4,
                                ),
                              ),
                              SizedBox(height: context.gap(12)),
                              Text(
                                'Jawab 12 pertanyaan pilihan ganda dari lima kategori, '
                                'lihat skor akhirmu dan review pembahasannya.',
                                style: AppType.bodyStyle(
                                  fontSize: context.fs(14),
                                  color: palette.textSoft,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: context.gap(26)),
                        _stagger(3, _buildForm(palette)),
                        SizedBox(height: context.gap(22)),
                        _stagger(
                          4,
                          PrimaryButton(
                            label: 'Mulai Kuis',
                            icon: Icons.arrow_forward_rounded,
                            onPressed: _startQuiz,
                          ),
                        ),
                        if (canResume) ...[
                          SizedBox(height: context.gap(12)),
                          _stagger(
                            5,
                            SecondaryButton(
                              label:
                                  'Lanjutkan (${quiz.answeredCount}/${quiz.totalQuestions})',
                              icon: Icons.play_arrow_rounded,
                              onPressed: _resumeQuiz,
                            ),
                          ),
                        ],
                        SizedBox(height: context.gap(20)),
                        Center(
                          child: Text(
                            'UTS Lab Pemrograman Mobile · Affan',
                            textAlign: TextAlign.center,
                            style: AppType.labelStyle(
                              fontSize: context.fs(10),
                              color: palette.textSoft.withValues(alpha: 0.8),
                              letterSpacing: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(SurfacePalette palette) {
    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        final t = Curves.elasticOut.transform(_shake.value);
        final dx = (1 - t) * 10 * (_shake.value < 0.5 ? 1 : -1);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: NeoCard(
        radius: 22,
        shadowOffset: 6,
        padding: EdgeInsets.all(context.gap(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MicroLabel('Identitas peserta', color: palette.textSoft),
            SizedBox(height: context.gap(12)),
            TextField(
              controller: _nameController,
              focusNode: _nameFocus,
              textCapitalization: TextCapitalization.words,
              maxLength: 20,
              style: AppType.bodyStyle(
                fontSize: context.fs(16),
                color: palette.text,
                weight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText: 'Tulis namamu di sini...',
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  size: context.sz(20),
                  color: palette.textSoft,
                ),
              ),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              onSubmitted: (_) => _startQuiz(),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: _error == null
                  ? const SizedBox(width: double.infinity)
                  : Padding(
                      padding: EdgeInsets.only(top: context.gap(10)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: context.sz(16),
                            color: palette.danger,
                          ),
                          SizedBox(width: context.gap(6)),
                          Expanded(
                            child: Text(
                              _error!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppType.bodyStyle(
                                fontSize: context.fs(12.5),
                                color: palette.danger,
                                weight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            Divider(height: context.gap(24), thickness: 1.4),
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: context.sz(20),
                  color: palette.accent,
                ),
                SizedBox(width: context.gap(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MODE TIMER',
                        style: AppType.labelStyle(
                          fontSize: context.fs(11),
                          color: palette.text,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        '20 detik per soal, skor bonus sisa waktu',
                        style: AppType.bodyStyle(
                          fontSize: context.fs(11.5),
                          color: palette.textSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _useTimer,
                  onChanged: (v) => setState(() => _useTimer = v),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle({required this.controller});

  final ThemeController controller;

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    final isDark = controller.isDark;

    return GestureDetector(
      onTap: controller.toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        width: context.sz(44),
        height: context.sz(44),
        decoration: BoxDecoration(
          color: isDark ? palette.accent : palette.surface,
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
        child: AnimatedRotation(
          turns: isDark ? 0.5 : 0,
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutBack,
          child: Icon(
            isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
            size: context.sz(20),
            color: isDark ? palette.surface : palette.accent,
          ),
        ),
      ),
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = Curves.easeInOutSine.transform(controller.value);
        return Transform.translate(
          offset: Offset(0, context.gap(10) * (t - 0.5) * 2),
          child: child,
        );
      },
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.sz(246)),
          child: SvgPicture.asset(
            'assets/images/hero_illustration.svg',
            semanticsLabel: 'Ilustrasi kuis',
          ),
        ),
      ),
    );
  }
}
