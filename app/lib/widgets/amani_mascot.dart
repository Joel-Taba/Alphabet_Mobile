import 'package:flutter/material.dart';

/// Poses de la mascotte Amani, correspondant aux fichiers image.
enum AmaniPose {
  accueil,
  demonstration,
  encouragement,
  celebration,
  reconfort,
  reflexion,
  veille,
  miniReussite,
  miniReessai,
  invitation,
  curiosite,
  emerveillement,
  victoirePalier,
  podium,
  dessin,
  perdu,
  motsCroises,
  motsMeles,
}

/// Tailles prédéfinies de la mascotte.
enum AmaniSize {
  heroLg(288),
  hero(240),
  medium(120),
  small(72),
  avatar(48);

  final double dimension;
  const AmaniSize(this.dimension);
}

/// Correspondance pose → fichier image.
const Map<AmaniPose, String> _poseAssets = {
  AmaniPose.accueil: 'assets/images/amani-accueil.png',
  AmaniPose.demonstration: 'assets/images/amani-demonstration.png',
  AmaniPose.encouragement: 'assets/images/amani-encouragement.png',
  AmaniPose.celebration: 'assets/images/amani-celebration.png',
  AmaniPose.reconfort: 'assets/images/amani-reconfort.png',
  AmaniPose.reflexion: 'assets/images/amani-reflexion.png',
  AmaniPose.veille: 'assets/images/amani-veille.png',
  AmaniPose.miniReussite: 'assets/images/amani-mini-reussite.png',
  AmaniPose.miniReessai: 'assets/images/amani-reessai.png',
  AmaniPose.invitation: 'assets/images/amani-invitation.png',
  AmaniPose.curiosite: 'assets/images/amani-curiosite.png',
  AmaniPose.emerveillement: 'assets/images/amani-emerveillement.png',
  AmaniPose.victoirePalier: 'assets/images/amani-victoire-palier.png',
  AmaniPose.podium: 'assets/images/amani-podium.png',
  AmaniPose.dessin: 'assets/images/amani-dessin.png',
  AmaniPose.perdu: 'assets/images/amani-perdu.png',
  AmaniPose.motsCroises: 'assets/images/amani-mots-croises.png',
  AmaniPose.motsMeles: 'assets/images/amani-mots-meles.png',
};

/// Labels d'accessibilité par pose.
const Map<AmaniPose, String> _poseLabels = {
  AmaniPose.accueil: 'Amani te salue',
  AmaniPose.demonstration: 'Amani te montre un signe',
  AmaniPose.encouragement: "Amani t'encourage",
  AmaniPose.celebration: 'Amani célèbre ta réussite',
  AmaniPose.reconfort: 'Amani te réconforte',
  AmaniPose.reflexion: 'Amani réfléchit',
  AmaniPose.veille: 'Amani se repose',
  AmaniPose.miniReussite: 'Amani est ravi de ta réussite',
  AmaniPose.miniReessai: "Amani t'encourage à réessayer",
  AmaniPose.invitation: "Amani t'invite à continuer",
  AmaniPose.curiosite: 'Amani est curieux',
  AmaniPose.emerveillement: "Amani s'émerveille",
  AmaniPose.victoirePalier: 'Amani fête ton palier',
  AmaniPose.podium: 'Amani te félicite sur le podium',
  AmaniPose.dessin: 'Amani dessine',
  AmaniPose.perdu: 'Amani est perdu',
  AmaniPose.motsCroises: 'Grille de mots croisés',
  AmaniPose.motsMeles: 'Grille de mots mêlés',
};

/// Widget de la mascotte Amani.
class AmaniMascot extends StatelessWidget {
  final AmaniPose pose;
  final AmaniSize size;
  final bool waving;

  const AmaniMascot({
    super.key,
    this.pose = AmaniPose.accueil,
    this.size = AmaniSize.medium,
    this.waving = false,
  });

  @override
  Widget build(BuildContext context) {
    final dim = size.dimension;
    final asset = _poseAssets[pose]!;
    final label = _poseLabels[pose]!;

    Widget image = Image.asset(
      asset,
      width: dim,
      height: dim,
      fit: BoxFit.contain,
      semanticLabel: label,
    );

    if (waving) {
      image = _WavingAnimation(child: image);
    }

    return SizedBox(width: dim, height: dim, child: image);
  }
}

/// Animation de balancement doux.
class _WavingAnimation extends StatefulWidget {
  final Widget child;
  const _WavingAnimation({required this.child});

  @override
  State<_WavingAnimation> createState() => _WavingAnimationState();
}

class _WavingAnimationState extends State<_WavingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _rotation = Tween<double>(
      begin: -0.17,
      end: 0.17,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotation,
      builder: (_, child) => Transform.rotate(
        angle: _rotation.value,
        alignment: Alignment.bottomCenter,
        child: child,
      ),
      child: widget.child,
    );
  }
}
