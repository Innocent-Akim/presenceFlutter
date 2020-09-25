class ModelUsers {
  // `code`, `refEntreprise`, `refPersonne`, `psedo`, `pswd`, `fonction`, `email`, `etat`, `dateUpdate`, `dateAdd`
  String code,
      refEntreprise,
      refPersonne,
      psedo,
      email,
      pswd,
      fonction,
      dateAdd,
      dateUpdate;
  ModelUsers({
    this.code,
    this.refEntreprise,
    this.refPersonne,
    this.psedo,
    this.email,
    this.pswd,
    this.fonction,
    this.dateUpdate,
    this.dateAdd,
  });
  factory ModelUsers.fromJson(Map<String, dynamic> json) => _$fromjson(json);
  Map<String, dynamic> toJson() => _$toJson(this);
}
// SELECT `code`, `refEntreprise`, `refPersonne`, `psedo`, `pswd`, `fonction`, `email`, `etat`, `dateUpdate`, `dateAdd`, `synchro` FROM `user` WHERE 1

ModelUsers _$fromjson(Map<String, dynamic> json) {
  return ModelUsers(
      code: json['code'],
      refEntreprise: json['refEntreprise'],
      refPersonne: json['refPersonne'],
      psedo: json['refPersonne'],
      email: json['psedo'],
      pswd: json['pswd'],
      fonction: json['fonction'],
      dateUpdate: json['dateUpdate'],
      dateAdd: json['dateAdd']);
}

Map<String, dynamic> _$toJson(ModelUsers users) => <String, dynamic>{
      'code': users.code,
      'refEntreprise': users.refEntreprise,
      'refPersonne': users.refPersonne,
      'psedo': users.psedo,
      'email': users.email,
      'pswd': users.pswd,
      'fonction': users.fonction,
      'dateUpdate': users.dateUpdate,
      'dateAdd': users.dateAdd
    };
