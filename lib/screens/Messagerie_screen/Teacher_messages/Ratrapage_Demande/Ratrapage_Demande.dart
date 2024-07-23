import 'package:flutter/material.dart';

class RatrapageScreen extends StatelessWidget {
  static String routeName = 'RatrapageScreen';

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments from the navigator
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int idUser = args['iduser'];
    final int idEtablissement = args['idetablissement'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Demande de Rattrapage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID Utilisateur: $idUser'),
            Text('ID Etablissement: $idEtablissement'),
            // Your widget content for the rattrapage page
          ],
        ),
      ),
    );
  }
}
