class CommentEntity{
  CommentEntity({
    required this.commentNo,
    required this.commentIssueNo,
    required this.commentUserNo,
    required this.commentText,
    required this.commentDate,
    required this.commentGroupNo,
  });
  int commentNo;
  int commentIssueNo;
  int commentUserNo;
  String commentText;
  DateTime commentDate;
  int commentGroupNo;
}