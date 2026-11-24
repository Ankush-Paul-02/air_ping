import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/section_header.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'A I R P I N G',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        'Good evening.',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.8,
                            ),
                      ),
                    ],
                  ),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.person,
                      color: AppColors.primary,
                      size: 21,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 38),

              // Hero
              const Text(
                'Fly for less.',
                style: TextStyle(
                  fontSize: 38,
                  height: 1.08,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.9,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Your next journey starts at the right price. '
                'Track fares automatically and never miss a deal.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 30),

              // Search Card
              _SearchCard(
                onCreateWatch: () {
                  context.push('/create-watch');
                },
              ),

              const SizedBox(height: 38),

              // Popular Routes Header
              SectionHeader(
                title: 'Popular routes',
                subtitle: 'Routes worth keeping an eye on.',
                actionLabel: 'Explore all',
                onActionTap: () {
                  // TODO: Navigate to all popular routes.
                },
              ),

              const SizedBox(height: 18),

              const _PopularRoute(
                origin: 'Kolkata',
                destination: 'Bengaluru',
                originCode: 'CCU',
                destinationCode: 'BLR',
              ),

              const _PopularRoute(
                origin: 'Delhi',
                destination: 'Mumbai',
                originCode: 'DEL',
                destinationCode: 'BOM',
              ),

              const _PopularRoute(
                origin: 'Bengaluru',
                destination: 'Hyderabad',
                originCode: 'BLR',
                destinationCode: 'HYD',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// SEARCH CARD
// --------------------------------------------------

class _SearchCard extends StatelessWidget {
  final VoidCallback onCreateWatch;

  const _SearchCard({required this.onCreateWatch});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  CupertinoIcons.airplane,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create a price watch',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'We will track fares for you',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const _AirportTile(label: 'FROM', city: 'Kolkata', code: 'CCU'),

          const SizedBox(height: 10),

          const _AirportTile(
            label: 'TO',
            city: 'Where to?',
            code: 'Choose destination',
            isPlaceholder: true,
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: onCreateWatch,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create price watch',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 9),
                  Icon(CupertinoIcons.arrow_right, size: 17),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------
// AIRPORT TILE
// --------------------------------------------------

class _AirportTile extends StatelessWidget {
  final String label;
  final String city;
  final String code;
  final bool isPlaceholder;

  const _AirportTile({
    required this.label,
    required this.city,
    required this.code,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            label == 'TO'
                ? CupertinoIcons.location
                : CupertinoIcons.location_north_line,
            color: AppColors.textSecondary,
            size: 19,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.2,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  city,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isPlaceholder
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Text(
              code,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------
// POPULAR ROUTE
// --------------------------------------------------

class _PopularRoute extends StatelessWidget {
  final String origin;
  final String destination;
  final String originCode;
  final String destinationCode;

  const _PopularRoute({
    required this.origin,
    required this.destination,
    required this.originCode,
    required this.destinationCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              CupertinoIcons.airplane,
              size: 19,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$origin → $destination',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$originCode  →  $destinationCode',
                  style: const TextStyle(
                    fontSize: 11,
                    letterSpacing: 0.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            CupertinoIcons.chevron_right,
            size: 15,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
