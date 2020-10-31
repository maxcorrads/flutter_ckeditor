library flutter_ckeditor;
import 'package:flutter/widgets.dart';

import 'ckeditor_stub.dart'
if (dart.library.io) 'mob_ckeditor.dart'
if (dart.library.js) 'web_ckeditor.dart';

/// A Calculator.
abstract class CKEditor extends Widget {
  static CKEditor _instance;

  static CKEditor get instance {
    _instance ??= getManager();
    return _instance;
  }

}
