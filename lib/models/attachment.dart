import 'package:articles/network/user_connect.dart';

class Attachment {
  String contentType, fileName, path, location, type, accessUrl;
  int fileSize;

  Attachment(
      {this.contentType,
      this.fileName,
      this.path,
      this.location,
      this.type,
      this.fileSize,
      this.accessUrl});

  Attachment.fromJSON(Map<String, dynamic> map) {
    contentType = map['contentType'];
    fileName = map['fileName'];
    accessUrl = map['accessUrl'];
    path = map['path'];
    fileSize = map['fileSize'];
    type = map['type'];
  }
  Attachment.fromJSONViewSingleMail(Map<String, dynamic> map) {
    contentType = map['contentType'];
    fileName = map['fileName'];
    path = map['path'];
  }
  Attachment.fromJSONDraftMail(Map<String, dynamic> map) {
    contentType = map['contentType'];
    fileName = map['fileName'];
    path = map['path'];
    fileSize = null;
  }
  Map<String, String> toJson() {
    return {'contentType': contentType, 'fileName': fileName, 'path': path};
  }
}
