class ArticleTags {
  final List<String> tags;

  ArticleTags({this.tags});

  factory ArticleTags.fromJson(Map<String, dynamic> parsedJson) {
    var tagsFromJson = parsedJson['tags'];
    List<String> tagsList = tagsFromJson.cast<String>();

    return new ArticleTags(
      tags: tagsList,
    );
  }
}
