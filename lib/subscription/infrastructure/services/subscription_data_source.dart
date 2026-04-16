import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thirstyseed/subscription/domain/entities/subscription_entity.dart';

class SubscriptionDataSource {
  final String apiUrl;

  SubscriptionDataSource(this.apiUrl);

  Future<bool> createSubscription(Subscription subscription) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(subscription.toJson()),
    );

    return response.statusCode == 201;
  }
}
