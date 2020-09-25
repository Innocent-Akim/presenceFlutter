class ModelLogin {
  // String code;
  // String codeEntrep;
  // String psedo;
  // String email;
  // String pswd;
  // String fonction;
  // String dateAdd;

  String code,
      refEntreprise,
      refPersonne,
      psedo,
      pswd,
      fonction,
      email,
      etat,
      dateUpdate,
      dateAdd,
      synchro;
  ModelLogin({
    this.code,
    this.refEntreprise,
    this.refPersonne,
    this.psedo,
    this.pswd,
    this.fonction,
    this.email,
    this.etat,
    this.dateUpdate,
    this.dateAdd,
    this.synchro,
  });
  factory ModelLogin.fromJson(Map<String, dynamic> json) => _$fromJson(json);
  Map<String, dynamic> toJson() => _$toJson(this);
}

ModelLogin _$fromJson(Map<String, dynamic> json) {
  return ModelLogin(
    code: json['code'],
    refEntreprise: json['refEntreprise'],
    refPersonne: json['refPersonne'],
    psedo: json['psedo'],
    pswd: json['pswd'],
    fonction: json['fonction'],
    email: json['email'],
    etat: json['etat'],
    dateUpdate: json['dateUpdate'],
    dateAdd: json['dateAdd'],
    synchro: json['synchro'],
  );
}

Map<String, dynamic> _$toJson(ModelLogin login) => <String, dynamic>{
      'code': login.code,
      'refEntreprise': login.refEntreprise,
      'refPersonne': login.refPersonne,
      'psedo': login.psedo,
      'pswd': login.pswd,
      'fonction': login.fonction,
      'email': login.email,
      'etat': login.etat,
      'dateUpdate': login.dateUpdate,
      'dateAdd': login.dateAdd,
      'synchro': login.synchro
    };
