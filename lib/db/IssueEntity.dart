class IssueEntity{
  IssueEntity({
    required this.issueNo,
    required this.issueTitle,
    required this.issueContext,
    required this.issueUserNo,
    required this.issueDate,
    required this.issueGroupNo,
    required this.issueCommentNum,
  });
  int issueNo;
  String issueTitle;
  String issueContext;
  int issueUserNo;
  DateTime issueDate;
  int issueGroupNo;
  int issueCommentNum;
}