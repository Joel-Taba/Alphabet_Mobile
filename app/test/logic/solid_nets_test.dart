import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/data/solid3d_catalog.dart';
import 'package:vector_math/vector_math_64.dart';

List<List<Vector3>> faces3d(Solid3DTopic topic, double t) {
  final matrices = foldMatrices(topic.faces, (_) => t);
  return [
    for (var i = 0; i < topic.faces.length; i++)
      [
        for (final v in topic.faces[i].polygon)
          matrices[i].transform3(Vector3(v.dx, v.dy, 0)),
      ],
  ];
}

void main() {
  for (final topic in SOLID3D_TOPICS) {
    group(topic.id, () {
      test('à plat : toutes les faces reposent sur la table', () {
        for (final face in faces3d(topic, 0)) {
          for (final v in face) {
            expect(v.z.abs(), lessThan(1e-6));
          }
        }
      });

      test('plié : le solide est parfaitement fermé (chaque arête est '
          'partagée par exactement deux faces)', () {
        final faces = faces3d(topic, 1);
        final edges = <(int, Vector3, Vector3)>[];
        for (var f = 0; f < faces.length; f++) {
          final p = faces[f];
          for (var i = 0; i < p.length; i++) {
            edges.add((f, p[i], p[(i + 1) % p.length]));
          }
        }
        const tol = 1e-3;
        bool same(Vector3 a, Vector3 b) => (a - b).length < tol;
        for (final (f, a, b) in edges) {
          final partners = edges.where(
            (e) =>
                e.$1 != f &&
                ((same(e.$2, a) && same(e.$3, b)) ||
                    (same(e.$2, b) && same(e.$3, a))),
          );
          expect(
            partners.length,
            1,
            reason:
                'arête de la face $f ($a → $b) : '
                '${partners.length} voisine(s) au lieu d\'une',
          );
        }
      });

      test('plié : le solide se dresse au-dessus de la table', () {
        for (final face in faces3d(topic, 1)) {
          for (final v in face) {
            // Le solide se forme côté z < 0 (vers l'observateur).
            expect(v.z, lessThan(1e-6));
          }
        }
      });
    });
  }
}
