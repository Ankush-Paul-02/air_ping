import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/section_header.dart';
import '../../../models/airport.dart';
import '../../../providers/airport_provider.dart';
import '../../../providers/watch_provider.dart';

class CreateWatchScreen extends StatefulWidget {
  const CreateWatchScreen({super.key});

  @override
  State<CreateWatchScreen> createState() => _CreateWatchScreenState();
}

class _CreateWatchScreenState extends State<CreateWatchScreen> {
  final budgetController = TextEditingController();

  Airport? origin;
  Airport? destination;

  DateTimeRange? travelRange;
  String tripType = 'ONE_WAY';

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();

    // Default origin airport.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        origin = context.read<AirportProvider>().findByCode('CCU');
      });
    });
  }

  @override
  void dispose() {
    budgetController.dispose();
    super.dispose();
  }

  // --------------------------------------------------
  // AIRPORT SELECTION
  // --------------------------------------------------

  Future<void> selectAirport({required bool isOrigin}) async {
    final provider = context.read<AirportProvider>();
    provider.clearSearch();

    final selectedAirport = await showModalBottomSheet<Airport>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return _AirportSearchSheet(provider: provider);
      },
    );

    provider.clearSearch();

    if (selectedAirport == null || !mounted) return;

    setState(() {
      if (isOrigin) {
        origin = selectedAirport;

        if (destination?.code == selectedAirport.code) {
          destination = null;
        }
      } else {
        destination = selectedAirport;
      }
    });
  }

  // --------------------------------------------------
  // DATE SELECTION
  // --------------------------------------------------

  Future<void> selectDates() async {
    final now = DateTime.now();

    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: travelRange,
      helpText: 'Select your travel window',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (result != null && mounted) {
      setState(() => travelRange = result);
    }
  }

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

  // --------------------------------------------------
  // CREATE WATCH
  // --------------------------------------------------

  void createWatch() {
    if (origin == null ||
        destination == null ||
        travelRange == null ||
        budgetController.text.trim().isEmpty) {
      showMessage('Please complete all required fields.');
      return;
    }

    if (origin!.code == destination!.code) {
      showMessage('Origin and destination must be different.');
      return;
    }

    final budget = double.tryParse(budgetController.text.trim());

    if (budget == null || budget <= 0) {
      showMessage('Please enter a valid target price.');
      return;
    }

    setState(() => isSubmitting = true);

    try {
      context.read<WatchProvider>().createWatch(
        origin: origin!.city,
        destination: destination!.city,
        originCode: origin!.code,
        destinationCode: destination!.code,
        startDate: travelRange!.start,
        endDate: travelRange!.end,
        targetPrice: budget,
        tripType: tripType,
      );

      context.pop();
    } catch (e) {
      setState(() => isSubmitting = false);
      showMessage('Unable to create price watch.');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  // --------------------------------------------------
  // UI
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(CupertinoIcons.back),
        ),
        title: const Text(
          'New price watch',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          children: [
            // Hero
            const Text(
              'Where are you\ngoing?',
              style: TextStyle(
                fontSize: 34,
                height: 1.12,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.5,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Choose your route and travel window. "
              "We'll keep an eye on the prices.",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 32),

            // Route
            const SectionHeader(
              title: 'Your route',
              subtitle: 'Where would you like to fly?',
            ),

            const SizedBox(height: 16),

            _AirportSelector(
              label: 'FROM',
              airport: origin,
              placeholder: 'Select departure airport',
              onTap: () => selectAirport(isOrigin: true),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  const Spacer(),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.arrow_swap,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            _AirportSelector(
              label: 'TO',
              airport: destination,
              placeholder: 'Select destination airport',
              onTap: () => selectAirport(isOrigin: false),
            ),

            const SizedBox(height: 32),

            // Trip type
            const SectionHeader(
              title: 'Trip type',
              subtitle: 'Choose your journey type.',
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: _TripTypeCard(
                    title: 'One way',
                    subtitle: 'Single journey',
                    icon: CupertinoIcons.airplane,
                    selected: tripType == 'ONE_WAY',
                    onTap: () {
                      setState(() => tripType = 'ONE_WAY');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TripTypeCard(
                    title: 'Round trip',
                    subtitle: 'Return journey',
                    icon: CupertinoIcons.arrow_left_right,
                    selected: tripType == 'ROUND_TRIP',
                    onTap: () {
                      setState(() => tripType = 'ROUND_TRIP');
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Dates
            const SectionHeader(
              title: 'Travel dates',
              subtitle: 'Keep your dates flexible to find better fares.',
            ),

            const SizedBox(height: 15),

            InkWell(
              onTap: selectDates,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 43,
                      height: 43,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        CupertinoIcons.calendar,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            travelRange == null
                                ? 'Select travel window'
                                : '${formatDate(travelRange!.start)} – '
                                      '${formatDate(travelRange!.end)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Departure date range',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      CupertinoIcons.chevron_right,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Budget
            const SectionHeader(
              title: 'Target price',
              subtitle: 'Get notified when fares reach your budget.',
            ),

            const SizedBox(height: 15),

            TextField(
              controller: budgetController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                prefixText: '₹ ',
                prefixStyle: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                hintText: 'Enter maximum price',
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.all(18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.3,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Monitoring information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    CupertinoIcons.bell_fill,
                    color: AppColors.primary,
                    size: 21,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Automatic price monitoring',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'We check prices daily and notify you '
                          'when fares drop or reach your target.',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: isSubmitting ? null : createWatch,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withValues(
                    alpha: 0.5,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        height: 21,
                        width: 21,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Start tracking prices',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 9),
                          Icon(CupertinoIcons.arrow_right, size: 17),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 14),

            const Text(
              'No booking required. Just smart price tracking.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================
// AIRPORT SELECTOR
// ==================================================

class _AirportSelector extends StatelessWidget {
  final String label;
  final Airport? airport;
  final String placeholder;
  final VoidCallback onTap;

  const _AirportSelector({
    required this.label,
    required this.airport,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                label == 'FROM'
                    ? CupertinoIcons.airplane
                    : CupertinoIcons.location,
                color: AppColors.primary,
                size: 19,
              ),
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
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    airport?.city ?? placeholder,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: airport == null
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (airport != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      '${airport!.code} · ${airport!.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================
// AIRPORT SEARCH BOTTOM SHEET
// ==================================================

class _AirportSearchSheet extends StatefulWidget {
  final AirportProvider provider;

  const _AirportSearchSheet({required this.provider});

  @override
  State<_AirportSearchSheet> createState() => _AirportSearchSheetState();
}

class _AirportSearchSheetState extends State<_AirportSearchSheet> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.72,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Choose airport',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Search by city, airport name or code.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: searchController,
                autofocus: true,
                onChanged: widget.provider.searchAirports,
                decoration: InputDecoration(
                  hintText: 'Search airports...',
                  prefixIcon: const Icon(
                    CupertinoIcons.search,
                    color: AppColors.textSecondary,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchController.clear();
                      widget.provider.clearSearch();
                    },
                    icon: const Icon(CupertinoIcons.xmark_circle),
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Expanded(
                child: Consumer<AirportProvider>(
                  builder: (context, provider, child) {
                    final airports = provider.filteredAirports;

                    if (airports.isEmpty) {
                      return const Center(
                        child: Text(
                          'No airports found.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: airports.length,
                      separatorBuilder: (_, __) =>
                          const Divider(color: AppColors.border, height: 1),
                      itemBuilder: (context, index) {
                        final airport = airports[index];

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 5,
                          ),
                          leading: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              CupertinoIcons.airplane,
                              color: AppColors.primary,
                              size: 19,
                            ),
                          ),
                          title: Text(
                            airport.city,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            airport.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          trailing: Text(
                            airport.code,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context, airport);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================================================
// TRIP TYPE CARD
// ==================================================

class _TripTypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TripTypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(17),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.3 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 21,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: selected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
