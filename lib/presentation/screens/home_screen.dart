import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for Haptic Feedback
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resumatch/core/constants/colors.dart';
import 'package:resumatch/core/utils/helpers.dart';
import 'package:resumatch/presentation/widgets/custom_app_bar.dart';
import '../../logic/analysis/analysis_bloc.dart';
import '../../data/services/pdf_service.dart';
import 'results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _jdController = TextEditingController();
  String _resumeText = "";
  String _fileName = "No file selected";
  bool _isResumeUploaded = false;
  final _formKey = GlobalKey<FormState>();
  bool _formSubmitted = false;
  final PDFService _pdfService = PDFService();

  // Animation & Loading Logic
  late AnimationController _pulseController;
  int _messageIndex = 0;
  Timer? _tickerTimer;
  final List<String> _loadingMessages = [
    "Parsing your resume...",
    "Scanning job requirements...",
    "Identifying skill gaps...",
    "Consulting the AI engine...",
    "Generating your match score...",
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _stopLoadingTicker();
    _pulseController.dispose();
    _jdController.dispose();
    super.dispose();
  }

  void _handleFilePick() async {
    final result = await _pdfService.extractText();
    if (result != null && result["text"] != null) {
      if (result["text"]!.trim().isNotEmpty) {
        setState(() {
          _resumeText = result["text"]!;
          _fileName = result["name"]!;
          _isResumeUploaded = true;
        });
        if (mounted) {
          showSnackBar(context, "Resume parsed successfully!", isError: false);
        }
      } else {
        if (mounted) {
          showSnackBar(context, "The PDF seems to be empty.", isError: true);
        }
      }
    }
  }

  void _startLoadingTicker() {
    _stopLoadingTicker();
    _messageIndex = 0;
    _tickerTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(
          () => _messageIndex = (_messageIndex + 1) % _loadingMessages.length,
        );
      }
    });
  }

  void _stopLoadingTicker() {
    _tickerTimer?.cancel();
    _tickerTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: "ResuMatch AI"),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
          ),
        ),
        child: BlocConsumer<AnalysisBloc, AnalysisState>(
          listener: (context, state) {
            if (state is AnalysisLoading) {
              _startLoadingTicker();
            } else {
              _stopLoadingTicker();
            }

            if (state is AnalysisSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ResultsScreen(data: state.result),
                ),
              );
            }
            if (state is AnalysisFailure) {
              showSnackBar(context, state.error, isError: true);
            }
          },
          builder: (context, state) {
            final isLoading = state is AnalysisLoading;
            return Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _formSubmitted
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 32),
                          _buildSectionLabel("UPLOAD RESUME"),
                          _buildUploadCard(isDark),
                          _buildFileValidationError(),
                          const SizedBox(height: 32),
                          _buildSectionLabel("JOB DESCRIPTION"),
                          _buildJDInput(isDark),
                          const SizedBox(height: 48),
                          _buildAnalyzeButton(isLoading),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isLoading) _buildLoadingOverlay(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildUploadCard(bool isDark) {
    // Show error border only if submitted and not uploaded
    final bool showUploadError = _formSubmitted && !_isResumeUploaded;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: _handleFilePick,
          borderRadius: BorderRadius.circular(28),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: _isResumeUploaded
                  ? BrandColors.success.withValues(alpha: 0.1)
                  : (showUploadError
                        ? Colors.red.withValues(alpha: 0.05)
                        : BrandColors.primaryBlue.withValues(
                            alpha: isDark ? 0.05 : 0.1,
                          )),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: _isResumeUploaded
                    ? BrandColors.success
                    : (showUploadError
                          ? Colors.red
                          : BrandColors.primaryBlue.withValues(alpha: 0.3)),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                ScaleTransition(
                  scale: Tween(begin: 1.0, end: 1.1).animate(
                    CurvedAnimation(
                      parent: _pulseController,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          (_isResumeUploaded
                                  ? BrandColors.success
                                  : BrandColors.primaryBlue)
                              .withValues(alpha: 0.15),
                    ),
                    child: Icon(
                      _isResumeUploaded
                          ? Icons.check_circle_rounded
                          : Icons.cloud_upload_rounded,
                      size: 40,
                      color: _isResumeUploaded
                          ? BrandColors.success
                          : BrandColors.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _isResumeUploaded ? _fileName : "Select PDF Resume",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJDInput(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: BrandColors.primaryBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: BrandColors.primaryBlue.withValues(alpha: 0.2),
        ),
      ),
      child: TextFormField(
        controller: _jdController,
        maxLines: 5,
        style: const TextStyle(fontSize: 15),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please enter the job description";
          }
          if (value.trim().length < 5) {
            return "Description is too short to analyze";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "Paste job requirements here...",
          hintStyle: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          errorStyle: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton(bool isLoading) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: BrandColors.primaryGradient),
        boxShadow: [
          BoxShadow(
            color: BrandColors.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () {
                setState(() => _formSubmitted = true);

                if (_formKey.currentState!.validate() && _isResumeUploaded) {
                  HapticFeedback.mediumImpact();
                  context.read<AnalysisBloc>().add(
                    AnalyzeResumeRequested(_resumeText, _jdController.text),
                  );
                } else {
                  HapticFeedback.heavyImpact(); // Physical feedback for error
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          "START ANALYSIS",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildFileValidationError() {
    if (!_isResumeUploaded && _formSubmitted) {
      return const Padding(
        padding: EdgeInsets.only(top: 10, left: 10),
        child: Text(
          "⚠️ Resume is required",
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: BrandColors.primaryGradient,
          ).createShader(bounds),
          child: const Text(
            "Level up your\ncareer.",
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.0,
              letterSpacing: -1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Identify gaps and optimize your match score with AI.",
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          color: BrandColors.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Container(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                strokeWidth: 6,
                color: BrandColors.primaryBlue,
              ),
              const SizedBox(height: 40),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  _loadingMessages[_messageIndex],
                  key: ValueKey(_messageIndex),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
