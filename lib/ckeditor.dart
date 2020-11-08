library flutter_ckeditor;
import 'package:flutter/widgets.dart';

import 'ckeditor_stub.dart'
if (dart.library.io) 'mob_ckeditor.dart'
if (dart.library.js) 'web_ckeditor.dart';

/// A Calculator.
abstract class CKEditor extends Widget {

  const CKEditor({Key key}) : super(key: key);

  static CKEditor createEditor({String initialValue, Function(String value) onDataChanged, String viewId}){
    return getManager(initialValue: initialValue, onDataChanged: onDataChanged, viewId: viewId);
  }

}
