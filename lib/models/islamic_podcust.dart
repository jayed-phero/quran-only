// To parse this JSON data, do
//
//     final islamicPodcust = islamicPodcustFromJson(jsonString);

import 'dart:convert';

List<IslamicPodcust> islamicPodcustFromJson(String str) =>
    List<IslamicPodcust>.from(
        json.decode(str).map((x) => IslamicPodcust.fromJson(x)));

String islamicPodcustToJson(List<IslamicPodcust> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IslamicPodcust {
  int id;
  String speaker;
  String photoUrl;
  String about;
  List<Lecture> lectures;

  IslamicPodcust({
    required this.id,
    required this.speaker,
    required this.photoUrl,
    required this.about,
    required this.lectures,
  });

  factory IslamicPodcust.fromJson(Map<String, dynamic> json) => IslamicPodcust(
        id: json["id"],
        speaker: json["speaker"],
        photoUrl: json["photoUrl"],
        about: json["about"],
        lectures: List<Lecture>.from(
            json["lectures"].map((x) => Lecture.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "speaker": speaker,
        "photoUrl": photoUrl,
        "about": about,
        "lectures": List<dynamic>.from(lectures.map((x) => x.toJson())),
      };
}

class Lecture {
  String title;
  String videoUrl;

  Lecture({
    required this.title,
    required this.videoUrl,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) => Lecture(
        title: json["title"],
        videoUrl: json["videoUrl"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "videoUrl": videoUrl,
      };
}
