/**
 * Script de Node.js para añadir los 23 códigos a la colección "Códigos_válidos" en Firebase Firestore.
 * 
 * Uso:
 *   node scripts/agregar_codigos.js
 * 
 * Modos de ejecución soportados:
 * 1. REST API Directo (Sin requerir 'npm install', funciona con Node 18+ nativo)
 * 2. Firebase Admin SDK (Si colocas 'serviceAccountKey.json' en esta carpeta)
 */

const fs = require('fs');
const path = require('path');

const PROJECT_ID = 'appeov-23dbe';
const API_KEY = 'AIzaSyDQhsjI8SLGhl9dO4-nDftBWgPzMCunVlE';
const COLLECTION_NAME = 'Códigos_válidos';

const CODIGOS = [
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

async function subirConRestApi() {
  console.log(`\n🚀 Conectando a Firestore mediante REST API (Proyecto: ${PROJECT_ID})...`);
  console.log(`📂 Colección: "${COLLECTION_NAME}"\n`);

  let exitosos = 0;
  let omitidos = 0;
  let errores = 0;

  for (const codigo of CODIGOS) {
    const docPath = encodeURIComponent(codigo);
    const collectionEncoded = encodeURIComponent(COLLECTION_NAME);
    const url = `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/${collectionEncoded}/${docPath}?key=${API_KEY}`;

    try {
      // 1. Verificar si ya existe
      const checkRes = await fetch(url);
      if (checkRes.status === 200) {
        const data = await checkRes.json();
        const enUso = data.fields?.en_uso?.booleanValue ?? false;
        console.log(`⚠️  [YA EXISTE] ${codigo} (en_uso: ${enUso}) - Se conserva`);
        omitidos++;
        continue;
      }

      // 2. Si no existe (404), crearlo vía PATCH
      const body = {
        fields: {
          codigo: { stringValue: codigo },
          habilitado: { booleanValue: true },
          en_uso: { booleanValue: false },
          dispositivos_activos: { arrayValue: { values: [] } },
          "quien entro": { nullValue: null },
          fecha_creacion: { timestampValue: new Date().toISOString() }
        }
      };

      const patchRes = await fetch(url, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body)
      });

      if (patchRes.ok) {
        console.log(`✅ [AGREGADO]  ${codigo}`);
        exitosos++;
      } else {
        const errorData = await patchRes.text();
        console.error(`❌ [ERROR]     ${codigo}: HTTP ${patchRes.status} -> ${errorData}`);
        errores++;
      }
    } catch (err) {
      console.error(`❌ [ERROR]     ${codigo}: ${err.message}`);
      errores++;
    }
  }

  console.log('\n=======================================');
  console.log(`Resumen: ${exitosos} creados, ${omitidos} ya existentes, ${errores} errores.`);
  console.log('=======================================\n');
}

async function subirConAdminSdk(serviceAccountPath) {
  console.log(`\n🔑 Inicializando Firebase Admin SDK con ${serviceAccountPath}...`);
  const admin = require('firebase-admin');
  const serviceAccount = require(path.resolve(serviceAccountPath));

  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });

  const db = admin.firestore();
  const batch = db.batch();
  let nuevos = 0;

  for (const codigo of CODIGOS) {
    const docRef = db.collection(COLLECTION_NAME).doc(codigo);
    const snap = await docRef.get();

    if (!snap.exists) {
      batch.set(docRef, {
        codigo: codigo,
        habilitado: true,
        en_uso: false,
        dispositivos_activos: [],
        'quien entro': null,
        fecha_creacion: admin.firestore.FieldValue.serverTimestamp()
      });
      nuevos++;
      console.log(`📝 Preparando para crear: ${codigo}`);
    } else {
      console.log(`⚠️  Ya existía en la base de datos: ${codigo}`);
    }
  }

  if (nuevos > 0) {
    await batch.commit();
    console.log(`\n✅ ${nuevos} códigos guardados en Firebase con éxito.`);
  } else {
    console.log(`\nℹ️ No hubo códigos nuevos para agregar.`);
  }
}

async function main() {
  const serviceAccountPath = path.join(__dirname, 'serviceAccountKey.json');
  if (fs.existsSync(serviceAccountPath)) {
    await subirConAdminSdk(serviceAccountPath);
  } else {
    await subirConRestApi();
  }
}

main().catch(console.error);
