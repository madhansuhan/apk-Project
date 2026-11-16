class ApiEndpoints {
  // Primary Public REST API Endpoint (Real public API for demonstration)
  static const String publicBaseUrl = 'https://dummyjson.com';
  static const String productsPath = '/products';
  static const String categoriesPath = '/products/categories';
  static const String searchPath = '/products/search';
  
  // Custom Sankar Group Catalog API Endpoint (Simulated enterprise endpoint)
  static const String sankarApiBaseUrl = 'https://api.sankargroup.com/v1';
  static const String sankarProducts = '/catalog/products';
  static const String sankarAuth = '/auth/login';
  static const String sankarInquiry = '/rfq/create';
  
  // Timeout settings
  static const Duration requestTimeout = Duration(seconds: 10);
}
