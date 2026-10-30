"""
Script de Python para añadir códigos de acceso a Firebase Firestore.
Colección: "Códigos_válidos"
Proyecto: appeov-23dbe

Uso:
  python scripts/agregar_codigos.py
"""

import json
import os
import urllib.request
import urllib.error
import urllib.parse
from datetime import datetime, timezone

PROJECT_ID = "appeov-23dbe"
API_KEY = "AIzaSyDQhsjI8SLGhl9dO4-nDftBWgPzMCunVlE"
COLLECTION_NAME = "Códigos_válidos"

CODIGOS = [
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
]

def subir_con_rest():
    print(f"\n🚀 Conectando a Firestore vía REST API (Proyecto: {PROJECT_ID})...")
    print(f"📂 Colección: '{COLLECTION_NAME}'\n")

    exitosos = 0
    ya_existentes = 0
    errores = 0

    col_encoded = urllib.parse.quote(COLLECTION_NAME)

    for codigo in CODIGOS:
        doc_encoded = urllib.parse.quote(codigo)
        url = f"https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/(default)/documents/{col_encoded}/{doc_encoded}?key={API_KEY}"

        # 1. Verificar si ya existe
        req_check = urllib.request.Request(url, method="GET")
        existe = False
        try:
            with urllib.request.urlopen(req_check) as response:
                if response.status == 200:
                    existe = True
        except urllib.error.HTTPError as e:
            if e.code == 404:
                existe = False
            else:
                print(f"⚠️  Error verificando {codigo}: {e}")
        except Exception as e:
            print(f"⚠️  Excepción al verificar {codigo}: {e}")

        if existe:
            print(f"⚠️  [YA EXISTE] {codigo} - Se conserva sin alterar")
            ya_existentes += 1
            continue

        # 2. Crear documento con PATCH
        body_data = {
            "fields": {
                "codigo": {"stringValue": codigo},
                "habilitado": {"booleanValue": True},
                "en_uso": {"booleanValue": False},
                "dispositivos_activos": {"arrayValue": {"values": []}},
                "quien entro": {"nullValue": None},
                "fecha_creacion": {"timestampValue": datetime.now(timezone.utc).isoformat()}
            }
        }
        json_data = json.dumps(body_data).encode("utf-8")

        req_patch = urllib.request.Request(
            url,
            data=json_data,
            headers={"Content-Type": "application/json"},
            method="PATCH"
        )

        try:
            with urllib.request.urlopen(req_patch) as resp:
                if resp.status in (200, 201):
                    print(f"✅ [AGREGADO]  {codigo}")
                    exitosos += 1
                else:
                    print(f"❌ [ERROR]     {codigo}: Status {resp.status}")
                    errores += 1
        except urllib.error.HTTPError as e:
            err_msg = e.read().decode("utf-8", errors="ignore")
            print(f"❌ [ERROR]     {codigo}: {e.code} -> {err_msg}")
            errores += 1
        except Exception as e:
            print(f"❌ [ERROR]     {codigo}: {e}")
            errores += 1

    print("\n" + "=" * 40)
    print(f"Resumen: {exitosos} creados, {ya_existentes} ya existentes, {errores} errores.")
    print("=" * 40 + "\n")

if __name__ == "__main__":
    subir_con_rest()
