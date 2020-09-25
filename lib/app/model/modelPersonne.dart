class ModelPersonne {
  String code,
      nom,
      genre,
      tel,
      email,
      adresse,
      fonction,
      batch,
      refGroupe,
      refEntreprise,
      refType,
      image,
      dateAdd,
      dateUpdate,
      etat,
      synchro,
      entreprise;

  ModelPersonne(
      {this.code,
      this.nom,
      this.genre,
      this.tel,
      this.email,
      this.adresse,
      this.fonction,
      this.batch,
      this.refGroupe,
      this.refEntreprise,
      this.refType,
      this.image,
      this.dateAdd,
      this.dateUpdate,
      this.etat,
      this.synchro,
      this.entreprise});

  factory ModelPersonne.fromJson(Map<String, dynamic> json) => _$fromJson(json);
  Map<String, dynamic> toJson() => _$toJson(this);
}

ModelPersonne _$fromJson(Map<String, dynamic> json) {
  return ModelPersonne(
    code: json['code'],
    nom: json['nom'],
    genre: json['genre'],
    tel: json['tel'],
    email: json['email'],
    adresse: json['adresse'],
    fonction: json['fonction'],
    batch: json['batch'],
    refGroupe: json['refGroupe'],
    refEntreprise: json['refEntreprise'],
    refType: json['refType'],
    image: json['image'],
    dateAdd: json['dateAdd'],
    dateUpdate: json['dateUpdate'],
    etat: json['etat'],
    synchro: json['synchro'],
    entreprise: json['entreprise'],
  );
}

Map<String, dynamic> _$toJson(ModelPersonne personne) => <String, dynamic>{
      'code': personne.code,
      'nom': personne.nom,
      'genre': personne.genre,
      'tel': personne.tel,
      'email': personne.email,
      'adresse': personne.adresse,
      'fonction': personne.fonction,
      'batch': personne.batch,
      'refGroupe': personne.refGroupe,
      'refEntreprise': personne.refEntreprise,
      'refType': personne.refType,
      'image': personne.image,
      'dateAdd': personne.dateAdd,
      'dateUpdate': personne.dateUpdate,
      'etat': personne.etat,
      'synchro': personne.synchro,
      'entreprise': personne.entreprise
    };

class ModelForetgetPassword {
  String nom;
  String telephone;
  String password;

  ModelForetgetPassword({this.nom, this.telephone, this.password});
  factory ModelForetgetPassword.jsonForet(Map<String, dynamic> json) =>
      _$foretJson(json);
}

ModelForetgetPassword _$foretJson(Map<String, dynamic> json) {
  return ModelForetgetPassword(nom: 'nom', telephone: 'tel', password: 'pswd');
}
