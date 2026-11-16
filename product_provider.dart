import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

enum SortOption { relevance, priceLowToHigh, priceHighToLow, ratingHighToLow, nameAsc }

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;

  List<ProductModel> _allProducts = [];
  List<CategoryModel> _categories = [];
  Set<String> _favoriteIds = {};

  bool _isLoading = false;
  String? _errorMessage;

  String _selectedCategory = 'all';
  String _searchQuery = '';
  SortOption _currentSort = SortOption.relevance;

  ProductProvider(this._apiService, this._storageService) {
    _loadFavorites();
    loadInitialData();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CategoryModel> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  SortOption get currentSort => _currentSort;
  Set<String> get favoriteIds => _favoriteIds;

  /// Returns products matching active filters, search query, and sort order
  List<ProductModel> get displayedProducts {
    var result = List<ProductModel>.from(_allProducts);

    // 1. Category Filter
    if (_selectedCategory.isNotEmpty && _selectedCategory != 'all') {
      result = result.where((p) {
        return p.category.toLowerCase().contains(_selectedCategory.toLowerCase()) ||
            p.category.toLowerCase().replaceAll(' ', '_') == _selectedCategory.toLowerCase();
      }).toList();
    }

    // 2. Search Query Filter
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      result = result.where((p) {
        return p.title.toLowerCase().contains(query) ||
            p.sku.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query) ||
            p.category.toLowerCase().contains(query) ||
            p.materialGrade.toLowerCase().contains(query);
      }).toList();
    }

    // 3. Sorting
    switch (_currentSort) {
      case SortOption.priceLowToHigh:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighToLow:
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.ratingHighToLow:
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.nameAsc:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.relevance:
      default:
        // Featured first, then original order
        result.sort((a, b) => (b.isFeatured ? 1 : 0).compareTo(a.isFeatured ? 1 : 0));
        break;
    }

    return result;
  }

  List<ProductModel> get featuredProducts =>
      _allProducts.where((p) => p.isFeatured).toList();

  List<ProductModel> get favoriteProducts =>
      _allProducts.where((p) => _favoriteIds.contains(p.id)).toList();

  int get favoritesCount => _favoriteIds.length;

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  // --- Actions ---

  Future<void> loadInitialData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final categoriesFuture = _apiService.fetchCategories();
      final productsFuture = _apiService.fetchProducts();

      final results = await Future.wait([categoriesFuture, productsFuture]);

      _categories = results[0] as List<CategoryModel>;
      _allProducts = results[1] as List<ProductModel>;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load catalog data. Please check connection and retry.';
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadInitialData();
  }

  void selectCategory(String categoryId) {
    if (_selectedCategory == categoryId) return;
    _selectedCategory = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void setSortOption(SortOption sort) {
    _currentSort = sort;
    notifyListeners();
  }

  // --- Favorites Persistence ---

  void _loadFavorites() {
    final list = _storageService.getFavorites();
    _favoriteIds = Set<String>.from(list);
    notifyListeners();
  }

  Future<void> toggleFavorite(String productId) async {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
    await _storageService.saveFavorites(_favoriteIds.toList());
  }
}
