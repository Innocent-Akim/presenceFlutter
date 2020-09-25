import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_PRESENCE = 'presences';
const COLUMN_CODE = 'code';
const COLUMN_NOM = 'nom';
const COLUMN_VISTER = 'visiter';
const COLUMN_DATE_ENTRE = 'date_entre';
const COLUMN_DATE_SORTIE = 'date_sortie';
const COLUMN_BATCH = 'batch';
const COLUMN_REFENTREPRISE = 'refentreprise';
const COLUMN_STATUS = 'status';
const COLUMN_CONSIGNE = 'consigne';

Database _database;
Future<Database> get database async {
  if (_database != null) {
    return _database;
  }
  return _database = await createDatabase();
}

Future<Database> createDatabase() async {
  try {
    String dbPath = await getDatabasesPath();
    return await openDatabase(join(dbPath, 'dbLocal.db'), version: 1,
        onCreate: (Database database, int version) async {
      print("Database cree avec succes");
      await database.execute(
        "CREATE TABLE $TABLE_PRESENCE ("
        "$COLUMN_NOM VARCHAR(255),"
        "$COLUMN_VISTER VARCHAR(255),"
        "$COLUMN_DATE_ENTRE VARCHAR(255),"
        "$COLUMN_DATE_SORTIE VARCHAR(255),"
        "$COLUMN_BATCH VARCHAR(255),"
        "$COLUMN_REFENTREPRISE VARCHAR(255),"
        "$COLUMN_CONSIGNE VARCHAR(255),"
        "$COLUMN_STATUS VARCHAR(255))",
      );
      print("Table cree avec succes");
    });
  } catch (_) {
    print(_.toString());
  }
  return null;
}

Future<int> createCustomer(ModelLocal local) async {
  final db = await database;
  var resultat = await db.insert(TABLE_PRESENCE, local.toJson());
  return resultat;
}

Future<List<dynamic>> getData(
    {String batch, String refEnreprise, String status}) async {
  final db = await database;
  try {
    var resultat = await db.query(
      TABLE_PRESENCE,
      columns: [
        COLUMN_NOM,
        COLUMN_VISTER,
        COLUMN_DATE_ENTRE,
        COLUMN_DATE_SORTIE,
        COLUMN_BATCH,
        COLUMN_REFENTREPRISE,
        COLUMN_CONSIGNE,
        COLUMN_STATUS
      ],
      where:
          "$COLUMN_BATCH=? AND $COLUMN_REFENTREPRISE=?  AND  $COLUMN_DATE_SORTIE is null ",
      whereArgs: [batch, refEnreprise],
    );
    if (resultat != null) {
      return resultat;
    }
  } catch (_) {
    print(_.toString());
  }
  return null;
}

Future<int> deleteData({String batch, refEntreprise}) async {
  final db = await database;
  try {
    var resultat = await db.delete(TABLE_PRESENCE,
        where: "$COLUMN_BATCH=? AND $COLUMN_REFENTREPRISE=?",
        whereArgs: [batch, refEntreprise]);
    return resultat;
  } catch (_) {
    print(_.toString());
  }
  return 0;
}

Future<List<dynamic>> isCountvisiteur() async {
  try {
    final db = await database;
    var resultat = await db.rawQuery(
        "SELECT COUNT(*) count FROM $TABLE_PRESENCE WHERE $COLUMN_STATUS=1");
    return resultat;
  } catch (_) {
    print(_.toString());
  }
  return null;
}

class ModelLocal {
  String nom,
      visiter,
      dateentre,
      datesortie,
      batch,
      refEntreprise,
      consigne,
      count,
      status;
  ModelLocal({
    this.nom,
    this.visiter,
    this.dateentre,
    this.datesortie,
    this.batch,
    this.refEntreprise,
    this.consigne,
    this.status,
    this.count,
  });

  factory ModelLocal.fromJson(Map<String, dynamic> json) => _$fromJson(json);
  Map<String, dynamic> toJson() => _$toJson(this);
  factory ModelLocal.fromCount(Map<String, dynamic> json) => _$contJson(json);
}

ModelLocal _$contJson(Map<String, dynamic> json) {
  return ModelLocal(count: json['count'].toString());
}

ModelLocal _$fromJson(Map<String, dynamic> json) {
  return ModelLocal(
    nom: json['nom'],
    visiter: json['visiter'],
    dateentre: json['date_entre'],
    datesortie: json['date_sortie'],
    batch: json['batch'],
    refEntreprise: json['refentreprise'],
    consigne: json['consigne'],
    status: json['status'],
    count: json['count'],
  );
}

Map<String, dynamic> _$toJson(ModelLocal local) => <String, dynamic>{
      'nom': local.nom,
      'visiter': local.visiter,
      'date_entre': local.dateentre,
      'date_sortie': local.datesortie,
      'batch': local.batch,
      'refentreprise': local.refEntreprise,
      'consigne': local.consigne,
      'status': local.status
    };
