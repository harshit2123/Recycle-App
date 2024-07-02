class Prediction {
  int? can;
  int? bottle;

  Prediction({this.can, this.bottle});

  Prediction.fromJson(Map<String, dynamic> json) {
    can = json['can'];
    bottle = json['bottle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['can'] = this.can;
    data['bottle'] = this.bottle;
    return data;
  }
}
