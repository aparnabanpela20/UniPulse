import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/complaint.dart';
import '../services/gemini_service.dart';
import '../services/ai_insights_service.dart';
import '../models/ai_state_model.dart';

final aiProvider = StateNotifierProvider<AiStateNotifier, AIStateModel>((ref) {
  return AiStateNotifier(GeminiService(), AiInsightsService());
});

class AiStateNotifier extends StateNotifier<AIStateModel> {
  final GeminiService _geminiService;
  final AiInsightsService _aiInsightsService;

  AiStateNotifier(this._geminiService, this._aiInsightsService)
    : super(const AIStateModel());

  String _generateGlobalCacheKey(Map<String, dynamic> complaintsMap) {
    final minimal = complaintsMap.entries.map((entry) {
      final data = entry.value as Map<String, dynamic>;

      return {
        'id': entry.key,
        'upvotes': data['upVotes'] ?? 0,
        'status': data['status'],
      };
    }).toList();

    return jsonEncode(minimal);
  }

  //GLobal Insights for all complaints
  Future<void> fetchGlobalInsights(Map<String, dynamic> complaintsMap) async {
    final newKey = _generateGlobalCacheKey(complaintsMap);

    if (state.globalCacheKey == newKey && state.globalInsights != null) {
      return;
    }

    state = state.copyWith(isGlobalLoading: true, error: null);

    try {
      final complaintsForAi = complaintsMap.entries.map((entry) {
        return {'id': entry.key, ...Map<String, dynamic>.from(entry.value)};
      }).toList();

      final insights = await _aiInsightsService.generateInsights(
        complaintsForAi,
      );

      state = state.copyWith(
        isGlobalLoading: false,
        globalInsights: insights,
        globalCacheKey: newKey,
      );
    } catch (e) {
      state = state.copyWith(isGlobalLoading: false, error: e.toString());
    }
  }

  //Per-complaint AI solution generation
  Future<void> generaetComplaintSolution({
    required String complaintId,
    required Map<String, dynamic> complaintData,
  }) async {
    // Avoid regenerating if already exists
    if (state.complaintSolutions.containsKey(complaintId)) {
      return;
    }

    //Already generating
    if (state.generatingSolutions.contains(complaintId)) {
      return;
    }

    // Mark as generating
    state = state.copyWith(
      generatingSolutions: {...state.generatingSolutions, complaintId},
      error: null,
    );

    try {
      final solution = await _geminiService.generateSolution(
        complaint: complaintData['complaint'],
        category: complaintData['category'],
        prefferedSolution: complaintData['preferredSolution'],
      );

      final updatedSolution = {
        ...state.complaintSolutions,
        complaintId: solution,
      };

      final updatedLoading = {...state.generatingSolutions}
        ..remove(complaintId);

      state = state.copyWith(
        complaintSolutions: updatedSolution,
        generatingSolutions: updatedLoading,
      );
    } catch (e) {
      final updatedLoading = {...state.generatingSolutions}
        ..remove(complaintId);

      state = state.copyWith(
        generatingSolutions: updatedLoading,
        error: e.toString(),
      );
    }
  }

  void invalidateGlobalInsights() {
    state = state.copyWith(globalInsights: null, globalCacheKey: null);
  }

  void invalidateComplaintSolution(String complaintId) {
    final updatedSolutions = {...state.complaintSolutions};
    updatedSolutions.remove(complaintId);

    state = state.copyWith(complaintSolutions: updatedSolutions);
  }
}
