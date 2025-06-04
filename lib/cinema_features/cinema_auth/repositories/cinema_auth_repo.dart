class CinemaAuthRepository {
  Future<bool> login(String phone, String password) async {
    // Implement actual login logic with API call
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return true; // Return true if login succeeds
  }

  Future<bool> signup(String name, String phone, String password, String location) async {
    // Implement actual signup logic with API call
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return true; // Return true if signup succeeds
  }
}