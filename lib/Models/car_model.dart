class CarModel {
  String name;
  String brand;
  String licencePlate;
  String imageUrl;
  String chassisNumber;
  String userUid;

  CarModel(this.name, this.brand, this.licencePlate, this.imageUrl,
      this.chassisNumber, this.userUid);

  factory CarModel.fromMap(Map map) {
    return CarModel(map['name'], map['brand'], map["licencePlate"],
        map['imageUrl'], map['chassisNumber'], map['uid']);
  }
}
