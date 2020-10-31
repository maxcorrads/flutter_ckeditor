import 'package:flutter_ckeditor/ckeditor.dart';
import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;
import 'dart:js' as js;
import 'package:flutter/material.dart';

CKEditor getManager() => CKEditorWeb();

class CKEditorWeb extends StatefulWidget implements CKEditor {
  @override
  CKEditorWebState createState() => CKEditorWebState();
}

class CKEditorWebState extends State<CKEditorWeb> {
  IFrameElement _element;

  @override
  void initState() {
    _element = IFrameElement()
      ..width = "200px"
      ..height = "200px"
      ..style.border = 'none'
      ..srcdoc = """
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
        """;

    js.context["purchase_units"] = js.JsObject.jsify([
      {
        'amount': {'value': '0.02'}
      }
    ]);
    js.context["flutter_feedback"] = (msg) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
    };

    // ignore:undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'PayPalButtons',
          (int viewId) => _element,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: HtmlElementView(viewType: 'PayPalButtons'),
    );
  }

}