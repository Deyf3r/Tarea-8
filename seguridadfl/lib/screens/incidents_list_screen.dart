import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incident_provider.dart';
import 'incident_detail_screen.dart';

class IncidentsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incidencias Registradas'),
      ),
      body: FutureBuilder(
        future: Provider.of<IncidentProvider>(context, listen: false).fetchIncidents(),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<IncidentProvider>(
                builder: (ctx, incidentProvider, child) => ListView.builder(
                  itemCount: incidentProvider.incidents.length,
                  itemBuilder: (ctx, i) => ListTile(
                    title: Text(incidentProvider.incidents[i].title),
                    subtitle: Text(incidentProvider.incidents[i].date.toString()),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => IncidentDetailScreen(incidentProvider.incidents[i]),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<IncidentProvider>(context, listen: false).deleteAllIncidents();
        },
        child: Icon(Icons.delete),
        backgroundColor: Colors.red,
      ),
    );
  }
}
