import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';

class TermsOfServiceScreen extends StatefulWidget {
  const TermsOfServiceScreen({super.key});

  @override
  State<TermsOfServiceScreen> createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> with TickerProviderStateMixin {
  late AnimationController _fabController;
  final List<bool> _expandedSections = List.filled(7, false);

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _toggleSection(int index) {
    setState(() {
      _expandedSections[index] = !_expandedSections[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Term of Service'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context)
                    .animate()
                    .fadeIn(duration: const Duration(milliseconds: 600))
                    .slideY(begin: 0.3, end: 0, duration: const Duration(milliseconds: 600)),
                const SizedBox(height: 32),
                _buildIntroductionCard(context, theme)
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 200), duration: const Duration(milliseconds: 600))
                    .slideY(begin: 0.3, end: 0, duration: const Duration(milliseconds: 600)),
                const SizedBox(height: 24),
                ..._buildExpandableSections(context, theme),
                const SizedBox(height: 40),
                _buildFooterText(context, theme)
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 600), duration: const Duration(milliseconds: 600)),
              ],
            ),
          ),
          _buildAcceptanceButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryMaroon.withValues(alpha: 0.15),
                  AppColors.primaryGold.withValues(alpha: 0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.description_outlined,
              size: 56,
              color: AppColors.primaryMaroon,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Term of Service',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryMaroon,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Last updated: February 2026',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroductionCard(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryGold.withValues(alpha: 0.08),
        border: Border.all(
          color: AppColors.primaryGold.withValues(alpha: 0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.info_outline,
              color: AppColors.primaryMaroon,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important Information',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryMaroon,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Please read these terms carefully before using our application. By accessing and using this app, you accept and agree to be bound by these terms.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    height: 1.4,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExpandableSections(BuildContext context, ThemeData theme) {
    final sections = [
      {
        'title': 'Bengal Heroes Content',
        'content':
            'Our app features a curated collection of historical figures from Bengal, showcasing their lives, achievements, and contributions to society. We strive to provide accurate and engaging content to educate and inspire our users.',
      },
      {
        'title': 'Data Validity',
        'content':
            'While we make every effort to ensure the accuracy of the information presented, historical data can sometimes be subject to interpretation and may contain discrepancies. We encourage users to cross-reference information with reputable sources.',
      },
      {
        'title': 'Wrong Information',
        'content':
            'If you come across any information that you believe is incorrect or misleading, please contact us at contact@bengalbytes.com'
            
      },
      {
        'title': 'Photos and Media',
        'content':
            'All photos and media used in the app are sourced from public domain or licensed under Creative Commons. We credit original creators where applicable. If you are a rights holder and believe your work has been used without proper attribution, please reach out to us.',
      }
     
    ];

    return List.generate(
      sections.length,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildExpandableSection(
          context,
          theme,
          index,
          sections[index]['title']!,
          sections[index]['content']!,
        )
            .animate()
            .fadeIn(
              delay: Duration(milliseconds: 300 + (index * 50)),
              duration: const Duration(milliseconds: 500),
            )
            .slideY(
              begin: 0.2,
              end: 0,
              delay: Duration(milliseconds: 300 + (index * 50)),
              duration: const Duration(milliseconds: 500),
            ),
      ),
    );
  }

  Widget _buildExpandableSection(
    BuildContext context,
    ThemeData theme,
    int index,
    String title,
    String content,
  ) {
    final isExpanded = _expandedSections[index];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isExpanded
              ? AppColors.primaryMaroon.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isExpanded
            ? AppColors.primaryMaroon.withValues(alpha: 0.05)
            : theme.colorScheme.surface,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleSection(index),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryMaroon,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.expand_more,
                        color: AppColors.primaryMaroon,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterText(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        Divider(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          height: 32,
        ),
        Center(
          child: Text(
            'settings.made_with_love'.tr(),
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildAcceptanceButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        padding: EdgeInsets.fromLTRB(
          20,
          40,
          20,
          MediaQuery.of(context).padding.bottom + 16,
        ),
        child: Row(
          children: [

            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Terms accepted successfully!'),
                      backgroundColor: Colors.green.shade600,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                    color: AppColors.primaryMaroon.withValues(alpha: 0.8),
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                
                child: Text(
                  'Accept',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}