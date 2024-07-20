class VendorUserModel {
  final bool? approved;
  final String? businessName;
  final String? cityValue;
  final String? countryValue;
  final String? email;
  final String? stateValue;
  final String? phoneNumber;
  final String? storeImage;
  final String? taxNumber;
  final String? taxStatus;
  final String? vendorId;

  VendorUserModel(
      {required this.approved,
      required this.businessName,
      required this.cityValue,
      required this.countryValue,
      required this.email,
      required this.stateValue,
      required this.phoneNumber,
      required this.storeImage,
      required this.taxNumber,
      required this.taxStatus,
      required this.vendorId});

  VendorUserModel.fromJson(Map<String, Object?> json)
      : this(
          approved: json['approved']! as bool,
          businessName: json['businessName']! as String,
          phoneNumber: json['phoneNumber']! as String,
          cityValue: json['cityValue']! as String,
          stateValue: json['stateValue']! as String,
          countryValue: json['countryValue']! as String,
          taxNumber: json['taxNumber']! as String,
          taxStatus: json['taxStatus']! as String,
          email: json['email']! as String,
          storeImage: json['storeImage']! as String,
          vendorId: json['vendorId']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'approved': approved,
      'businessName': businessName,
      'phoneNumber': phoneNumber,
      'cityValue': cityValue,
      'stateValue': stateValue,
      'countryValue': countryValue,
      'taxNumber': taxNumber,
      'taxStatus': taxStatus,
      'email': email,
      'storeImage': storeImage,
      'vendorId': vendorId,
    };
  }
}
