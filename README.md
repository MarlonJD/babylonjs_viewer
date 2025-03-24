# babylonjs_viewer

3D Model viewer with [BabylonJS Viewer](https://pub.dev/packages/babylonjs_viewer) for Flutter. This project highly inspired from [model_viewer](https://pub.dev/packages/model_viewer) flutter pub package. Its simple model viewer, next release, json settings will be implented

# Pub.dev
[https://pub.dev/packages/babylonjs_viewer](https://pub.dev/packages/babylonjs_viewer)

# Install
This will add a line like this to your package's pubspec.yaml (and run an implicit dart pub get):
```
dependencies:
  babylonjs_viewer: ^1.3.0
```

### What's new in 1.3.0
 - Update dependency to webview_flutter 4.10.0

#### Why I need Controller
Controller is optional. You can use this controller for run Javascript code, go back, get current url, change url and many others that WebView Flutter can allow. 
Functions is optional. You can use this parameter for add javascript code to your viewer.
Examples can be found at bottom of this [document](https://github.com/MarlonJD/babylonjs_viewer#controller-and-function-example)


# Requirements
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

### Controller and Function Example
Add `webview_flutter` to your pubspec.yaml
```
dependencies:
  webview_flutter: ^4.10.0
```

Add this to your state
```
import 'package:webview_flutter/webview_flutter.dart';

WebViewController? _controller;
```

Add your custom javascript functions. This will print to your flutter console.
```
BabylonJSViewer(
  controller: (WebViewController controller) {
    _controller = controller;
  },
  functions:
      '''function sayHello() { Print.postMessage("Hello World!"); }''',
  src:
      'https://models.babylonjs.com/boombox.glb',
),
```

Use this function wherever you want
```
ElevatedButton(
  onPressed: () {
      _controller?.runJavaScript('''
sayHello();
''');
  },
  child: const Text("Run Function")),
```

### Use case for Controller and Function

You can access to viewer variable of babylonjs viewer. You can found all methods on [there](https://github.com/BabylonJS/Babylon.js/blob/master/packages/tools/viewer/src/viewer/viewer.ts)

In this example show you that how you can toggle auto rotate.
```
BabylonJSViewer(
  controller: (WebViewController controller) {
    _controller = controller;
  },
  functions: '''
function toggleAutoRotate(texture) {
let viewer = BabylonViewer.viewerManager.getViewerById('viewer-id');
viewer.sceneManager.camera.useAutoRotationBehavior = !viewer.sceneManager.camera.useAutoRotationBehavior
}
''',
  src:
      'https://models.babylonjs.com/boombox.glb',
),
```

use this function
```
ElevatedButton(
  onPressed: () {
      _controller?.runJavascript('''
toggleAutoRotate();
''');
  },
  child: const Text("Toggle")),
```
