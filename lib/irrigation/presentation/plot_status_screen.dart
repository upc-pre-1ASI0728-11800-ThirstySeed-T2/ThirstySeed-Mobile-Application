import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlotStatusScreen extends StatefulWidget {
  final int userId;

  const PlotStatusScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _PlotStatusScreenState createState() => _PlotStatusScreenState();
}

class _PlotStatusScreenState extends State<PlotStatusScreen> {
  List<dynamic> _plots = [];

  Future<void> fetchPlots() async {
    final url = Uri.parse('https://thirstyseedapi-production.up.railway.app/api/v1/plot/user/${widget.userId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _plots = json.decode(response.body);
        });
      } else {
        throw Exception('Error al cargar parcelas: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar parcelas: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPlots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registered Plots',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[100],
        centerTitle: true,
      ),
      body: _plots.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _plots.length,
              itemBuilder: (context, index) {
                final plot = _plots[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(
                      'Land Name: ${plot['name']}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location: ${plot['location']}'),
                        Text('Extension of Land: ${plot['extension']} m²'),
                        Text('Plot Status: ${plot['status']}'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NodeStatusScreen(plotId: plot['id']),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class NodeStatusScreen extends StatefulWidget {
  final int plotId;

  const NodeStatusScreen({Key? key, required this.plotId}) : super(key: key);

  @override
  _NodeStatusScreenState createState() => _NodeStatusScreenState();
}

class _NodeStatusScreenState extends State<NodeStatusScreen> {
  List<dynamic> _nodes = [];

  Future<void> fetchNodes() async {
    final url = Uri.parse('https://thirstyseedapi-production.up.railway.app/api/v1/node/plot/${widget.plotId}');
    print('Fetching nodes for plotId: ${widget.plotId}'); // Verificar plotId
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Response body: $data'); // Verificar datos recibidos
        setState(() {
          _nodes = data;
        });
      } else {
        print('Error response code: ${response.statusCode}');
        throw Exception('Error al cargar nodos: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar nodos: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNodes();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nodes for Plot ID ${widget.plotId}'),
        backgroundColor: Colors.green[100],
        centerTitle: true,
      ),
      body: _nodes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _nodes.length,
              itemBuilder: (context, index) {
                final node = _nodes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: Icon(
                      Icons.sensors,
                      color: node['statusClass'] == 'status-error' ? Colors.red : Colors.green,
                      size: 40,
                    ),
                    title: Text(
                      'Ubicación: ${node['nodelocation']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Humedad: ${node['moisture']}%'),
                        Text('Indicador: ${node['indicator']}'),
                        Text(
                          'Estado: ${node['status']}',
                          style: TextStyle(
                            color: node['statusClass'] == 'status-error' ? Colors.red : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}