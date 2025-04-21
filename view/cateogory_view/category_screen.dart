import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import ProviderScope

import '../../viewModel/providers/providers.dart';

import '../Widgets/category_grid.dart';
import '../Widgets/widgets.dart';
import '../home_Navigation/home_screen.dart';

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ProviderScope(
      child: MaterialApp(
        title: 'Category App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}


class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key}); // Use const constructor

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {

      ref.read(categoryNotifierProvider.notifier).loadMoreCategories();
    }
  }

  @override
  Widget build(BuildContext context) {

    final categoryState = ref.watch(categoryNotifierProvider);


    if (categoryState.isLoading && categoryState.categories.isEmpty) {
      return const LoadingIndicator();
    }


    if (categoryState.errorMessage != null && categoryState.categories.isEmpty) {
      return ErrorDisplay(
        message: categoryState.errorMessage!,

        onRetry: () => ref.read(categoryNotifierProvider.notifier).retryInitialLoad(),
      );
    }


    if (categoryState.categories.isEmpty && !categoryState.isLoading) {
      return const Center(
        child: Text('No categories found. Try refreshing!'), // Or a more friendly message
      );
    }

    // Success State - Display Grid + Pagination Indicator
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columns
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.0, // Adjust aspect ratio as needed
      ),

      itemCount: categoryState.categories.length +
          (categoryState.isLoadingMore || categoryState.hasReachedMax ? 1 : 0),
      itemBuilder: (context, index) {
        // Check if this is the last item slot (for loading/end indicator)
        if (index == categoryState.categories.length) {
          if (categoryState.isLoadingMore) {
            return const LoadingIndicator(size: 30.0); // Smaller indicator
          } else if (categoryState.hasReachedMax) {
            return const Center(child: Text("End of list"));
          } else {
            return const SizedBox.shrink(); // Should not happen, but be safe
          }
        }

        // Display the actual category item
        final category = categoryState.categories[index];
        return CategoryGridItem(category: category);
      },
    );
  }
}