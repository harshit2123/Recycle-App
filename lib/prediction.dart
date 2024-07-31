class Prediction {
  // int? can;
  // int? bottle;
  int? aluminiumCans;
  int? gableTop;
  int? glassBottle;
  int? milkGallon;
  int? plastic;
  int? tetrapack;
  String? object;

  Prediction({
    // this.can,
    // this.bottle,
    this.aluminiumCans,
    this.gableTop,
    this.glassBottle,
    this.milkGallon,
    this.plastic,
    this.tetrapack,
    this.object,
  });

  Prediction.fromJson(Map<String, dynamic> json) {
    // can = json['can'];
    // bottle = json['bottle'];
    aluminiumCans = json['Aluminium Cans'];
    gableTop = json['Gable Top'];
    glassBottle = json['Glass Bottle'];
    milkGallon = json['Milk Gallon'];
    plastic = json['Plastic'];
    tetrapack = json['Tetrapack'];
    object = json['Object'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['can'] = this.can;
    // data['bottle'] = this.bottle;
    data['Aluminium Cans'] = this.aluminiumCans;
    data['Gable Top'] = this.gableTop;
    data['Glass Bottle'] = this.glassBottle;
    data['Milk Gallon'] = this.milkGallon;
    data['Plastic'] = this.plastic;
    data['Tetrapack'] = this.tetrapack;
    data['Object'] = this.object;
    return data;
  }
}