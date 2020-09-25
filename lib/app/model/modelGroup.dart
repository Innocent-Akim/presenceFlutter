class ModelGroup {
  String code,
      refEntreprise,
      nomGroupe,
      tel,
      email,
      siteWeb,
      description,
      logo,
      dateAdd,
      dateUpdate,
      espace,
      synchro;

  ModelGroup({
    this.code,
    this.refEntreprise,
    this.nomGroupe,
    this.tel,
    this.email,
    this.siteWeb,
    this.description,
    this.dateAdd,
    this.dateUpdate,
    this.espace,
    this.synchro,
  });

  factory ModelGroup.fromJson(Map<String, dynamic> json) => _$fromJson(json);
  Map<String, dynamic> toJson() => _$toJson(this);
}

ModelGroup _$fromJson(Map<String, dynamic> json) {
  return ModelGroup(
    code: json['code'],
    refEntreprise: json['refEntreprise'],
    nomGroupe: json['nomGroupe'],
    tel: json['tel'],
    email: json['email'],
    siteWeb: json['siteWeb'],
    description: json['description'],
    dateAdd: json['dateAdd'],
    dateUpdate: json['dateUpdate'],
    espace: json['espace'],
    synchro: json['synchro'],
  );
}

Map<String, dynamic> _$toJson(ModelGroup group) => <String, dynamic>{
      'code': group.code,
      'refEntreprise': group.code,
      'nomGroupe': group.nomGroupe,
      'tel': group.tel,
      'email': group.email,
      'siteWeb': group.siteWeb,
      'description': group.description,
      'dateAdd': group.dateAdd,
      'dateUpdate': group.dateUpdate,
      'espace': group.espace,
      'synchro': group.synchro,
    };
