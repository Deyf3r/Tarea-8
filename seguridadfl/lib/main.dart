import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/incident_provider.dart';
import 'screens/incidents_list_screen.dart';
import 'screens/add_incident_screen.dart';
import 'screens/about_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => IncidentProvider(),
      child: MaterialApp(
        title: 'Undercover Police App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: IncidentsListScreen(),
        routes: {
          '/add-incident': (ctx) => AddIncidentScreen(),
          '/about': (ctx) => AboutScreen(),
        },
      ),
    );
  }
}
