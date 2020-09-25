class ModelType {
  String code;
  String refEntreprise;
  String designation;
  String dateAdd;

  ModelType({this.code, this.refEntreprise, this.designation, this.dateAdd});
  factory ModelType.fromJson(Map<String, dynamic> json) => _$fromJsonType(json);

  Map<String, dynamic> toJson() => _$toJsonType(this);
}

ModelType _$fromJsonType(Map<String, dynamic> json) {
  return ModelType(
    code: json['code'],
    refEntreprise: json['refEntreprise'],
    designation: json['designation'],
    dateAdd: json['dateAdd'],
  );
}

Map<String, dynamic> _$toJsonType(ModelType type) => <String, dynamic>{
      'code': type.code,
      'refEntreprise': type.refEntreprise,
      'designation': type.designation,
      'dateAdd': type.dateAdd
    };
