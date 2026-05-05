# LifeTours – Panel Administrativo

Panel administrativo multiplataforma (Android · Web · Windows) para gestionar una tienda de tours virtuales, construido con Flutter + Dart y Cloud Firestore.

---

## Estructura del proyecto

```
lifetours/
├── lib/
│   ├── main.dart                    # Punto de entrada + init Firebase
│   ├── firebase_options.dart        # ⚠️ PLACEHOLDER – requiere tus credenciales
│   ├── models/
│   │   ├── usuario.dart             # Modelo de usuario administrador
│   │   └── tour.dart                # Modelo de tour
│   ├── services/
│   │   ├── auth_service.dart        # Autenticación manual contra Firestore
│   │   └── tour_service.dart        # CRUD completo de tours
│   └── screens/
│       ├── login_screen.dart        # Pantalla de inicio de sesión
│       └── dashboard_screen.dart    # Panel principal con CRUD
├── android/
│   └── app/
│       └── google-services.json     # ⚠️ PLACEHOLDER – descarga el real
├── web/
│   └── index.html                   # ⚠️ Contiene config Firebase web
├── windows/
│   └── CMakeLists.txt
└── pubspec.yaml
```

---

## Configuración de Firebase (REQUERIDA)

### 1. Proyecto Firebase

- Proyecto: **centralc**
- Servicios necesarios: **Cloud Firestore**

### 2. Crear las colecciones en Firestore

#### Colección `usuarios`
Crea documentos manualmente con este esquema:
```json
{
  "nombre": "Admin Principal",
  "correo": "admin@lifetours.com",
  "password": "tu_password_seguro"
}
```
> ⚠️ La contraseña se almacena tal como la escribas. En producción considera hashearla.

#### Colección `tours`
Los documentos se crean desde la app. Esquema:
```json
{
  "nombre": "Tour por la Ciudad Histórica",
  "descripcion": "Un recorrido por los principales monumentos...",
  "precio": 150.00,
  "duracion": "3 horas"
}
```

### 3. Reglas de Firestore (firebase console)
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Solo lectura/escritura desde tu app (ajusta según necesidad)
    match /{document=**} {
      allow read, write: if true; // ⚠️ Cambia esto en producción
    }
  }
}
```

### 4. Configurar credenciales por plataforma

#### Web (`web/index.html`)
Reemplaza el objeto `firebaseConfig` con el de tu app web en Firebase Console.

#### Android (`android/app/google-services.json`)
1. Ve a Firebase Console > Proyecto centralc > Configuración
2. Agrega una app Android con package name: `com.example.lifetours`
3. Descarga `google-services.json` y reemplaza el placeholder

#### `lib/firebase_options.dart`
Reemplaza todos los valores `TU_API_KEY_*` con los reales.

**Alternativa rápida con FlutterFire CLI:**
```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=centralc
```
Esto genera `firebase_options.dart` automáticamente para todas las plataformas.

---

## Instalación y ejecución

```bash
# Instalar dependencias
flutter pub get

# Ejecutar en Web
flutter run -d chrome

# Ejecutar en Windows
flutter run -d windows

# Ejecutar en Android (emulador o dispositivo conectado)
flutter run -d android
```

---

## Autenticación

- **No** usa Firebase Authentication
- La validación se realiza **manualmente** contra la colección `usuarios` en Firestore
- Solo usuarios existentes en esa colección pueden acceder
- No hay registro de usuarios ni recuperación de contraseña desde la app

---

## Funcionalidades

| Función | Estado |
|---|---|
| Login manual con Firestore | ✅ |
| Dashboard administrativo | ✅ |
| Listar tours (tiempo real) | ✅ |
| Buscar tours | ✅ |
| Crear tour | ✅ |
| Editar tour | ✅ |
| Eliminar tour (con confirmación) | ✅ |
| Soporte Android | ✅ |
| Soporte Web | ✅ |
| Soporte Windows | ✅ |
