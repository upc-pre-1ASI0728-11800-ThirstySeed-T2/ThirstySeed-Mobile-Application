import 'package:flutter/material.dart';
import 'package:thirstyseed/irrigation/domain/entities/schedule_entity.dart';
import 'package:thirstyseed/irrigation/application/schedule_service.dart';
import 'package:thirstyseed/irrigation/application/plot_service.dart';
import 'add_schedule_screen.dart';

class ScheduleListScreen extends StatefulWidget {
  final ScheduleService scheduleService;
  final PlotService plotService;

  const ScheduleListScreen({Key? key, required this.scheduleService, required this.plotService}) : super(key: key);

  @override
  _ScheduleListScreenState createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
  late Future<List<Schedule>> _schedulesFuture;

  @override
  void initState() {
    super.initState();
    _schedulesFuture = widget.scheduleService.getSchedulesByUserId();
  }

  Future<String> _getPlotName(int plotId) async {
    try {
      final plot = await widget.plotService.getPlotById(plotId);
      return plot.name;
    } catch (e) {
      return 'Plot not found';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedules'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Schedule>>(
        future: _schedulesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No schedules found'));
          } else {
            final schedules = snapshot.data!;
            return ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return FutureBuilder<String>(
                  future: _getPlotName(schedule.plotId),
                  builder: (context, plotSnapshot) {
                    final plotName = plotSnapshot.connectionState == ConnectionState.done && plotSnapshot.hasData
                        ? plotSnapshot.data!
                        : 'Loading...';
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Image.network(
                              'https://ramcorpwire.com/images/blog/28/sprinkler-system.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Plot: $plotName',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Time: ${schedule.setTime}'),
                                  Text('Automatic: ${schedule.isAutomatic ? 'Yes' : 'No'}'),
                                  Text('Estimated Time: ${schedule.estimatedTimeHours} hours'),
                                  Text('Expected Moisture: ${schedule.expectedMoisture}%'),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddScheduleScreen(
                                      scheduleService: widget.scheduleService,
                                      plotService: widget.plotService,
                                      schedule: schedule,
                                    ),
                                  ),
                                ).then((_) {
                                  setState(() {
                                    _schedulesFuture = widget.scheduleService.getSchedulesByUserId();
                                  });
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await widget.scheduleService.deleteSchedule(schedule.id as int);
                                setState(() {
                                  _schedulesFuture = widget.scheduleService.getSchedulesByUserId();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddScheduleScreen(
                scheduleService: widget.scheduleService,
                plotService: widget.plotService,
              ),
            ),
          ).then((_) {
            setState(() {
              _schedulesFuture = widget.scheduleService.getSchedulesByUserId();
            });
          });
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
