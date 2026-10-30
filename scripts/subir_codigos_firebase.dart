import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/firebase_options.dart';

const List<String> codigosNuevos = [
  "MARIAVILLAGRA123",
  "JAVIERLOPEZ123",
  "JOSSIRIVERA123",
  "KARINAFRITIS123",
  "ALEXANDERAGUILAR123",
  "PAMELASARNO123",
  "JAVIERAHERMOSILLA123",
  "DIEGOCASTRO123",
  "SEBASTIANHERNANDEZ123",
  "FELIPECHANDIA123",
  "RAPLHMULLER123",
  "DANIELROJAS123",
  "RODRIGOCELPA123",
  "FELIPEOVALLE123",
  "JOSUEPAINEN123",
  "LUISMARTINEZ123",
  "KENNETHCABELLO123",
  "MARCELOSALAS123",
  "PEDROFLANDEZ123",
  "RICHARDPAEZ123",
  "LIZMUÑOZ123",
  "JOSEVEGA123",
  "VICTORALARCON123"
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();
  final collection = firestore.collection("Códigos_válidos");

  debugPrint("🚀 Iniciando carga de ${codigosNuevos.length} códigos en 'Códigos_válidos'...");

  int agregados = 0;

  for (final codigo in codigosNuevos) {
    final docRef = collection.doc(codigo);
    final docSnap = await docRef.get();

    if (!docSnap.exists) {
      batch.set(docRef, {
        'codigo': codigo,
        'habilitado': true,
        'en_uso': false,
        'dispositivos_activos': <String>[],
        'quien entro': null,
        'fecha_creacion': FieldValue.serverTimestamp(),
      });
      debugPrint("📝 Código preparado: $codigo");
      agregados++;
    } else {
      debugPrint("⚠️ El código ya existe en Firestore: $codigo");
    }
  }

  if (agregados > 0) {
    await batch.commit();
    debugPrint("✅ $agregados códigos añadidos exitosamente a Firebase Firestore.");
  } else {
    debugPrint("ℹ️ Todos los códigos ya se encontraban registrados.");
  }
}
