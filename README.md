# flutter_ckeditor

CKEditor usage in Flutter (iOS / Android / Web)

> **WARNING**: Work in progress!
```dart
## Example usage
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ckeditor/ckeditor.dart';


class EditorPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          child: CKEditor.createEditor(
              initialValue: "test1",
              onDataChanged: (data){
                print("DATA1 changed");
                print(data);
              },
              viewId: shortHash(UniqueKey())
          ),
        ),
        Container(
          height: 200,
          child: CKEditor.createEditor(
              initialValue: "test2",
              onDataChanged: (data){
                print("DATA2 changed");
                print(data);
              },
              viewId: shortHash(UniqueKey())
          ),
        )
      ],
    );
  }

}
```