
import 'dart:math';

import '../../model/model_class.dart';


const _itemsPerPage = 10;
const _totalItems = 35;

class CategoryRepository {

  final Map<int, List<Category>> _mockDataCache = {};
  final Random _random = Random();


  Future<List<Category>> fetchCategories(int page) async {

    await Future.delayed(const Duration(seconds: 1));


    if (_random.nextInt(10) == 0 && page > 1) {
      throw Exception('Failed to load categories. Check connection.');
    }

    final startIndex = (page - 1) * _itemsPerPage;


    if (startIndex >= _totalItems) {
      return [];
    }

    if (!_mockDataCache.containsKey(page)) {
      final List<Category> pageData = [];
      final endIndex = min(startIndex + _itemsPerPage, _totalItems);
      for (int i = startIndex; i < endIndex; i++) {
        final id = 'cat_$i';
        pageData.add(
            Category(
              id: id,
              name: 'Category ${i + 1}',

              imageUrl: 'https://picsum.photos/seed/$id/200/200',
            )
        );
      }
      _mockDataCache[page] = pageData;
    }

    return _mockDataCache[page]!;
  }
}