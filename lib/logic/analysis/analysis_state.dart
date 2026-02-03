part of 'analysis_bloc.dart';

sealed class AnalysisState extends Equatable {
  @override
  List<Object> get props => [];
}

class AnalysisInitial extends AnalysisState {}

class AnalysisLoading extends AnalysisState {}

class AnalysisSuccess extends AnalysisState {
  final AnalysisResult result;
  AnalysisSuccess(this.result);
}

class AnalysisFailure extends AnalysisState {
  final String error;
  AnalysisFailure(this.error);
}
