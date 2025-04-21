
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/model_class.dart';
import '../repository/repository.dart';



class CategoryState {
  final List<Category> categories;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String? errorMessage;
  final int currentPage;


  const CategoryState({
    this.categories = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.errorMessage,
    this.currentPage = 1,
  });


  factory CategoryState.initial() {
    return const CategoryState(isLoading: true);
  }


  CategoryState copyWith({
    List<Category>? categories,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? errorMessage,
    bool clearError = false,
    int? currentPage,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,

      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

// 2. Create the StateNotifier
class CategoryNotifier extends StateNotifier<CategoryState> {
  final CategoryRepository _repository;

  CategoryNotifier(this._repository) : super(CategoryState.initial()) {
    _loadInitialCategories(); // Load data when notifier is first created
  }

  Future<void> _loadInitialCategories() async {

    try {
      final initialCategories = await _repository.fetchCategories(1);
      state = state.copyWith(
        categories: initialCategories,
        isLoading: false,
        currentPage: 1,
        // If initial load returns empty, we might consider it "max reached"
        hasReachedMax: initialCategories.isEmpty,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> loadMoreCategories() async {

    if (state.isLoadingMore || state.hasReachedMax || state.isLoading) {
      return;
    }

    state = state.copyWith(isLoadingMore: true, clearError: true); // Clear previous errors on new attempt

    try {
      final nextPage = state.currentPage + 1;
      final newCategories = await _repository.fetchCategories(nextPage);

      if (newCategories.isEmpty) {
        // No more data found
        state = state.copyWith(hasReachedMax: true, isLoadingMore: false);
      } else {
        state = state.copyWith(
          categories: [...state.categories, ...newCategories],
          currentPage: nextPage,
          isLoadingMore: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        isLoadingMore: false,
      );

    }
  }


  Future<void> retryInitialLoad() async {
    state = CategoryState.initial(); // Reset to initial loading state
    await _loadInitialCategories();
  }
}


final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});


final categoryNotifierProvider =
StateNotifierProvider<CategoryNotifier, CategoryState>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return CategoryNotifier(repository);
});