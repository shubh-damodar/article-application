import 'package:articles/models/user.dart';

class Article {
  List<User> toUserList = List<User>(),
      ccUserList = List<User>(),
      bccUserList = List<User>();

  User fromUser;
  String id,
      title,
      shortDescription,
      thumbnail,
      type,
      owner,
      details,
      addedBy,
      name,
      commentid,
      tags,
      likes,
      updatedAt;
  bool isFavourite,
      hasAttachment,
      favouriteStatus,
      hasLiked,
      hasSubscribed,
      hasUnliked,
      watchLater;
  int repliesCount, addedAt;

  Article(
      {this.toUserList,
      this.ccUserList,
      this.bccUserList,
      this.fromUser,
      this.id,
      this.title,
      this.shortDescription,
      this.thumbnail,
      this.name,
      this.tags,
      this.repliesCount,
      this.hasLiked,
      this.addedBy,
      this.updatedAt,
      this.favouriteStatus});

  Map<String, String> toJSON() {
    return {
      "title": this.title,
      "shortDescription": this.shortDescription,
      "thumbnail": this.thumbnail,
    };
  }

  Article.fromJSON(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    shortDescription = map['shortDescription'];
    thumbnail = map['thumbnail'];
    favouriteStatus = map['favouriteStatus'];
  }

  Article.fromJSONInbox(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    shortDescription = map['shortDescription'];
    thumbnail = map['thumbnail'];
    addedBy = map['addedBy']['name'];
    favouriteStatus = map['favouriteStatus'];
    owner = map['owner'];
    addedAt = map['addedAt'].runtimeType == String
        ? DateTime.parse(map['addedAt']).millisecondsSinceEpoch
        : addedAt = map['addedAt'];
  }
  Article.myArticleJSON(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    shortDescription = map['shortDescription'];
    thumbnail = map['thumbnail'];
    addedBy = map['addedBy']['name'];
    updatedAt = map['updatedAt'];
    favouriteStatus = map['favouriteStatus'];
  }

  Article.fromJSONStarred(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    shortDescription = map['shortDescription'];
    thumbnail = map['thumbnail'];
    favouriteStatus = map['favouriteStatus'];
  }

  Article.fromJSONSentBox(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    shortDescription = map['shortDescription'];
    thumbnail = map['thumbnail'];
    addedBy = map['addedBy']['name'];
    favouriteStatus = map['favouriteStatus'];
  }

  Article.fromJSONTrash(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    favouriteStatus = map['favouriteStatus'];
  }

  Article.fromJSONDraftList(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    shortDescription = map['shortDescription'];
    thumbnail = map['thumbnail'];
    favouriteStatus = map['favouriteStatus'];
  }
  Article.fromJSONRelatedArticle(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    shortDescription = map['shortDescription'];
    thumbnail = map['thumbnail'];
    updatedAt = map['updatedAt'].toString();
    name = map['addedBy']['name'];
  }

  Article.fromJSONCommentList(Map<String, dynamic> map) {
    details = map['details'];
    likes = map['likes'].toString();
    addedBy = map['addedBy']['name'];
    commentid = map['id'];
    hasLiked = map['hasLiked'];
    print(hasLiked);
    repliesCount = map['repliesCount'];
  }
}
