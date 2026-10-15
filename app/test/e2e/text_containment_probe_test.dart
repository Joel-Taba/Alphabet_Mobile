import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/data/calcul_catalog.dart';
import 'package:gentle_paths_academy/data/palier2_groups.dart';
import 'package:gentle_paths_academy/data/shape_catalog.dart';
import 'package:gentle_paths_academy/data/sign_exercise_catalog.dart';
import 'package:gentle_paths_academy/data/solid3d_catalog.dart';
import 'package:gentle_paths_academy/data/syllable_catalog.dart';
import 'package:gentle_paths_academy/data/word_catalog.dart';
import 'package:gentle_paths_academy/hooks/use_accessibility_settings.dart';
import 'package:provider/provider.dart';

import '../helpers/app_harness.dart';
import '../helpers/test_env.dart';

const _out = String.fromEnvironment('OUT');
const _only = String.fromEnvironment('ONLY');
const _dys = bool.fromEnvironment('DYS');
const _shots = String.fromEnvironment('SHOTS');
const _w = int.fromEnvironment('W', defaultValue: 412);

const _framework = {'Text','RichText','DefaultTextStyle','Padding','Center','Align','SizedBox','ConstrainedBox','Container','DecoratedBox','ClipRRect','ClipOval','Semantics','GestureDetector','RawGestureDetector','Listener','MouseRegion','Builder','LayoutBuilder','Flexible','Expanded','Row','Column','Stack','Positioned','Opacity','AnimatedContainer','AnimatedOpacity','FittedBox','Transform','IconTheme','InkWell','Material','AnimatedBuilder','ListenableBuilder','KeyedSubtree','RepaintBoundary','IgnorePointer','AbsorbPointer','Wrap','ColoredBox','LimitedBox','IntrinsicHeight','IntrinsicWidth','_GestureSemantics','MediaQuery','Directionality','Tooltip','Ink','InkResponse','_InkResponseStateWidget','Focus','Actions','Shortcuts','DefaultSelectionStyle','SingleChildScrollView','_SingleChildViewport','Scrollable','NotificationListener','_SelectionKeepAlive','AutomaticKeepAlive','KeepAlive','_KeepAliveItem','IndexedSemantics','SliverList','ListView','Viewport','_ScrollableScope','StretchingOverscrollIndicator','GlowingOverscrollIndicator','PrimaryScrollController','_ScrollSemantics','_PointerListener','ScrollConfiguration','TextButton','ElevatedButton','_Decorator','InputDecorator','TweenAnimationBuilder','AnimatedScale','ScaleTransition','FadeTransition','SlideTransition','AnimatedSwitcher','CustomPaint','Offstage','TickerMode','Visibility','AnimatedDefaultTextStyle','AnimatedPadding','AnimatedAlign','AnimatedPositioned','MergeSemantics','ExcludeSemantics','Draggable','DragTarget','LongPressDraggable','_EffectiveTickerMode','Overlay','_Theater','_OverlayEntryWidget','Hero','PageStorage','ValueListenableBuilder','StreamBuilder','FutureBuilder','Consumer','Selector','ChangeNotifierProvider','Provider','Flex','_DragTargetState','Card','Chip','Icon','Image','ClipPath','PhysicalModel','PhysicalShape','_AnimatedShakeBuilder','UnconstrainedBox','OverflowBox','SizedOverflowBox','FractionallySizedBox','AspectRatio','Baseline','Spacer','Divider'};

Rect _globalRect(RenderBox b) =>
    MatrixUtils.transformRect(b.getTransformTo(null), Offset.zero & b.size);

/// Contenant visible le plus proche : boîte décorée (fond, bordure, cercle)
/// ou découpe.
RenderBox? _container(RenderObject o) {
  var p = o.parent;
  while (p != null) {
    if (p is RenderDecoratedBox) {
      final d = p.decoration;
      if (d is BoxDecoration &&
          (d.color != null ||
              d.border != null ||
              d.gradient != null ||
              d.shape == BoxShape.circle)) {
        return p;
      }
      if (d is ShapeDecoration) return p;
    }
    if (p is RenderClipOval || p is RenderClipRRect) return p as RenderBox;
    if (p is RenderPhysicalShape || p is RenderPhysicalModel) {
      return p as RenderBox;
    }
    p = p.parent;
  }
  return null;
}

void main() {
  setUp(resetTestEnv);

  final groups = getPalier2Groups('fr');
  final routes = allRoutes(
    signFamilies: FAMILY_ORDER,
    letterGroupFirstChars: groups.map((g) => g.chars.first),
    letterGroupIds: groups.map((g) => g.id),
    consonants: SYLLABLE_GROUPS.map((g) => g['consonant'] as String),
    calculTopics: CALCUL_TOPICS.map((t) => t.id),
    wordGroups: PALIER3_GROUPS.map((g) => g.id),
    shapes: SHAPE_TOPICS.map((t) => t.id),
    solids: SOLID3D_TOPICS.map((t) => t.id),
    vraiFauxLevels: VRAI_FAUX_LEVELS.length,
    composeLevels: COMPOSE_NOMBRE_LEVELS.length,
  ).where((r) => _only.isEmpty || _only.split(',').any((o) => r == o)).toList();

  testWidgets('textes contenus dans leur cadre (police max)', (tester) async {
    final family = await launchApp(
      tester,
      size: Size(_w.toDouble(), _w > 600 ? 1280 : 915),
    );
    await tester.runAsync(() => family.createChild('Awa'));
    final ctx = tester.element(find.byType(Navigator).first);
    await tester.runAsync(() async {
      final a11y = Provider.of<AccessibilitySettings>(ctx, listen: false);
      await a11y.setUiScale(kMaxUiScale);
      if (_dys) await a11y.setDyslexiaFont(true);
    });
    await advance(tester, frames: 3);

    final report = <String>{};
    final original = FlutterError.onError;
    FlutterError.onError = (_) {};
    try {
      for (final route in routes) {
        await goTo(tester, route);
        if (_shots.isNotEmpty) {
          final ro =
              tester.renderObject(find.byType(RepaintBoundary).first)
                  as RenderRepaintBoundary;
          await tester.runAsync(() async {
            final img = await ro.toImage(pixelRatio: 1);
            final d = await img.toByteData(format: ui.ImageByteFormat.png);
            final name = route.replaceAll(RegExp(r'[^\w]+'), '_');
            File('$_shots/$name.png').writeAsBytesSync(d!.buffer.asUint8List());
          });
        }
        final root = tester.binding.renderViews.first;
        void visit(RenderObject o) {
          if (o is RenderParagraph && o.hasSize && o.attached) {
            final text = o.text.toPlainText().trim();
            if (text.isNotEmpty) {
              final r = _globalRect(o);
              // Texte plus grand que sa propre boîte (mot coupé/débordant).
              final minW = o.getMinIntrinsicWidth(double.infinity);
              final h = o.getMaxIntrinsicHeight(o.size.width);
              final c = _container(o);
              String? why;
              if (minW > o.size.width + 1.5 &&
                  (o.maxLines != null || !o.softWrap)) {
                why = 'tronqué';
              } else if (minW > o.size.width + 1.5) {
                why = 'mot trop large ${minW.toStringAsFixed(0)}>${o.size.width.toStringAsFixed(0)}';
              } else if (h > o.size.height + 1.5 && o.maxLines == null) {
                why = 'trop haut ${h.toStringAsFixed(0)}>${o.size.height.toStringAsFixed(0)}';
              } else if (c != null && c.hasSize) {
                final cr = _globalRect(c);
                // Fond de page ou carte pleine largeur : pas un « cadre ».
                if (cr.height < 400 &&
                    (r.left < cr.left - 1.5 ||
                        r.right > cr.right + 1.5 ||
                        r.top < cr.top - 1.5 ||
                        r.bottom > cr.bottom + 1.5)) {
                  why =
                      'sort du cadre ${cr.width.toStringAsFixed(0)}x${cr.height.toStringAsFixed(0)} '
                      '(texte ${r.width.toStringAsFixed(0)}x${r.height.toStringAsFixed(0)})';
                }
              }
              if (why != null) {
                final short = text.length > 40 ? '${text.substring(0, 40)}…' : text;
                final chain =
                    (o.debugCreator as DebugCreator?)?.element
                        .debugGetCreatorChain(40)
                        .split(' ← ')
                        .map((w) => w.split('(').first.split('-').first)
                        .where((w) => !_framework.contains(w))
                        .take(3)
                        .join('<') ??
                    '?';
                report.add('$route | "$short" | $why | $chain');
              }
            }
          }
          o.visitChildren(visit);
        }

        visit(root);
      }
    } finally {
      FlutterError.onError = original;
    }
    final lines = report.toList()..sort();
    if (_out.isNotEmpty) File(_out).writeAsStringSync(lines.join('\n'));
    // ignore: avoid_print
    print('${lines.length} problème(s)');
    await tester.pumpWidget(const SizedBox());
    await advance(tester, frames: 3);
  }, variant: mobile, timeout: const Timeout(Duration(minutes: 20)));
}
