import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_ckeditor/ckeditor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ckeditor/model/JSCommand.dart';
import 'package:webview_flutter/webview_flutter.dart';

CKEditor getManager({String initialValue, Function(String value) onDataChanged, String viewId}) => CKEditorMob(initialData: initialValue, onDataChanged: onDataChanged);

const String kNavigationExamplePage = '''
<!DOCTYPE html>
        <html>
          <head>
    <meta name="viewport" content="width=device-width">
    <meta charset="utf-8">
    <title>CKEditor 5 – Classic editor</title>
    <script src="https://cdn.ckeditor.com/ckeditor5/23.1.0/classic/ckeditor.js"></script>
</head>
<body>
    <h1>Classic editor</h1>
    <div id="editor">
        
    </div>
    <script>
        let theEditor;
        ClassicEditor
            .create( document.querySelector( '#editor' ) )
            .then( editor => {
                 theEditor = editor;
                 theEditor.model.document.on( 'change:data', () => {
                  App.postMessage("'''+JSCommand.changeData+'''");
                 });
                 App.postMessage("'''+JSCommand.ready+'''");
            } )
            .catch( error => {
                console.error( error );
            } );
        function getDataFromTheEditor() {
          return theEditor.getData();
        }
        function setDataFromTheEditor(val) {
          return theEditor.setData(val);
        }
    </script>
</body>
        </html>
''';

class CKEditorMob extends StatefulWidget implements CKEditor {

  final String initialData;
  final Function(String value) onDataChanged;

  const CKEditorMob({Key key, this.initialData, this.onDataChanged}) : super(key: key);

  @override
  _CKEditorMobState createState() => _CKEditorMobState();
}

class _CKEditorMobState extends State<CKEditorMob> {
  final String contentBase64 = base64Encode(const Utf8Encoder().convert(kNavigationExamplePage));

  WebViewController webViewController;

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
        javascriptChannels: <JavascriptChannel>[
          _toasterJavascriptChannel(context),
        ].toSet(),
        onWebViewCreated: (WebViewController webViewController) {
          this.webViewController = webViewController;
          webViewController.loadUrl('data:text/html;base64,$contentBase64');
        }
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'App',
        onMessageReceived: (JavascriptMessage message) {
          switch (message.message){
            case JSCommand.ready:
              setInitialData();
              break;
            case JSCommand.changeData:
              dataChanged();
              break;
          }
        });
  }

  void setInitialData() {
    if (this.webViewController != null){
      this.webViewController.evaluateJavascript('setDataFromTheEditor("'+widget.initialData+'");');
    }
  }

  void dataChanged() async {
    if (this.webViewController != null){
      String data = await this.webViewController.evaluateJavascript('getDataFromTheEditor();');
      if (widget.onDataChanged != null) {
        widget.onDataChanged(data);
      }
    }
  }

}