part of 'analysis_bloc.dart';

sealed class AnalysisEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AnalyzeResumeRequested extends AnalysisEvent {
  final String resumeText;
  final String jobDescription;

  AnalyzeResumeRequested(this.resumeText, this.jobDescription);

  @override
  List<Object> get props => [resumeText, jobDescription];
}
