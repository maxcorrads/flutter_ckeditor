import 'package:flutter_ckeditor/ckeditor.dart';
import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:flutter_ckeditor/model/JSCommand.dart';

CKEditor getManager({String initialValue, Function(String value) onDataChanged, String viewId}) => CKEditorWeb(initialData: initialValue, onDataChanged: onDataChanged, viewId: viewId);


class CKEditorWeb extends StatefulWidget implements CKEditor {

  final String initialData;
  final Function(String value) onDataChanged;
  final String viewId;

  const CKEditorWeb({Key key, this.initialData, this.onDataChanged, this.viewId}) : super(key: key);

  @override
  CKEditorWebState createState() => CKEditorWebState();
}

class CKEditorWebState extends State<CKEditorWeb> {

  IFrameElement _element;

  @override
  void initState() {
    String kNavigationExamplePage = '''
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
        <p>pp</p>
    </div>
    <script>
        let theEditor;
        ClassicEditor
            .create( document.querySelector( '#editor' ) )
            .then( editor => {
                 theEditor = editor;
                 theEditor.model.document.on( 'change:data', () => {
                 parent.'''+JSCommand.changeData+"_"+widget.viewId+'''(getDataFromTheEditor'''+"_"+widget.viewId+'''());
                 });
                 parent.'''+JSCommand.ready+"_"+widget.viewId+'''(this);
            } )
            .catch( error => {
                console.error( error );
            } );
        function getDataFromTheEditor'''+"_"+widget.viewId+'''() {
          return theEditor.getData();
        }
        function setDataFromTheEditor'''+"_"+widget.viewId+'''(val) {
          return theEditor.setData(val);
        }
    </script>
</body>
        </html>
''';

    _element = IFrameElement()
      ..width = "200px"
      ..height = "200px"
      ..style.border = 'none'
      ..srcdoc = kNavigationExamplePage;

    js.context[JSCommand.ready+"_"+widget.viewId] = (v) {
      v.callMethod("setDataFromTheEditor"+"_"+widget.viewId, [widget.initialData]);
    };
    js.context[JSCommand.changeData+"_"+widget.viewId] = (data) {
      if (widget.onDataChanged != null) {
        widget.onDataChanged(data);
      }
    };

    // ignore:undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      widget.viewId,
          (int viewId) => _element,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: HtmlElementView(
          key: UniqueKey(),
          viewType: widget.viewId
      ),
    );
  }

}