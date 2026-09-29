import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/i18n/translations.dart';

/// Toutes les clés (chemins) d'un dictionnaire, avec le texte associé.
Map<String, String> flatten(dynamic node, [String path = '']) {
  final out = <String, String>{};
  if (node is Map) {
    node.forEach(
      (k, v) => out.addAll(flatten(v, path.isEmpty ? '$k' : '$path.$k')),
    );
  } else if (node is List) {
    for (var i = 0; i < node.length; i++) {
      out.addAll(flatten(node[i], '$path[$i]'));
    }
  } else {
    out[path] = '$node';
  }
  return out;
}

/// Écarts voulus, documentés dans `translations.dart` : la leçon
/// d'introduction aux signes (méthode Flores Gong Nota) n'existe qu'en
/// français, et l'indication sous la photo de profil est vide exprès.
bool isKnownException(String key) =>
    key.startsWith('coursSignesIntro.') || key == 'profileHub.photoHint';

Set<String> placeholders(String s) =>
    RegExp(r'\{(\w+)\}').allMatches(s).map((m) => m.group(1)!).toSet();

/// Une clé présente en français mais absente d'une autre langue s'affiche
/// vide (ou en repli) uniquement dans cette langue : bug invisible tant
/// qu'on ne teste pas l'app dans chaque langue.
void main() {
  final reference = flatten(fr);
  final others = {'en': flatten(en), 'es': flatten(es), 'ar': flatten(ar)};

  others.forEach((lang, dict) {
    test('$lang : mêmes textes que le français', () {
      final missing = reference.keys
          .where((k) => !dict.containsKey(k) && !isKnownException(k))
          .toList();
      final extra = dict.keys.where((k) => !reference.containsKey(k)).toList();
      expect(missing, isEmpty, reason: 'absents en $lang : $missing');
      expect(extra, isEmpty, reason: 'présents seulement en $lang : $extra');
    });

    test('$lang : mêmes {valeurs} à insérer que le français', () {
      final wrong = <String>[];
      reference.forEach((k, frText) {
        final other = dict[k];
        if (other == null) return;
        if (!placeholders(other).containsAll(placeholders(frText))) {
          wrong.add(
            '$k : fr=${placeholders(frText)} $lang=${placeholders(other)}',
          );
        }
      });
      expect(wrong, isEmpty, reason: wrong.join('\n'));
    });
  });

  test('aucun texte vide', () {
    for (final entry in {'fr': fr, 'en': en, 'es': es, 'ar': ar}.entries) {
      final empty = flatten(entry.value).entries
          .where((e) => e.value.trim().isEmpty && !isKnownException(e.key))
          .map((e) => e.key)
          .toList();
      expect(empty, isEmpty, reason: '${entry.key} : $empty');
    }
  });
}
