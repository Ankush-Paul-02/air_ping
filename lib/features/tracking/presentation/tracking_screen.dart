import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/section_header.dart';
import '../../../models/flight_watch.dart';
import '../../../providers/watch_provider.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<WatchProvider>(
          builder: (context, provider, child) {
            final watches = provider.watches;
            final activeCount = provider.activeWatches.length;
            final pausedCount = watches.length - activeCount;

            return ListView(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 32),
              children: [
                // Header
                const Text(
                  'A I R P I N G',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.5,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Your tracking.',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.3,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'All your flight prices, in one place.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 28),

                // Statistics
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Active watches',
                        value: activeCount.toString(),
                        icon: Icons.radar_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'Paused watches',
                        value: pausedCount.toString(),
                        icon: CupertinoIcons.pause_circle,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                SectionHeader(
                  title: 'Your price watches',
                  subtitle: watches.isEmpty
                      ? 'Your tracked flights will appear here.'
                      : '${watches.length} flight '
                            '${watches.length == 1 ? 'watch' : 'watches'}',
                ),

                const SizedBox(height: 18),

                if (watches.isEmpty)
                  const _EmptyState()
                else
                  ...watches.map(
                    (watch) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _WatchCard(watch: watch),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// --------------------------------------------------
// STAT CARD
// --------------------------------------------------

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------
// WATCH CARD
// --------------------------------------------------

class _WatchCard extends StatelessWidget {
  final FlightWatch watch;

  const _WatchCard({required this.watch});

  String formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String formatPrice(double price) {
    return '₹${price.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final isActive = watch.isActive;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status and menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.successLight
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.success
                            : AppColors.textSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isActive ? 'Active' : 'Paused',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                icon: const Icon(
                  CupertinoIcons.ellipsis,
                  color: AppColors.textSecondary,
                ),
                onSelected: (value) {
                  if (value == 'pause') {
                    context.read<WatchProvider>().pauseWatch(watch.id);
                  } else if (value == 'delete') {
                    _confirmDelete(context);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'pause',
                    child: Row(
                      children: [
                        Icon(
                          isActive ? CupertinoIcons.pause : CupertinoIcons.play,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(isActive ? 'Pause watch' : 'Resume watch'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.trash,
                          color: AppColors.error,
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Delete watch',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Route
          Row(
            children: [
              Expanded(
                child: _AirportInfo(city: watch.origin, code: watch.originCode),
              ),

              Column(
                children: [
                  const Icon(
                    CupertinoIcons.airplane,
                    color: AppColors.primary,
                    size: 21,
                  ),
                  const SizedBox(height: 5),
                  Container(width: 65, height: 1, color: AppColors.border),
                ],
              ),

              Expanded(
                child: _AirportInfo(
                  city: watch.destination,
                  code: watch.destinationCode,
                  alignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Divider(color: AppColors.border, height: 1),

          const SizedBox(height: 17),

          // Travel dates
          Row(
            children: [
              const Icon(
                CupertinoIcons.calendar,
                color: AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${formatDate(watch.startDate)} – '
                  '${formatDate(watch.endDate)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Text(
                watch.tripType == 'ROUND_TRIP' ? 'Round trip' : 'One way',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Prices
          Row(
            children: [
              Expanded(
                child: _PriceInfo(
                  label: 'TARGET PRICE',
                  value: formatPrice(watch.targetPrice),
                ),
              ),
              Expanded(
                child: _PriceInfo(
                  label: 'CURRENT PRICE',
                  value: watch.currentPrice > 0
                      ? formatPrice(watch.currentPrice)
                      : 'Not checked',
                  isCurrent: true,
                ),
              ),
            ],
          ),

          if (watch.currentPrice > 0 &&
              watch.currentPrice <= watch.targetPrice) ...[
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    CupertinoIcons.arrow_down_right,
                    size: 16,
                    color: AppColors.success,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Current fare is at or below your target!',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete price watch?'),
          content: const Text('This flight watch will be permanently removed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'Delete',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && context.mounted) {
      context.read<WatchProvider>().deleteWatch(watch.id);
    }
  }
}

// --------------------------------------------------
// AIRPORT INFO
// --------------------------------------------------

class _AirportInfo extends StatelessWidget {
  final String city;
  final String code;
  final CrossAxisAlignment alignment;

  const _AirportInfo({
    required this.city,
    required this.code,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          code,
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          city,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// --------------------------------------------------
// PRICE INFO
// --------------------------------------------------

class _PriceInfo extends StatelessWidget {
  final String label;
  final String value;
  final bool isCurrent;

  const _PriceInfo({
    required this.label,
    required this.value,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          value,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: isCurrent && value != 'Not checked'
                ? AppColors.primary
                : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// --------------------------------------------------
// EMPTY STATE
// --------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 38),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.airplane,
              color: AppColors.primary,
              size: 28,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'No price watches yet',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Create your first flight watch and let AirPing '
            'keep an eye on ticket prices.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 20),

          FilledButton(
            onPressed: () {
              // Navigate through your app router from the parent.
              // This screen can be opened using /create-watch.
            },
            child: const Text('Start exploring'),
          ),
        ],
      ),
    );
  }
}
