class Config {
  // Base URL untuk semua API endpoints
  static const String baseUrl = 'https://hamatech.rplrus.com/api';

  // Storage URL untuk gambar dan file
  static const String storageUrl = 'https://hamatech.rplrus.com/storage';

  // Image base URL (dengan trailing slash)
  static const String imageBaseUrl = 'https://hamatech.rplrus.com/storage/';

  // Timeout duration untuk HTTP requests
  static const Duration requestTimeout = Duration(seconds: 30);

  // Common headers
  static const Map<String, String> commonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'ngrok-skip-browser-warning': '1',
  };

  // Helper method untuk mendapatkan full URL
  static String getApiUrl(String endpoint) {
    // Pastikan endpoint dimulai dengan '/'
    if (!endpoint.startsWith('/')) {
      endpoint = '/$endpoint';
    }
    return '$baseUrl$endpoint';
  }

  // Helper method untuk mendapatkan storage URL
  static String getStorageUrl(String path) {
    if (path.startsWith('http')) {
      return path; // Sudah full URL
    }
    // Remove leading slash jika ada
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    return '$storageUrl/$path';
  }

  // Helper method untuk mendapatkan image URL
  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return 'assets/images/example.png'; // Default image
    }

    if (imagePath.startsWith('http')) {
      return imagePath; // Sudah full URL
    }

    // Remove leading slash jika ada
    if (imagePath.startsWith('/')) {
      imagePath = imagePath.substring(1);
    }

    return '$imageBaseUrl$imagePath';
  }
}