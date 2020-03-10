class RatingSummary {
  double average;
  int count;
  List<RatingCount> counts;

  RatingSummary({this.average, this.count, this.counts});

  RatingSummary.fromJson(Map<String, dynamic> json) {
    average = json['average'].toDouble();
    count = json['count'];
    if (json['counts'] != null) {
      counts = new List<RatingCount>();
      json['counts'].forEach((v) {
        counts.add(new RatingCount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average'] = this.average;
    data['count'] = this.count;
    if (this.counts != null) {
      data['counts'] = this.counts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RatingCount {
  int count;
  int value;

  RatingCount({this.count, this.value});

  RatingCount.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['value'] = this.value;
    return data;
  }
}