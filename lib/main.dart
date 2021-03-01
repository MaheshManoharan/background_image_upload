import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'upload_item.dart';

const String uploadBinaryURL =
    "https://us-central1-flutteruploader.cloudfunctions.net/upload/binary";

void main() => runApp(App());

class App extends StatefulWidget {
  final Widget child;

  App({this.child});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UploadScreen(),
    );
  }
}

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  FlutterUploader uploader = FlutterUploader();
  Map<String, UploadItem> _tasks = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Background Image/Video Upload Example"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Upload your file"),
              RaisedButton(
                onPressed: () => getImage(),
                child: Text("Upload Image"),
              ),
              RaisedButton(
                onPressed: () => getVideo(),
                child: Text("upload video"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final String filename = basename(image.path);
      final String savedDir = dirname(image.path);
      final tag = "image upload ${_tasks.length + 1}";
      var url = _uploadUrl();
      var fileitem = FileItem(
        filename: filename,
        savedDir: savedDir,
        fieldname: "file",
      );


    try{

      var taskId = await uploader.enqueueBinary(
        url: url,
        file: fileitem,
        method: UploadMethod.POST,
        tag: tag,
        showNotification: true,
      );

      setState(() {
        _tasks.putIfAbsent(
          tag,
          () => UploadItem(
            id: taskId,
            tag: tag,
            type: MediaType.Video,
            status: UploadTaskStatus.enqueued,
          ),
        );
      });

    } on Exception catch(_)
    {

    }
      
    }
  }

  String _uploadUrl() {
    return uploadBinaryURL;
  }

  Future getVideo() async {
    var video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      final String savedDir = dirname(video.path);
      final String filename = basename(video.path);
      final tag = "video upload ${_tasks.length + 1}";

      final url = _uploadUrl();

      var fileItem = FileItem(
        filename: filename,
        savedDir: savedDir,
        fieldname: "file",
      );
      try
      {
 var taskId = await uploader.enqueueBinary(
        url: url,
        file: fileItem,
        method: UploadMethod.POST,
        tag: tag,
        showNotification: true,
      );

      setState(() {
        _tasks.putIfAbsent(
          tag,
          () => UploadItem(
            id: taskId,
            tag: tag,
            type: MediaType.Video,
            status: UploadTaskStatus.enqueued,
          ),
        );
      });
      } on Exception catch(_)
      {

      }

     

      
    }
  }
}
