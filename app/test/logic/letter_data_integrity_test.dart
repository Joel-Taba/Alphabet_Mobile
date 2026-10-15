import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/data/cursive_formation_catalog.dart';
import 'package:gentle_paths_academy/data/letter_formation_catalog.dart';
import 'package:gentle_paths_academy/data/letter_style_resolver.dart';
import 'package:gentle_paths_academy/data/palier2_groups.dart';
import 'package:gentle_paths_academy/data/syllable_catalog.dart';
import 'package:gentle_paths_academy/data/word_catalog.dart';
import 'package:gentle_paths_academy/utils/trace_validation.dart';

const _langs = ['fr', 'en', 'es', 'ar'];
const _styles = ['script', 'cursive'];
final _hex = RegExp(r'^#[0-9A-Fa-f]{6}$');

void _checkFormation(String where, Map<String, dynamic> l) {
  expect(l['char'], isA<String>(), reason: '$where: char');
  expect((l['char'] as String).isNotEmpty, isTrue, reason: '$where: char vide');
  expect(l['category'], isA<String>(), reason: '$where: category');
  for (final key in ['name', 'consigne']) {
    final m = l[key];
    expect(m, isA<Map>(), reason: '$where: $key absent');
    for (final lang in _langs) {
      expect(m[lang], isA<String>(), reason: '$where: $key.$lang absent');
    }
  }
  final steps = l['steps'];
  expect(steps, isA<List>(), reason: '$where: steps');
  expect((steps as List).isNotEmpty, isTrue, reason: '$where: aucun signe');
  for (var i = 0; i < steps.length; i++) {
    final s = steps[i] as Map;
    final w = '$where.steps[$i]';
    expect(s['pathD'], isA<String>(), reason: '$w: pathD');
    expect(s['family'], isA<String>(), reason: '$w: family');
    expect(
      _hex.hasMatch(s['strokeColor'] as String? ?? ''),
      isTrue,
      reason: '$w: strokeColor "${s['strokeColor']}" pas au format #RRGGBB',
    );
    final d = s['description'];
    expect(d, isA<Map>(), reason: '$w: description absente');
    for (final lang in _langs) {
      expect(d[lang], isA<String>(), reason: '$w: description.$lang absente');
    }
    // Le tracé doit être lisible et rester dans le repère 200×200 des cases.
    final pts = sampleSvgPath(s['pathD'] as String);
    expect(pts.length, greaterThan(1), reason: '$w: tracé vide/illisible');
    for (final p in pts) {
      expect(p.dx.isFinite && p.dy.isFinite, isTrue, reason: '$w: point NaN');
      expect(
        p.dx >= -2 && p.dx <= 202 && p.dy >= -2 && p.dy <= 202,
        isTrue,
        reason: '$w: point $p hors du repère 200×200',
      );
    }
    pathStartPoint(s['pathD'] as String);
    pathEndPoint(s['pathD'] as String);
  }
}

void main() {
  test(
    'chaque formation script est complète (4 langues, couleurs, tracés)',
    () {
      for (final l in LETTER_CATALOG) {
        _checkFormation('script "${l['char']}"', l as Map<String, dynamic>);
      }
    },
  );

  test(
    'chaque formation cursive est complète (4 langues, couleurs, tracés)',
    () {
      for (final l in CURSIVE_LETTERS) {
        _checkFormation('cursive "${l['char']}"', l as Map<String, dynamic>);
      }
    },
  );

  test('Palier 2 : chaque caractère des groupes existe dans les 2 styles', () {
    for (final lang in _langs) {
      for (final g in getPalier2Groups(lang)) {
        for (final c in g.chars) {
          for (final st in _styles) {
            expect(
              getLetterFormation(c, st),
              isNotNull,
              reason: 'groupe ${g.id} ($lang/$st) : "$c" introuvable',
            );
          }
        }
        for (final lang2 in _langs) {
          expect(g.title[lang2], isNotNull, reason: '${g.id}: titre $lang2');
        }
      }
    }
  });

  test(
    'Palier 3 : chaque lettre de chaque mot est traçable (toutes langues)',
    () {
      final missing = <String>{};
      for (final w in WORD_CATALOG) {
        for (final lang in ['fr', 'en', 'es']) {
          final text = w.text(lang);
          for (final c in text.split('')) {
            for (final st in _styles) {
              if (getLetterFormation(c, st) == null) {
                missing.add('${w.id} ($lang/$st) "$text" → "$c"');
              }
            }
          }
        }
      }
      expect(missing, isEmpty, reason: missing.join('\n'));
    },
  );

  test('syllabes : consonne, voyelle et syllabe entièrement traçables', () {
    final missing = <String>{};
    for (final g in SYLLABLE_GROUPS) {
      for (final s in g['syllables'] as List) {
        final txt = '${s['syllable']}${s['consonant']}${s['vowel']}';
        for (final c in txt.split('')) {
          for (final st in _styles) {
            if (getLetterFormation(c, st) == null) {
              missing.add('${g['id']} "${s['syllable']}" → "$c" ($st)');
            }
          }
        }
      }
    }
    expect(missing, isEmpty, reason: missing.join('\n'));
  });
}
