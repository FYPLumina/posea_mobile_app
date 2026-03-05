import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posea_mobile_app/core/routing/route_names.dart';
import 'package:posea_mobile_app/l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F5F2),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.go(RouteNames.profile),
          ),
          title: Text(
            l10n.privacyPolicy,
            style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: _PrivacyPolicyContent(l10n: l10n),
        ),
      ),
    );
  }
}

class _PrivacyPolicyContent extends StatelessWidget {
  const _PrivacyPolicyContent({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    const headingStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Color(0xFF8B6F47),
    );
    const sectionTitleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.black87,
    );
    const bodyStyle = TextStyle(fontSize: 14, height: 1.5, color: Colors.black87);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.privacyPolicyHeading, style: headingStyle),
        const SizedBox(height: 8),
        Text(l10n.privacyPolicyLastUpdated, style: bodyStyle),
        const SizedBox(height: 20),

        Text(l10n.privacyPolicySection1Title, style: sectionTitleStyle),
        const SizedBox(height: 8),
        Text(l10n.privacyPolicySection1Body, style: bodyStyle),
        const SizedBox(height: 20),

        Text(l10n.privacyPolicySection2Title, style: sectionTitleStyle),
        const SizedBox(height: 8),
        Text(l10n.privacyPolicySection21Title, style: sectionTitleStyle),
        const SizedBox(height: 8),
        Text(l10n.privacyPolicySection21Body, style: bodyStyle),
        const SizedBox(height: 12),
        Text(l10n.privacyPolicySection22Title, style: sectionTitleStyle),
        const SizedBox(height: 8),
        Text(l10n.privacyPolicySection22Body, style: bodyStyle),
        const SizedBox(height: 12),
        Text(l10n.privacyPolicySection23Title, style: sectionTitleStyle),
        const SizedBox(height: 8),
        Text(l10n.privacyPolicySection23Body, style: bodyStyle),
        const SizedBox(height: 20),

        Text(l10n.privacyPolicySection3Title, style: sectionTitleStyle),
        const SizedBox(height: 8),
        Text(l10n.privacyPolicySection3Body, style: bodyStyle),
        const SizedBox(height: 20),

        Text(l10n.privacyPolicySection4Title, style: sectionTitleStyle),
        const SizedBox(height: 8),
        Text(l10n.privacyPolicySection4Body, style: bodyStyle),
        const SizedBox(height: 20),

        Text(l10n.privacyPolicySection5Title, style: sectionTitleStyle),
        const SizedBox(height: 8),
        Text(l10n.privacyPolicySection5Body, style: bodyStyle),
        const SizedBox(height: 20),

        Text(l10n.privacyPolicySection6Title, style: sectionTitleStyle),
        const SizedBox(height: 8),
        Text(l10n.privacyPolicySection6Body, style: bodyStyle),
        const SizedBox(height: 20),

        Text(l10n.privacyPolicySection7Title, style: sectionTitleStyle),
        const SizedBox(height: 8),
        Text(l10n.privacyPolicySection7Body, style: bodyStyle),
        const SizedBox(height: 20),

        Text(l10n.privacyPolicySection8Title, style: sectionTitleStyle),
        const SizedBox(height: 8),
        Text(l10n.privacyPolicySection8Body, style: bodyStyle),
        const SizedBox(height: 20),

        Text(l10n.privacyPolicySection9Title, style: sectionTitleStyle),
        const SizedBox(height: 8),
        Text(l10n.privacyPolicySection9Body, style: bodyStyle),
        const SizedBox(height: 20),

        Text(l10n.privacyPolicySection10Title, style: sectionTitleStyle),
        const SizedBox(height: 8),
        Text(l10n.privacyPolicySection10Body, style: bodyStyle),
        const SizedBox(height: 20),

        Text(l10n.privacyPolicySection11Title, style: sectionTitleStyle),
        const SizedBox(height: 8),
        Text(l10n.privacyPolicySection11Body, style: bodyStyle),
        const SizedBox(height: 24),
      ],
    );
  }
}
