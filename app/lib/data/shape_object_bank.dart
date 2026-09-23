// ignore_for_file: constant_identifier_names

/// Banque d'objets du quotidien associés à chaque figure géométrique du
/// Palier "Les Figures géométriques", pour le mini-jeu "Quel objet a cette
/// forme ?" (`exercice_figure_objet_screen.dart`). Chaque figure dispose de
/// plusieurs dizaines d'objets possibles -- un objet différent est piqué au
/// hasard à chaque tour ET à chaque relance (voir `_ObjetCard.build`),
/// plutôt qu'un unique objet fixe par figure, pour renouveler le jeu.
///
/// Rendu directement en emoji (voir `_EmojiObjectIcon` dans l'écran) --
/// aucun asset à empaqueter, et un rendu couleur déjà riche via les polices
/// emoji système (Noto Color Emoji sur Android). Chaque liste est disjointe
/// des trois autres : un même objet n'apparaît jamais sous deux figures
/// différentes, pour ne jamais induire l'enfant en erreur sur la forme
/// réellement associée.
const Map<String, List<String>> SHAPE_OBJECT_BANK = {
  'cercle': [
    '⚽', '🏀', '🎾', '🏐', '🍩', '🍪', '🍊', '🌕', '🎯', '⏰',
    '🪙', '🎡', '🛞', '🍳', '🥁', '🍭', '🧁', '🎱', '🥥', '🛟',
    '🔘', '🍮', '🥮', '🍘', '🍎', '🍅', '🧅', '🍈', '🍑', '🧿',
  ],
  'carre': [
    '🪟', '🎲', '🧇', '🍫', '🖼️', '🧊', '⬛', '⬜', '🔲', '🔳',
    '🟥', '🟦', '🟩', '🟨', '🟧', '🟪', '🟫', '💾', '📦', '🗄️',
    '🎛️', '📻', '🖲️', '🧮', '🗃️',
  ],
  'rectangle': [
    '🚪', '📱', '💳', '📕', '📗', '📘', '💻', '📺', '🖥️', '✉️',
    '🎫', '🪪', '📇', '🧱', '🚌', '🛏️', '🚦', '🪞', '🗞️', '🎹',
    '📓', '💵', '🧾', '🔖', '📒',
  ],
  'triangle': [
    '🍕', '⛰️', '🗻', '🚩', '🍦', '🔺', '🔻', '⚠️', '🧀', '🍰',
    '🥪', '⛱️', '🎪', '📐', '🥟', '🍧', '🥙', '🚸', '🏔️', '🎏',
  ],
  'parallelogramme': [
    '▱', '▰', '🛝', '🪗', '🛹', '🪜', '🎢', '🎚️', '🔀', '📖',
  ],
  'losange': [
    '🔷', '🔶', '💎', '◆', '◇', '🪁', '♦️', '🍬', '🔸', '🔹',
  ],
};
