import 'package:flutter/material.dart';
import 'package:thirstyseed/subscription/infrastructure/services/subscription_data_source.dart';
import '../infrastructure/services/subscription_service.dart';

class SelectPlanScreen extends StatefulWidget {
  final int userId;

  const SelectPlanScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _SelectPlanScreenState createState() => _SelectPlanScreenState();
}

class _SelectPlanScreenState extends State<SelectPlanScreen> {
  String? selectedPlan;
  bool isLoading = false;
  late SubscriptionService subscriptionService;

  @override
  void initState() {
    super.initState();
    final dataSource = SubscriptionDataSource(
        'https://thirstyseedapi-production.up.railway.app/api/v1/subscriptions');
    subscriptionService = SubscriptionService(dataSource);
  }

  void _openPaymentDialog() {
    if (selectedPlan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona un plan.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pago',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Número de tarjeta',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Fecha de expiración',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context); // Cierra el modal
                    await _makePayment();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Vamos',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _makePayment() async {
    setState(() {
      isLoading = true;
    });

    try {
      final success =
          await subscriptionService.createSubscription(widget.userId, selectedPlan!);

      setState(() {
        isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pago realizado con éxito')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al procesar el pago')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creando suscripción: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Selecciona tu Plan',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPlanCard(
                    title: 'PREMIUM',
                    description: 'Monitorización básica con 5 sensores.',
                    price: 7,
                    onSelect: () => setState(() {
                      selectedPlan = 'PREMIUM';
                    }),
                    isSelected: selectedPlan == 'PREMIUM',
                  ),
                  const SizedBox(width: 20),
                  _buildPlanCard(
                    title: 'PLUS',
                    description: 'Automatización avanzada con 12 sensores.',
                    price: 15,
                    onSelect: () => setState(() {
                      selectedPlan = 'PLUS';
                    }),
                    isSelected: selectedPlan == 'PLUS',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _openPaymentDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Pagar',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String description,
    required int price,
    required VoidCallback onSelect,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          border: Border.all(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '\$$price',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
