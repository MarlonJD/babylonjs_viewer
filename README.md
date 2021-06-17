# babylonjs_viewer

3D Model viewer with [BabylonJS Viewer](https://pub.dev/packages/babylonjs_viewer) for Flutter. This project highly inspired from [model_viewer](https://pub.dev/packages/model_viewer) flutter pub package. Its simple model viewer, next release, json settings will be implented

# Pub.dev
[https://pub.dev/packages/babylonjs_viewer](https://pub.dev/packages/babylonjs_viewer)

# Install
This will add a line like this to your package's pubspec.yaml (and run an implicit dart pub get):
```
dependencies:
  babylonjs_viewer: ^1.1.0
```

On your Android Project (android/app/build.gradle) set the "minSdkVersion" to 19
```
defaultConfig {
        applicationId "com.example.example"
        minSdkVersion 19
        targetSdkVersion 30
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
```

Then add the line "android:usesCleartextTraffic="true"" to your android manifest (android/app/src/main/AndroidManifest.xml)
```
<application
        android:label="example"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true">
```

On your iOS Project go to the info.plist file (ios/Runner/Info.plist) and add the following line
```
<key>io.flutter.embedded_views_preview</key>
<true/>
```


# Import it
Now in your Dart code, you can use:
```
import 'package:babylonjs_viewer/babylonjs_viewer.dart';
```

# Using
```
  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text("BabylonJS Viewer")),
          body: BabylonJSViewer(
            src: 'https://models.babylonjs.com/boombox.glb',
          ),
        ),
      );
    }
  }
```
# Asset, FILE or HTTP(s)

## HTTP(s)
```
  BabylonJSViewer(
    src: 'https://models.babylonjs.com/boombox.glb',
  ),
```
## FILE
```
  BabylonJSViewer(
    src: 'file:///path/to/MyModel.glb',
  ),
```
## Asset
```
  BabylonJSViewer(
    src: 'assets/MyModel.glb',
  ),
```  

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
