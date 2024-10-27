class ApiConstants {
  static const baseUrlProd = "http://localhost:3000";
  static const baseUrlDebug = "http://localhost:3000";

  // Getter to dynamically return the base URL based on environment
  static String get currentBaseUrl {
    const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;
    return isDebug ? baseUrlDebug : baseUrlProd;
  }
}
