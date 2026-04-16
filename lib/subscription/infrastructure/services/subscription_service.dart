import 'dart:math';
import 'package:thirstyseed/subscription/domain/entities/subscription_entity.dart';
import 'package:thirstyseed/subscription/infrastructure/services/subscription_data_source.dart';

class SubscriptionService {
  final SubscriptionDataSource dataSource;

  SubscriptionService(this.dataSource);

  Future<bool> createSubscription(int userId, String planType) async {
    final validationCode = _generateValidationCode();
    final nodeCount = (planType == 'PREMIUM') ? 5 : 12;

    final subscription = Subscription(
      userId: userId,
      planType: planType,
      nodeCount: nodeCount,
      validationCode: validationCode,
    );

    return await dataSource.createSubscription(subscription);
  }

  String _generateValidationCode() {
    const prefix = 'TSeed-';
    final random = Random();
    final code = List.generate(8, (_) => String.fromCharCode(random.nextInt(26) + 65)).join();
    return '$prefix$code';
  }
}
