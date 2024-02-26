class ReviewModel {
  final String content, reviewUUID, memberUUID, foodUUID;
  final double score;

  ReviewModel({
    required this.content,
    required this.reviewUUID,
    required this.memberUUID,
    required this.foodUUID,
    required this.score,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      content: json['content'],
      reviewUUID: json['reviewUUID'],
      memberUUID: json['memberUUID'],
      foodUUID: json['foodUUID'],
      score: double.parse(json['score']),
    );
  }
}
