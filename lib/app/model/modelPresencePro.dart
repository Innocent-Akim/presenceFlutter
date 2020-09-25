class ModelPresencePro {
  String batch, motif, refPerVisiter, objectconsigner, refEntreprise, status;
  ModelPresencePro({
    this.batch,
    this.refPerVisiter,
    this.motif,
    this.objectconsigner,
    this.refEntreprise,
    this.status,
  });

  factory ModelPresencePro.fromJson(Map<String, dynamic> json) =>
      _$fromJson(json);
}

ModelPresencePro _$fromJson(Map<String, dynamic> json) {
  return ModelPresencePro(
    batch: json['batch_'],
    refPerVisiter: json['motif_'],
    motif: json['personneAvis_'],
    objectconsigner: json['objet_consigne_'],
    refEntreprise: json['refEntreprise_'],
    status: json['status_'],
  );
}
