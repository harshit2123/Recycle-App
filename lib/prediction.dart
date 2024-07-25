// class Prediction {
//   int? can;
//   int? bottle;

//   Prediction({this.can, this.bottle});

//   Prediction.fromJson(Map<String, dynamic> json) {
//     can = json['can'];
//     bottle = json['bottle'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['can'] = this.can;
//     data['bottle'] = this.bottle;
//     return data;
//   }
// }
class RecycleObject {
  String name;
  int count;
  double price;

  RecycleObject({required this.name, required this.count, required this.price});

  factory RecycleObject.fromJson(Map<String, dynamic> json) {
    return RecycleObject(
      name: json['name'],
      count: json['count'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'count': count,
      'price': price,
    };
  }
}

class Prediction {
  List<RecycleObject> objects;

  Prediction({required this.objects});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    var objectsList = json['objects'] as List;
    List<RecycleObject> recycleObjects = objectsList
        .map((objectJson) => RecycleObject.fromJson(objectJson))
        .toList();

    return Prediction(objects: recycleObjects);
  }

  Map<String, dynamic> toJson() {
    return {
      'objects': objects.map((object) => object.toJson()).toList(),
    };
  }
}
