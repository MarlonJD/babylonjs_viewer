import 'dart:convert' show utf8;
import 'dart:io'
    show File, HttpRequest, HttpServer, HttpStatus, InternetAddress;
import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:webview_flutter/webview_flutter.dart';

import 'html_builder.dart';

/// Flutter widget for rendering interactive 3D models.
class BabylonJSViewer extends StatefulWidget {
  BabylonJSViewer({
    Key? key,
    required this.src,
    this.controller,
    this.functions,
  }) : super(key: key);

  final String src;
  final ValueChanged<WebViewController>? controller;
  final String? functions;

  @override
  State<BabylonJSViewer> createState() => _BabylonJSViewerState();
}

class _BabylonJSViewerState extends State<BabylonJSViewer> {
  HttpServer? _proxy;
  String? url;

  @override
  void initState() {
    super.initState();
    _initProxy();
  }

  @override
  void dispose() {
    super.dispose();
    if (_proxy != null) {
      _proxy!.close(force: true);
      _proxy = null;
    }
  }

  @override
  void didUpdateWidget(final BabylonJSViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    if (_proxy != null) {
      return WebView(
        debuggingEnabled: true,
        backgroundColor: Colors.white,
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: Set.from([
          JavascriptChannel(
              name: 'Print',
              onMessageReceived: (JavascriptMessage message) {
                print(message.message);
              })
        ]),
        initialUrl: 'http://${_proxy!.address.address}:${_proxy!.port}/',
        onWebViewCreated: (controller) {
          if (widget.controller != null) {
            setState(() {
              widget.controller!(controller);
            });
          }
        },
        onWebResourceError: (error) {
          print('>>>> ModelViewer failed to load: ${error}'); // DEBUB
        },
        onPageStarted: (url) {
          print('>>>> BabylonJS Viewer loading url... <$url>'); // DEBUG
        },
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  String _buildHTML(final String htmlTemplate) {
    return HTMLBuilder.build(
        htmlTemplate: htmlTemplate,
        src: '/modelLink.glb',
        functions: widget.functions);
  }

  Future<void> _initProxy() async {
    final url = Uri.parse(widget.src);
    _proxy = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _proxy!.listen((final HttpRequest request) async {
      final response = request.response;

      switch (request.uri.path) {
        case '/':
        case '/index.html':
          final htmlTemplate = await rootBundle.loadString(
              'packages/babylonjs_viewer/assets/viewer/template.html');
          final html = utf8.encode(_buildHTML(htmlTemplate));
          response
            ..statusCode = HttpStatus.ok
            ..headers.add("Content-Type", "text/html;charset=UTF-8")
            ..headers.add("Content-Length", html.length.toString())
            ..add(html);
          await response.close();
          break;

        case '/babylon.viewer.min.js':
          final code = await _readAsset(
              'packages/babylonjs_viewer/assets/viewer/babylon.viewer.min.js');
          response
            ..statusCode = HttpStatus.ok
            ..headers
                .add("Content-Type", "application/javascript;charset=UTF-8")
            ..headers.add("Content-Length", code.lengthInBytes.toString())
            ..add(code);
          await response.close();
          break;

        case '/bg_nx.jpg':
        case '/bg_ny.jpg':
        case '/bg_nz.jpg':
        case '/bg_px.jpg':
        case '/bg_py.jpg':
        case '/bg_pz.jpg':
          final code = await _readAsset(
              'packages/babylonjs_viewer/assets/viewer/bg_nx.jpg');
          response
            ..statusCode = HttpStatus.ok
            ..headers
                .add("Content-Type", "application/javascript;charset=UTF-8")
            ..headers.add("Content-Length", code.lengthInBytes.toString())
            ..add(code);
          await response.close();
          break;

        case '/modelLink.glb':
          if (url.isAbsolute && !url.isScheme("file")) {
            await response.redirect(url);
          } else {
            final data = await (url.isScheme("file")
                ? _readFile(url.path)
                : _readAsset(url.path));
            response
              ..statusCode = HttpStatus.ok
              ..headers.add("Content-Type", "application/octet-stream")
              ..headers.add("Content-Length", data.lengthInBytes.toString())
              ..headers.add("Access-Control-Allow-Origin", "*")
              ..add(data);
            await response.close();
          }
          break;

        case '/favicon.ico':
        default:
          final text = utf8.encode("Resource '${request.uri}' not found");
          response
            ..statusCode = HttpStatus.notFound
            ..headers.add("Content-Type", "text/plain;charset=UTF-8")
            ..headers.add("Content-Length", text.length.toString())
            ..add(text);
          await response.close();
          break;
      }
    });
    setState(() {});
  }

  Future<Uint8List> _readAsset(final String key) async {
    final data = await rootBundle.load(key);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<Uint8List> _readFile(final String path) async {
    return await File(path).readAsBytes();
  }
}
