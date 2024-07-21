import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/officer.jpg'), // Asegúrate de tener esta imagen en tu proyecto
            ),
            SizedBox(height: 10),
            Text('Nombre: John Doe'),
            Text('Apellido: Smith'),
            Text('Matrícula: 123456'),
            SizedBox(height: 20),
            Text(
              'La seguridad es nuestra prioridad y vigilancia es nuestro deber. Mantén la calma y sigue protegiendo a nuestra comunidad.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
