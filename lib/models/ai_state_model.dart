class AIStateModel {
  /// Per-complaint AI solution
  final Map<String, String> complaintSolutions;
  final Set<String> generatingSolutions;

  /// Global insights
  final Map<String, dynamic>? globalInsights;
  final String? globalCacheKey;

  final bool isGlobalLoading;
  final String? error;

  const AIStateModel({
    this.complaintSolutions = const {},
    this.generatingSolutions = const {},
    this.globalInsights,
    this.globalCacheKey,
    this.isGlobalLoading = false,
    this.error,
  });

  AIStateModel copyWith({
    Map<String, String>? complaintSolutions,
    Set<String>? generatingSolutions,
    Map<String, dynamic>? globalInsights,
    String? globalCacheKey,
    bool? isGlobalLoading,
    String? error,
  }) {
    return AIStateModel(
      complaintSolutions: complaintSolutions ?? this.complaintSolutions,
      generatingSolutions: generatingSolutions ?? this.generatingSolutions,
      globalInsights: globalInsights ?? this.globalInsights,
      globalCacheKey: globalCacheKey ?? this.globalCacheKey,
      isGlobalLoading: isGlobalLoading ?? this.isGlobalLoading,
      error: error,
    );
  }
}
