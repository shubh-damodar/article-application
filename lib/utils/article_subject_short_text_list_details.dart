import 'package:articles/models/articles.dart';

class MailSubjectShortTextListDetails {
  List<Article> articleSearchList;

  MailSubjectShortTextListDetails({this.articleSearchList});

//  void initializeContacts(List<Email> sentConversationsList) {
//    mailsList=sentConversationsList;
//    //print('~~~ initializeContacts: ${mailsList.length}');
//  }

  Future<List<Article>> getSuggestions(
      String articleSubjectShortTextLetter) async {
    List<Article> matchedMailsList = List<Article>();

    for (Article article in articleSearchList) {
      if ((article.title
              .toLowerCase()
              .contains(articleSubjectShortTextLetter.toLowerCase())) ||
          (article.shortDescription
              .toLowerCase()
              .contains(articleSubjectShortTextLetter.toLowerCase()))) {
        matchedMailsList.add(article);
      }
    }
    return matchedMailsList;
  }
}
