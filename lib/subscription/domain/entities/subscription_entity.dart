class Subscription {
  final int userId;
  final String planType;
  final int nodeCount;
  final String validationCode;

  Subscription({
    required this.userId,
    required this.planType,
    required this.nodeCount,
    required this.validationCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'planType': planType,
      'nodeCount': nodeCount,
      'validationCode': validationCode,
    };
  }
}

