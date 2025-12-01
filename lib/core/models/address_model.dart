class AddressModel {
  String street;
  String number;
  String district;
  String complement;

  AddressModel({
    this.street = '',
    this.number = '',
    this.district = '',
    this.complement = '',
  });

  @override
  String toString() => "$street, $number - $district";
}