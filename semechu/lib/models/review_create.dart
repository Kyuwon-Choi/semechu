class ReviewCreateModel {
  final String content;
  final String foodUUID;
  final double score;



  ReviewCreateModel({
    required this.content,
    required this.foodUUID,
    required this.score,
   
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'foodUUID': foodUUID,
      'score': score,

   
    };
  }
}
