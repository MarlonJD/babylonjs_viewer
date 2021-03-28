# babylonjs_viewer

3D Model viewer with BabylonJS Viewer. This project highly inspired from [model_viewer](https://pub.dev/packages/model_viewer) flutter pub package. Its simple model viewer, next release, json settings will be implented

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
