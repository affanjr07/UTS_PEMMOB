import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/responsive/responsive.dart';
import '../core/theme/app_type.dart';
import '../models/question.dart';
import '../state/quiz_controller.dart';
import '../widgets/category_chip.dart';
import '../widgets/micro_label.dart';
import '../widgets/neo_card.dart';
import '../widgets/option_tile.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import '../widgets/stat_grid.dart';
import '../widgets/stat_tile.dart';

/// Layar pembahasan: menampilkan semua soal beserta jawaban user & kunci.
class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    final quiz = context.watch<QuizController>();
    final result = quiz.buildResult();
    final questions = quiz.questions;

    return Scaffold(
      body: SafeArea(
        child: ContentMaxWidth(
          padding: EdgeInsets.symmetric(horizontal: context.gap(18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.gap(14)),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: context.sz(42),
                      height: context.sz(42),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: palette.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: palette.border,
                          width: context.sz(1.6),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: palette.shadow,
                            offset: Offset(context.sz(3), context.sz(3)),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: context.sz(20),
                        color: palette.text,
                      ),
                    ),
                  ),
                  SizedBox(width: context.gap(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PEMBAHASAN',
                          style: AppType.labelStyle(
                            fontSize: context.fs(12),
                            color: palette.text,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          result.name,
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
                  CategoryChip(
                    label: '${result.correct}/${result.total}',
                    color: palette.success,
                    filled: true,
                  ),
                ],
              ),
              SizedBox(height: context.gap(14)),
              StatGrid(
                itemMinWidth: 120,
                children: [
                  StatTile(
                    label: 'Benar',
                    value: '${result.correct}',
                    icon: Icons.check_rounded,
                    accent: palette.success,
                  ),
                  StatTile(
                    label: 'Salah',
                    value: '${result.total - result.correct}',
                    icon: Icons.close_rounded,
                    accent: palette.danger,
                  ),
                  StatTile(
                    label: 'Skor',
                    value: '${result.score}',
                    icon: Icons.bolt_rounded,
                    accent: palette.accent,
                  ),
                ],
              ),
              SizedBox(height: context.gap(16)),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.only(bottom: context.gap(18)),
                  itemCount: questions.length,
                  separatorBuilder: (_, _) => SizedBox(height: context.gap(16)),
                  itemBuilder: (context, i) => _ReviewItem(
                    question: questions[i],
                    index: i,
                    answers: result.answers,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Beranda',
                      height: 50,
                      onPressed: () =>
                          Navigator.of(context).popUntil((r) => r.isFirst),
                    ),
                  ),
                  SizedBox(width: context.gap(12)),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Ulangi',
                      icon: Icons.replay_rounded,
                      height: 50,
                      onPressed: () {
                        quiz.restart();
                        Navigator.of(context).popUntil((r) => r.isFirst);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.gap(12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  const _ReviewItem({
    required this.question,
    required this.index,
    required this.answers,
  });

  final Question question;
  final int index;
  final List<int?> answers;

  @override
  Widget build(BuildContext context) {
    final palette = surfaceOf(context);
    final given = answers[index];
    final benar = given == question.correctIndex;

    OptionState stateFor(int i) {
      if (i == question.correctIndex) return OptionState.correct;
      if (i == given) return OptionState.wrong;
      return OptionState.dimmed;
    }

    return NeoCard(
      radius: 20,
      shadowOffset: 4,
      padding: EdgeInsets.all(context.gap(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: context.sz(30),
                height: context.sz(30),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: benar ? palette.success : palette.danger,
                  borderRadius: BorderRadius.circular(context.sz(9)),
                  border: Border.all(
                    color: palette.border,
                    width: context.sz(1.4),
                  ),
                ),
                child: Icon(
                  benar ? Icons.check_rounded : Icons.close_rounded,
                  size: context.sz(17),
                  color: palette.surface,
                ),
              ),
              SizedBox(width: context.gap(10)),
              CategoryChip(
                label: question.category.label,
                color: palette.accentAlt,
              ),
              const Spacer(),
              Text(
                'SOAL ${'${index + 1}'.padLeft(2, '0')}',
                style: AppType.labelStyle(
                  fontSize: context.fs(10),
                  color: palette.textSoft,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
          SizedBox(height: context.gap(12)),
          Text(
            question.text,
            style: AppType.displayStyle(
              fontSize: context.fs(15.5),
              color: palette.text,
              weight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          SizedBox(height: context.gap(13)),
          for (var i = 0; i < question.options.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: context.gap(9)),
              child: OptionTile(
                letter: String.fromCharCode(65 + i),
                text: question.options[i],
                state: stateFor(i),
                onTap: () {},
              ),
            ),
          if (given == null)
            Padding(
              padding: EdgeInsets.only(top: context.gap(4)),
              child: MicroLabel(
                'tidak terjawab Â· waktu habis',
                color: palette.danger,
                bulletColor: palette.danger,
                fontSize: 10,
              ),
            ),
          SizedBox(height: context.gap(10)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(context.gap(13)),
            decoration: BoxDecoration(
              color: palette.surfaceAlt,
              borderRadius: BorderRadius.circular(context.sz(13)),
              border: Border.all(color: palette.border, width: context.sz(1.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MicroLabel('catatan', color: palette.accent, fontSize: 10),
                SizedBox(height: context.gap(6)),
                Text(
                  question.explanation,
                  style: AppType.bodyStyle(
                    fontSize: context.fs(12.5),
                    color: palette.text,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
