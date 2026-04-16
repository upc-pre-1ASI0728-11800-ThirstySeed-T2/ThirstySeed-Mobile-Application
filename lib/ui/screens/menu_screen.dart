import 'package:flutter/material.dart';
import 'package:thirstyseed/iam/application/auth_service.dart';
import 'package:thirstyseed/iam/domain/entities/auth_entity.dart';
import 'package:thirstyseed/irrigation/application/plot_service.dart';
import 'package:thirstyseed/irrigation/application/schedule_service.dart';
import 'package:thirstyseed/irrigation/infrastructure/data_sources/plot_data_source.dart';
import 'package:thirstyseed/irrigation/infrastructure/data_sources/schedule_data_source.dart';
import 'package:thirstyseed/irrigation/infrastructure/repositories/plot_repository.dart';
import 'package:thirstyseed/irrigation/infrastructure/repositories/schedule_repository.dart';
import 'package:thirstyseed/irrigation/presentation/plot_screen.dart';
import 'package:thirstyseed/irrigation/presentation/plot_status_screen.dart';
import 'package:thirstyseed/irrigation/presentation/schedule/schedule_list_screen.dart';
import 'package:thirstyseed/profile/domain/entities/profile_entity.dart';
import 'package:thirstyseed/profile/infrastructure/data_sources/profile_data_source.dart';
import 'package:thirstyseed/profile/presentation/view_account_profile.dart';

class MenuScreen extends StatefulWidget {
  final AuthService authService;
  final UserAuth currentUser;

  const MenuScreen({super.key, required this.authService, required this.currentUser});

  @override
  MenuScreenState createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {
  Future<ProfileEntityGet?> _fetchUserProfile(int userId) async {
    print('Fetching user profile with id: $userId'); // Debug
    final profileDataSource = ProfileDataSource();
    try {
      return await profileDataSource.getProfileByUserId(userId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener el perfil: $e')),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        
        body: Column(
          children: [
            // Header adaptado
            Container(
              width: double.infinity,
              color: Colors.green[100],
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.03,
                horizontal: screenWidth * 0.04,
              ),
              child: Row(
                children: [
                  Icon(Icons.eco, color: Colors.green, size: screenWidth * 0.1),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    'Thirsty Seed',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.06,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // GridView adaptado
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(screenWidth * 0.04),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: screenWidth * 0.04,
                  mainAxisSpacing: screenHeight * 0.02,
                  childAspectRatio: 0.98, // Mantener proporción cuadrada
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final menuOptions = [
                    {
                      "icon": Icons.settings,
                      "text": "Administrar parcelas",
                      "color": Colors.green,
                      "onTap": () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PlotScreen(userId: widget.currentUser.id)),
                        );
                      }
                    },
                    {
                      "icon": Icons.remove_red_eye,
                      "text": "Ver estado de parcelas",
                      "color": Colors.blue,
                      "onTap": () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlotStatusScreen(userId: widget.currentUser.id),
                          ),
                        );
                      }
                    },
                    {
                      "icon": Icons.schedule,
                      "text": "Riegos programados",
                      "color": Colors.teal,
                      "onTap": () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            final plotDataSource = PlotDataSource();
                            final plotRepository = PlotRepository(dataSource: plotDataSource);
                            final plotService = PlotService(repository: plotRepository);
                            final scheduleDataSource = ScheduleDataSource();
                            final scheduleRepository = ScheduleRepository(dataSource: scheduleDataSource);
                            final scheduleService = ScheduleService(repository: scheduleRepository);
                            return ScheduleListScreen(scheduleService: scheduleService, plotService: plotService);
                          }),
                        );
                      }
                    },
                    {
                      "icon": Icons.person,
                      "text": "Ver Perfil",
                      "color": Colors.green,
                      "onTap": () async {
                        final userId = widget.currentUser.id;
                        final profile = await _fetchUserProfile(userId);
                        if (profile != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountScreen(user: profile, authService: widget.authService),
                            ),
                          );
                        }
                      }
                    },
                  ];
                  return _buildMenuCard(
                    icon: menuOptions[index]["icon"] as IconData,
                    text: menuOptions[index]["text"] as String,
                    color: menuOptions[index]["color"] as Color,
                    onTap: menuOptions[index]["onTap"] as VoidCallback,
                  );
                },
              ),
            ),

            // Imagen adaptada con descripción
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                children: [
                  Image.network(
                    'https://media.tenor.com/dutdoOw7PjsAAAAj/happy-cat.gif',
                    height: screenHeight * 0.25,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    '¡Hola! Comienza con alguna de las opciones para cuidar tus forrajes y programar el riego.',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: screenWidth * 0.15),
              SizedBox(height: screenHeight * 0.02),
              Text(
                text,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
