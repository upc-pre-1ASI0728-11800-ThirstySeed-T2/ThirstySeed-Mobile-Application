import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Añadido para el formateo de la hora
import 'package:thirstyseed/irrigation/domain/entities/schedule_entity.dart';
import 'package:thirstyseed/irrigation/application/schedule_service.dart';
import 'package:thirstyseed/irrigation/application/plot_service.dart';
import 'package:thirstyseed/irrigation/domain/entities/plot_entity.dart';
import 'package:thirstyseed/irrigation/presentation/schedule/schedule_list_screen.dart';

class AddScheduleScreen extends StatefulWidget {
  final ScheduleService scheduleService;
  final PlotService plotService;
  final Schedule? schedule;

  const AddScheduleScreen({
    Key? key,
    required this.scheduleService,
    required this.plotService,
    this.schedule,
  }) : super(key: key);

  @override
  _AddScheduleScreenState createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _waterAmountController = TextEditingController();
  final _pressureController = TextEditingController();
  final _sprinklerRadiusController = TextEditingController();
  final _estimatedTimeHoursController = TextEditingController();
  final _setTimeController = TextEditingController();
  final _angleController = TextEditingController();
  final _expectedMoistureController = TextEditingController(); // Controlador para la humedad esperada
  bool _isAutomatic = false;
  Plot? _selectedPlot;
  List<Plot> _plots = [];

  @override
  void initState() {
    super.initState();
    if (widget.schedule != null) {
      _populateFields(widget.schedule!);
    }
    _loadPlots();
  }

  void _populateFields(Schedule schedule) {
    _waterAmountController.text = schedule.waterAmount.toString();
    _pressureController.text = schedule.pressure.toString();
    _sprinklerRadiusController.text = schedule.sprinklerRadius.toString();
    _estimatedTimeHoursController.text = schedule.estimatedTimeHours.toString();
    _setTimeController.text = schedule.setTime;
    _angleController.text = schedule.angle.toString();
    _expectedMoistureController.text = schedule.expectedMoisture.toString();
    _isAutomatic = schedule.isAutomatic;
    if (_isAutomatic) {
      _populateAutomaticFields();
    }
  }

  void _populateAutomaticFields() {
    _waterAmountController.text = '100';
    _pressureController.text = '2';
    _sprinklerRadiusController.text = '5';
    _estimatedTimeHoursController.text = '2';
    _setTimeController.text = '08:00 AM';
    _angleController.text = '90';
    _expectedMoistureController.text = '70';
  }

  void _loadPlots() async {
    try {
      final plots = await widget.plotService.getPlotsByUserId();
      setState(() {
        _plots = plots;
        if (widget.schedule != null) {
          _selectedPlot = _plots.firstWhere(
            (plot) => plot.id == widget.schedule!.plotId,
            orElse: () => _plots.isNotEmpty
                ? _plots.first
                : Plot(
                    id: 0,
                    userId: 0,
                    name: 'Plot no disponible',
                    location: 'Ubicación desconocida',
                    extension: 0,
                    size: 0,
                    status: 'Indefinido',
                    imageUrl: '',
                    createdAt: DateTime.now().toString(),
                    updatedAt: DateTime.now().toString(),
                  ),
          );
        } else if (_plots.isNotEmpty) {
          _selectedPlot = _plots.first;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los plots: $e')),
      );
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final DateTime now = DateTime.now();
      final DateTime selectedTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      final String formattedTime = DateFormat('hh:mm a').format(selectedTime);
      _setTimeController.text = formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Schedule'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ScheduleListScreen(
                  scheduleService: widget.scheduleService,
                  plotService: widget.plotService,
                ),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<Plot>(
              value: _selectedPlot,
              hint: const Text('Select Plot'),
              items: _plots.map((Plot plot) {
                return DropdownMenuItem<Plot>(
                  value: plot,
                  child: Text(plot.name),
                );
              }).toList(),
              onChanged: (Plot? value) {
                setState(() {
                  _selectedPlot = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Plot',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Automatic Schedule'),
              value: _isAutomatic,
              onChanged: (value) {
                setState(() {
                  _isAutomatic = value;
                  if (_isAutomatic) {
                    _populateAutomaticFields();
                  } else {
                    _clearFields();
                  }
                });
              },
            ),
            _buildTextField(_waterAmountController, 'Water Amount (L)', enabled: !_isAutomatic),
            _buildTextField(_pressureController, 'Pressure (bar)', enabled: !_isAutomatic),
            _buildTextField(_sprinklerRadiusController, 'Sprinkler Radius (m)', enabled: !_isAutomatic),
            _buildTextField(_expectedMoistureController, 'Expected Moisture (%)', enabled: !_isAutomatic),
            _buildTextField(_estimatedTimeHoursController, 'Estimated Time (hours)', enabled: !_isAutomatic),
            GestureDetector(
              onTap: () => _selectTime(context),
              child: AbsorbPointer(
                child: _buildTextField(_setTimeController, 'Set Time (e.g. 08:00 AM)', enabled: true),
              ),
            ),
            _buildTextField(_angleController, 'Angle (degrees)', enabled: !_isAutomatic),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScheduleListScreen(
                          scheduleService: widget.scheduleService,
                          plotService: widget.plotService,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: _selectedPlot != null
                      ? () async {
                          final newSchedule = Schedule(
                            plotId: _selectedPlot!.id,
                            waterAmount: double.tryParse(_waterAmountController.text) ?? 0,
                            pressure: double.tryParse(_pressureController.text) ?? 0,
                            sprinklerRadius: double.tryParse(_sprinklerRadiusController.text) ?? 0,
                            expectedMoisture: double.tryParse(_expectedMoistureController.text) ?? 0,
                            estimatedTimeHours: double.tryParse(_estimatedTimeHoursController.text) ?? 0,
                            setTime: _setTimeController.text,
                            angle: double.tryParse(_angleController.text) ?? 0,
                            isAutomatic: _isAutomatic,
                          );

                          print("Enviando Schedule: ${newSchedule.toJson()}");

                          if (widget.schedule == null) {
                            bool created = await widget.scheduleService.createSchedule(newSchedule);
                            print("Response al crear schedule: ${created ? 'Success' : 'Failed'}");
                          } else {
                            final updatedSchedule = newSchedule.copyWith(id: widget.schedule!.id);
                            bool updated = await widget.scheduleService.updateSchedule(updatedSchedule.id!, updatedSchedule);
                            print("Response al actualizar schedule: ${updated ? 'Success' : 'Failed'}");
                          }

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScheduleListScreen(
                                scheduleService: widget.scheduleService,
                                plotService: widget.plotService,
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Save Schedule', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.green),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  void _clearFields() {
    _waterAmountController.clear();
    _pressureController.clear();
    _sprinklerRadiusController.clear();
    _expectedMoistureController.clear();
    _estimatedTimeHoursController.clear();
    _setTimeController.clear();
    _angleController.clear();
  }
}
