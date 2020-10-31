import 'dart:convert';
import 'dart:io';

import 'package:flutter_ckeditor/ckeditor.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

CKEditor getManager() => CKEditorMob();
const String kNavigationExamplePage = '''
<!DOCTYPE html>
        <html>
          <head>
    <meta charset="utf-8">
    <title>CKEditor 5 – Classic editor</title>
    <script src="https://cdn.ckeditor.com/ckeditor5/23.1.0/classic/ckeditor.js"></script>
</head>
<body>
    <h1>Classic editor</h1>
    <div id="editor">
        <p>This is some sample content.</p>
    </div>
    <script>
        ClassicEditor
            .create( document.querySelector( '#editor' ) )
            .catch( error => {
                console.error( error );
            } );
    </script>
</body>
        </html>
''';

class CKEditorMob extends StatefulWidget implements CKEditor {
  @override
  _CKEditorMobState createState() => _CKEditorMobState();
}

class _CKEditorMobState extends State<CKEditorMob> {
  final String contentBase64 = base64Encode(const Utf8Encoder().convert(kNavigationExamplePage));

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          webViewController.loadUrl('data:text/html;base64,$contentBase64');
        }
    );
  }
}