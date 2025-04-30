class AuthService {
  // Dummy authentication logic
  Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Dummy validation
    if (email.isNotEmpty && password.length >= 6) {
      return true;
    }
    return false;
  }

  Future<bool> signup(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Dummy validation
    if (email.isNotEmpty && password.length >= 6) {
      return true;
    }
    return false;
  }
} 