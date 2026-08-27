import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Un enfant au sein du compte (fratrie). Volontairement minimal : le reste
/// des données (mot de passe, photo, progression, réglages pédagogiques)
/// reste dans les mêmes services qu'avant l'introduction du multi-enfant —
/// voir [FamilyService.scopeKey], simplement isolé par un suffixe d'ID.
class ChildProfile {
  final String id;
  final String nom;

  const ChildProfile({required this.id, required this.nom});

  Map<String, dynamic> toJson() => {'id': id, 'nom': nom};

  factory ChildProfile.fromJson(Map<String, dynamic> json) =>
      ChildProfile(id: json['id'] as String, nom: json['nom'] as String);
}

const _childrenKey = 'amani_children';
const _activeChildKey = 'amani_active_child_id';

/// Clés "à plat" utilisées avant l'introduction du multi-enfant — migrées
/// une seule fois vers le premier enfant lors du tout premier lancement
/// suivant cette mise à jour (voir [_migrerDepuisProfilUnique]), jamais
/// supprimées de l'appareil (juste dupliquées sous la clé namespacée).
const List<String> _clesLegacyAMigrer = [
  'amani_profile_name',
  'amani_profile_password',
  'amani_profile_photo',
  'amani_progress_log',
  'amani_progress_bonus_points',
  'amani_setting_repetitions',
  'amani_setting_tolerance',
  'amani_setting_evaluation_duration',
  'amani_setting_format',
  'amani_backend_token',
];
const _prefixeLegacyCoursVus = 'amani_cours_viewed_';

/// Espace de nommage courant pour toute clé de stockage à isoler par
/// enfant (progression, mot de passe, réglages pédagogiques...) — mis à
/// jour de façon synchrone à chaque changement d'enfant actif, sur le même
/// principe que `kBalooFontFamily` (amani_theme.dart) : une variable de
/// module plutôt qu'un paramètre à faire transiter dans chaque fonction de
/// bas niveau, pour garder `profile_auth.dart`/`progress_service.dart`
/// etc. mécaniquement inchangés (juste `_cle` → `scopeKey(_cle)`).
String? _idEnfantActif;

/// Préfixe `baseKey` par l'identifiant de l'enfant actuellement actif.
/// Sans enfant actif (avant toute création de profil), renvoie `baseKey`
/// tel quel.
String scopeKey(String baseKey) {
  final id = _idEnfantActif;
  return id == null ? baseKey : '${baseKey}__$id';
}

/// Gère la liste des profils enfants d'un même appareil (fratrie) et
/// l'enfant actuellement actif. Toutes les autres données par enfant
/// (progression, mot de passe, réglages pédagogiques...) restent gérées
/// par leurs services habituels, simplement isolées via [scopeKey].
class FamilyService extends ChangeNotifier {
  List<ChildProfile> _children = [];
  bool _loaded = false;
  final Completer<void> _readyCompleter = Completer<void>();

  FamilyService() {
    _load();
  }

  /// Se résout une fois la liste d'enfants (et l'éventuelle migration
  /// depuis un profil unique) chargée. `main.dart` attend cette future
  /// avant `runApp` : tous les autres services par enfant (progression,
  /// mot de passe, réglages...) doivent voir [scopeKey] déjà correct dès
  /// leur toute première lecture, jamais la clé "à plat" par accident de
  /// timing entre providers construits en parallèle.
  Future<void> get ready => _readyCompleter.future;

  bool get isLoaded => _loaded;
  List<ChildProfile> get children => List.unmodifiable(_children);
  bool get hasAnyChild => _children.isNotEmpty;
  String? get activeChildId => _idEnfantActif;

  ChildProfile? get activeChild {
    final id = _idEnfantActif;
    if (id == null) return null;
    for (final c in _children) {
      if (c.id == id) return c;
    }
    return null;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_childrenKey);
    if (raw != null) {
      try {
        final parsed = jsonDecode(raw) as List<dynamic>;
        _children = parsed
            .map((e) => ChildProfile.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        _children = [];
      }
    }
    _idEnfantActif = prefs.getString(_activeChildKey);

    if (_children.isEmpty) {
      await _migrerDepuisProfilUnique(prefs);
    }

    _loaded = true;
    if (!_readyCompleter.isCompleted) _readyCompleter.complete();
    notifyListeners();
  }

  /// Un seul profil "à plat" existait avant le multi-enfant : s'il en
  /// existe un sur cet appareil (nom déjà enregistré), il devient le
  /// premier enfant — ses données sont copiées sous sa clé namespacée,
  /// jamais supprimées de l'ancien emplacement.
  Future<void> _migrerDepuisProfilUnique(SharedPreferences prefs) async {
    final nomExistant = prefs.getString('amani_profile_name');
    if (nomExistant == null || nomExistant.isEmpty) return;

    final id = DateTime.now().microsecondsSinceEpoch.toString();
    for (final cle in _clesLegacyAMigrer) {
      final valeur = prefs.getString(cle);
      if (valeur != null) {
        await prefs.setString('${cle}__$id', valeur);
      }
    }
    // Les compteurs "cours consultés" ont un préfixe dynamique
    // (typeEtape_groupCode) : on les retrouve par balayage des clés.
    for (final cle in prefs.getKeys()) {
      if (cle.startsWith(_prefixeLegacyCoursVus)) {
        final valeur = prefs.getString(cle);
        if (valeur != null) {
          await prefs.setString('${cle}__$id', valeur);
        }
      }
    }

    _children = [ChildProfile(id: id, nom: nomExistant)];
    _idEnfantActif = id;
    await _writeChildren(prefs);
    await prefs.setString(_activeChildKey, id);
  }

  Future<void> _writeChildren(SharedPreferences prefs) async {
    await prefs.setString(
      _childrenKey,
      jsonEncode(_children.map((c) => c.toJson()).toList()),
    );
  }

  /// Crée un nouvel enfant, le rend actif, et renvoie son identifiant.
  Future<String> createChild(String nom) async {
    final prefs = await SharedPreferences.getInstance();
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    _children = [..._children, ChildProfile(id: id, nom: nom)];
    _idEnfantActif = id;
    await _writeChildren(prefs);
    await prefs.setString(_activeChildKey, id);
    notifyListeners();
    return id;
  }

  Future<void> renameChild(String id, String nom) async {
    final prefs = await SharedPreferences.getInstance();
    _children = [
      for (final c in _children) c.id == id ? ChildProfile(id: id, nom: nom) : c,
    ];
    await _writeChildren(prefs);
    notifyListeners();
  }

  /// Bascule l'enfant actif. Les services par enfant (progression,
  /// réglages...) doivent recharger leur état après cet appel — voir
  /// `ProgressProvider.rechargerPourEnfantActif` et équivalents.
  Future<void> switchTo(String id) async {
    if (id == _idEnfantActif) return;
    final prefs = await SharedPreferences.getInstance();
    _idEnfantActif = id;
    await prefs.setString(_activeChildKey, id);
    notifyListeners();
  }

  /// Retire un enfant de la liste (sans effacer ses données locales, pour
  /// ne jamais perdre d'information par une suppression accidentelle — un
  /// enfant recréé sous le même nom obtient un nouvel identifiant, donc
  /// repart avec une progression vierge, jamais celle de l'ancien).
  Future<void> removeChild(String id) async {
    final prefs = await SharedPreferences.getInstance();
    _children = _children.where((c) => c.id != id).toList();
    if (_idEnfantActif == id) {
      _idEnfantActif = _children.isNotEmpty ? _children.first.id : null;
      if (_idEnfantActif != null) {
        await prefs.setString(_activeChildKey, _idEnfantActif!);
      } else {
        await prefs.remove(_activeChildKey);
      }
    }
    await _writeChildren(prefs);
    notifyListeners();
  }
}
