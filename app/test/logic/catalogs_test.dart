import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/data/calcul_catalog.dart';
import 'package:gentle_paths_academy/data/palier2_groups.dart';
import 'package:gentle_paths_academy/data/shape_catalog.dart';
import 'package:gentle_paths_academy/data/sign_exercise_catalog.dart';
import 'package:gentle_paths_academy/data/solid3d_catalog.dart';
import 'package:gentle_paths_academy/data/syllable_catalog.dart';
import 'package:gentle_paths_academy/data/word_catalog.dart';

/// Renvoie les éléments présents plusieurs fois dans [items].
List<String> duplicates(Iterable<String> items) {
  final seen = <String>{};
  return [
    for (final i in items)
      if (!seen.add(i)) i,
  ];
}

/// Intégrité des catalogues : la progression est indexée par identifiant.
/// Deux étapes avec le même identifiant partageraient leur état "réalisé"
/// -- réussir l'une cocherait l'autre, sans qu'elle ait jamais été faite.
void main() {
  test('signes : identifiants uniques, chaque famille a des exercices', () {
    expect(duplicates(EXERCISE_CATALOG.map((e) => e['id'] as String)), isEmpty);
    for (final family in FAMILY_ORDER) {
      expect(
        EXERCISE_CATALOG.where((e) => e['family'] == family),
        isNotEmpty,
        reason: 'famille $family vide',
      );
    }
  });

  test('lettres : groupes uniques, aucune lettre dans deux groupes', () {
    for (final lang in ['fr', 'en', 'es', 'ar']) {
      final groups = getPalier2Groups(lang);
      expect(duplicates(groups.map((g) => g.id)), isEmpty, reason: lang);
      expect(
        duplicates(groups.expand((g) => g.chars)),
        isEmpty,
        reason:
            '$lang : une lettre partagée entre deux groupes serait '
            'cochée dans les deux dès qu\'elle est réussie dans un seul',
      );
      for (final g in groups) {
        expect(g.chars, isNotEmpty, reason: '${g.id} vide');
      }
    }
  });

  test('syllabes : consonnes et syllabes uniques', () {
    expect(
      duplicates(SYLLABLE_GROUPS.map((g) => g['consonant'] as String)),
      isEmpty,
    );
    expect(
      duplicates(
        SYLLABLE_GROUPS.expand(
          (g) => (g['syllables'] as List).map((s) => s['syllable'] as String),
        ),
      ),
      isEmpty,
    );
  });

  test('mots : identifiants uniques, aucun mot dans deux groupes', () {
    expect(duplicates(WORD_CATALOG.map((w) => w.id)), isEmpty);
    expect(duplicates(PALIER3_GROUPS.map((g) => g.id)), isEmpty);
    expect(
      duplicates(PALIER3_GROUPS.expand((g) => g.words.map((w) => w.id))),
      isEmpty,
    );
  });

  test('sujets calcul/figures/solides : identifiants uniques et sans '
      'collision avec le format des tentatives "sujet-N"', () {
    for (final ids in [
      CALCUL_TOPICS.map((t) => t.id).toList(),
      SHAPE_TOPICS.map((t) => t.id).toList(),
      SOLID3D_TOPICS.map((t) => t.id).toList(),
    ]) {
      expect(duplicates(ids), isEmpty);
      // Une tentative "X-3" est rattachée au sujet X (tout ce qui précède le
      // dernier "-"). Si un autre sujet s'appelait exactement "X-3", ses
      // propres tentatives et celles de X se mélangeraient.
      for (final id in ids) {
        final cut = id.lastIndexOf('-');
        if (cut == -1) continue;
        final head = id.substring(0, cut);
        final tail = id.substring(cut + 1);
        if (int.tryParse(tail) != null) {
          expect(
            ids,
            isNot(contains(head)),
            reason: '"$id" ressemble à une tentative du sujet "$head"',
          );
        }
      }
    }
  });

  test('solides : chaque solide a une couleur et un patron', () {
    for (final t in SOLID3D_TOPICS) {
      expect(kSolidColors.containsKey(t.id), isTrue, reason: t.id);
      expect(
        t.faces.where((f) => f.parentIndex == -1).length,
        1,
        reason: '${t.id} : exactement une face posée au sol',
      );
      for (var i = 0; i < t.faces.length; i++) {
        expect(
          t.faces[i].parentIndex,
          lessThan(i),
          reason: '${t.id} : une face doit suivre son parent',
        );
      }
    }
  });
}
