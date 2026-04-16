class PlanType {
  static const premium = 'PREMIUM';
  static const plus = 'PLUS';

  final String value;

  PlanType(this.value) {
    if (value != premium && value != plus) {
      throw ArgumentError('Invalid plan type: $value');
    }
  }

  int get nodeCount {
    return value == premium ? 5 : 12;
  }

  static bool isValid(String type) {
    return type == premium || type == plus;
  }
}
