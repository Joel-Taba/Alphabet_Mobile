import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';

class CommunauteScreen extends StatelessWidget {
  const CommunauteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;

    // Hardcoded mock data from web version
    final profiles = [
      {'id': '1', 'prenom': 'Sami', 'animal': 'hibou', 'score': 240, 'moi': false},
      {'id': '2', 'prenom': 'Mia', 'animal': 'herisson', 'score': 190, 'moi': false},
      {'id': '3', 'prenom': 'Lila', 'animal': 'renard', 'score': 150, 'moi': true},
      {'id': '4', 'prenom': 'Noé', 'animal': 'ecureuil', 'score': 110, 'moi': false},
      {'id': '5', 'prenom': 'Tao', 'animal': 'biche', 'score': 80, 'moi': false},
      {'id': '6', 'prenom': 'Ava', 'animal': 'panda', 'score': 45, 'moi': false},
    ];

    return Scaffold(
      backgroundColor: AmaniColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Text('🌟', style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t['community']?['title'] ?? 'La Clairière',
                          style: AmaniTheme.titleStyle.copyWith(fontSize: 24),
                        ),
                        Text(
                          t['community']?['subtitle'] ?? 'Classement local',
                          style: AmaniTheme.bodyStyle.copyWith(color: AmaniColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            // Podium
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildPodiumSpot(profiles[1], 2, 110),
                const SizedBox(width: 12),
                _buildPodiumSpot(profiles[0], 1, 140),
                const SizedBox(width: 12),
                _buildPodiumSpot(profiles[2], 3, 90),
              ],
            ),

            const SizedBox(height: 32),

            // List
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                  itemCount: profiles.length - 3,
                  itemBuilder: (context, index) {
                    final profile = profiles[index + 3];
                    final isMoi = profile['moi'] as bool;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isMoi ? AmaniColors.primary.withValues(alpha: 0.1) : AmaniColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: isMoi ? Border.all(color: AmaniColors.primary, width: 2) : null,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${index + 4}',
                            style: AmaniTheme.titleStyle.copyWith(
                              fontSize: 18, 
                              color: AmaniColors.textSecondary
                            ),
                          ),
                          const SizedBox(width: 16),
                          _buildAvatar(profile['animal'] as String, 40),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              profile['prenom'] as String,
                              style: AmaniTheme.titleStyle.copyWith(fontSize: 18),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${profile['score']}',
                                style: AmaniTheme.titleStyle.copyWith(
                                  fontSize: 18,
                                  color: AmaniColors.primaryDark,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.star_rounded, color: AmaniColors.warning, size: 20),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodiumSpot(Map<String, dynamic> profile, int rank, double height) {
    Color rankColor;
    if (rank == 1) {
      rankColor = AmaniColors.warning;
    } else if (rank == 2) rankColor = AmaniColors.disabled;
    else rankColor = AmaniColors.signCourbe;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildAvatar(profile['animal'] as String, 64, rank: rank),
        const SizedBox(height: 12),
        Container(
          width: 90,
          height: height,
          decoration: BoxDecoration(
            color: AmaniColors.primary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            border: Border.all(color: AmaniColors.primaryDark, width: 3),
            boxShadow: const [BoxShadow(color: Color(0x2E000000), offset: Offset(0, 4))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                profile['prenom'] as String,
                style: AmaniTheme.titleStyle.copyWith(fontSize: 16, color: AmaniColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: rankColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: AmaniColors.primaryDark, width: 2),
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: AmaniTheme.titleStyle.copyWith(fontSize: 16, color: AmaniColors.primaryDark),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String animal, double size, {int? rank}) {
    String emoji = '🦉';
    switch (animal) {
      case 'renard': emoji = '🦊'; break;
      case 'hibou': emoji = '🦉'; break;
      case 'ecureuil': emoji = '🐿️'; break;
      case 'herisson': emoji = '🦔'; break;
      case 'panda': emoji = '🐼'; break;
      case 'biche': emoji = '🦌'; break;
    }

    Color borderColor = AmaniColors.primaryDark;
    if (rank == 1) {
      borderColor = AmaniColors.warning;
    } else if (rank == 2) borderColor = AmaniColors.disabled;
    else if (rank == 3) borderColor = AmaniColors.signCourbe;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: rank != null ? 4 : 2),
        boxShadow: const [BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4)],
      ),
      child: Center(
        child: Text(emoji, style: TextStyle(fontSize: size * 0.5)),
      ),
    );
  }
}
