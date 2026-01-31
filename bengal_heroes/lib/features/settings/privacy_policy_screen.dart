import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('settings.privacy.title'.tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, 'settings.privacy.title'.tr()),
            const SizedBox(height: 24),
            
            _buildSection(
              context,
              'settings.privacy.introduction'.tr(),
              'settings.privacy.introduction_desc'.tr(),
            ),
            
            _buildSection(
              context,
              'settings.privacy.data_collection'.tr(),
              'settings.privacy.data_collection_desc'.tr(),
            ),
            
            _buildSection(
              context,
              'settings.privacy.accuracy'.tr(),
              'settings.privacy.accuracy_desc'.tr(),
            ),
            
            _buildSection(
              context,
              'settings.privacy.contributions'.tr(),
              'settings.privacy.contributions_desc'.tr(),
            ),
            
            _buildSection(
              context,
              'settings.privacy.contact'.tr(),
              'settings.privacy.contact_desc'.tr(),
            ),
            
            const SizedBox(height: 40),
            Center(
              child: Text(
                'settings.made_with_love'.tr(),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.privacy_tip_outlined,
              size: 48,
              color: AppColors.primaryMaroon,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryMaroon,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String description) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryMaroon,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
