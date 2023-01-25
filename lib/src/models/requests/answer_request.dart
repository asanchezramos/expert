import 'dart:io';

class AnswerRequest {
  String? comments;
  File? file;
  int? solicitudeId;
  AnswerRequest({
    this.comments,
    this.file,
    this.solicitudeId,
  });

  Map<String, dynamic> toJson() =>
      {'comments': comments, "file": file, "solicitudeId": solicitudeId};
}
