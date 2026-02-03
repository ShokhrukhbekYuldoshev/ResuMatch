import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resumatch/data/models/analysis_model.dart';
import 'package:resumatch/data/services/ai_service.dart';

part 'analysis_event.dart';
part 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final AIService aiService;

  AnalysisBloc(this.aiService) : super(AnalysisInitial()) {
    on<AnalyzeResumeRequested>((event, emit) async {
      emit(AnalysisLoading());
      try {
        final rawResult = await aiService.analyzeResume(
          event.resumeText,
          event.jobDescription,
        );

        // Clean the string in case AI adds markdown code blocks
        final cleanJson = rawResult
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        final Map<String, dynamic> jsonData = jsonDecode(cleanJson);
        final analysisModel = AnalysisResult.fromJson(jsonData);

        emit(
          AnalysisSuccess(analysisModel),
        ); // Now passing the Model, not String
      } catch (e) {
        emit(AnalysisFailure("Failed to parse AI response: $e"));
      }
    });
  }
}
