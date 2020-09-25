// SELECT `code`, `refPersonne`, `batch`, `Motif`, `entre`, `sortie`, `refPerVisiter`, `refGroupe`, `object_consigner`, `dateAdd`, `refEntreprise`, `etat`, `synchro` FROM `presences` WHERE 1

class ModelPresence {
  String code,
      refPersonne,
      batch,
      motif,
      entre,
      sortie,
      refPerVisiter,
      refGroupe,
      objectconsigner,
      dateAdd,
      refEntreprise,
      etat,
      synchro;

  ModelPresence(
      {this.code,
      this.refPersonne,
      this.batch,
      this.motif,
      this.entre,
      this.sortie,
      this.refPerVisiter,
      this.refGroupe,
      this.objectconsigner,
      this.dateAdd,
      this.refEntreprise,
      this.etat,
      this.synchro});
  factory ModelPresence.fromJson(Map<String, dynamic> json) => _$fromJson(json);
  Map<String, dynamic> toJson() => _$toJson(this);
}

ModelPresence _$fromJson(Map<String, dynamic> json) {
  return ModelPresence(
    code: json['code'],
    refPersonne: json['refPersonne'],
    batch: json['batch'],
    motif: json['Motif'],
    entre: json['entre'],
    sortie: json['sortie'],
    refPerVisiter: json['refPerVisiter'],
    refGroupe: json['refGroupe'],
    objectconsigner: json['object_consigner'],
    dateAdd: json['dateAdd'],
    refEntreprise: json['refEntreprise'],
    etat: json['etat'],
    synchro: json['synchro'],
  );
}

Map<String, dynamic> _$toJson(ModelPresence presence) => <String, dynamic>{
      'code': presence.code,
      'refPersonne': presence.refPersonne,
      'batch': presence.batch,
      'Motif': presence.motif,
      'entre': presence.entre,
      'sortie': presence.sortie,
      'refPerVisiter': presence.refPerVisiter,
      'refGroupe': presence.refGroupe,
      'object_consigner': presence.objectconsigner,
      'dateAdd': presence.dateAdd,
      'refEntreprise': presence.refEntreprise,
      'etat': presence.etat,
      'synchro': presence.synchro
    };

class CountPresence {
  String count;
  CountPresence({this.count});
  factory CountPresence.fromJson(Map<String, dynamic> json) =>
      _$fromPresence(json);
}

CountPresence _$fromPresence(Map<String, dynamic> json) {
  return CountPresence(count: 'x');
}
