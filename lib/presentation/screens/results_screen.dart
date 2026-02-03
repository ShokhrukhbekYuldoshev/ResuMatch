import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:resumatch/core/constants/colors.dart';
import 'package:resumatch/data/models/analysis_model.dart';
import 'package:resumatch/presentation/widgets/custom_app_bar.dart';
import '../widgets/match_score_gauge.dart';

class ResultsScreen extends StatefulWidget {
  final AnalysisResult data;
  const ResultsScreen({super.key, required this.data});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    if (widget.data.score >= 0.75) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;

    return Scaffold(
      extendBodyBehindAppBar: true,
      // Adaptive background based on theme
      backgroundColor: isDark ? BrandColors.bgDark : BrandColors.bgLight,
      appBar: CustomAppBar(title: "Analysis Result"),
      body: Stack(
        children: [
          _buildBackgroundGradient(isDark),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Spacer for the extended app bar
              const SliverToBoxAdapter(
                child: SizedBox(height: kToolbarHeight + 40),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildScoreCard(),
                    const SizedBox(height: 32),

                    _buildSectionLabel(
                      "AI INSIGHTS",
                      Icons.auto_awesome,
                      onSurface,
                    ),
                    const SizedBox(height: 12),
                    _buildGlassPanel(
                      isDark,
                      child: _buildSummaryText(onSurface),
                    ),

                    if (widget.data.missingSkills.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      _buildSectionLabel(
                        "KEY GAPS",
                        Icons.extension_off_rounded,
                        onSurface,
                      ),
                      const SizedBox(height: 12),
                      _buildSkillChips(isDark),
                    ],

                    const SizedBox(height: 32),
                    _buildSectionLabel(
                      "ROADMAP TO SUCCESS",
                      Icons.alt_route_rounded,
                      onSurface,
                    ),
                    const SizedBox(height: 12),
                    _buildGlassPanel(isDark, child: _buildTimeline(onSurface)),

                    const SizedBox(height: 120), // Extra room at bottom
                  ]),
                ),
              ),
            ],
          ),

          _buildConfettiOverlay(),
        ],
      ),
    );
  }

  Widget _buildBackgroundGradient(bool isDark) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                : [const Color(0xFFF1F5F9), const Color(0xFFE2E8F0)],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassPanel(bool isDark, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // Darker glass for dark mode, lighter for light mode
        color: isDark
            ? Colors.white.withValues(alpha: 0.02)
            : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.8),
          width: 1.5,
        ),
      ),
      child: child,
    );
  }

  Widget _buildScoreCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: BrandColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: BrandColors.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          MatchScoreGauge(score: widget.data.score),
          const SizedBox(height: 24),
          Text(
            "${(widget.data.score * 100).toInt()}% Match Score",
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryText(Color onSurface) {
    return Text(
      widget.data.summary,
      style: TextStyle(
        fontSize: 15,
        height: 1.7,
        color: onSurface.withValues(alpha: 0.8),
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildSkillChips(bool isDark) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: widget.data.missingSkills
          .map(
            (skill) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                // Using BrandColors for consistency
                color: BrandColors.error.withValues(alpha: isDark ? 0.1 : 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: BrandColors.error.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                skill,
                style: const TextStyle(
                  color: BrandColors.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildTimeline(Color onSurface) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.data.actionSteps.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: BrandColors.success,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.data.actionSteps[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: onSurface.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionLabel(String text, IconData icon, Color onSurface) {
    return Row(
      children: [
        Icon(icon, size: 16, color: BrandColors.primaryBlue),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildConfettiOverlay() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        colors: const [
          BrandColors.primaryBlue,
          BrandColors.success,
          Colors.orange,
        ],
        maxBlastForce: 20,
        minBlastForce: 5,
        emissionFrequency: 0.05,
      ),
    );
  }
}
