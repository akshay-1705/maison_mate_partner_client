import 'package:flutter/material.dart';

class FilterOption extends StatefulWidget {
  final String label;
  final String filter;
  final String selectedFilter;
  final Function(String) onSelected;

  const FilterOption(
      this.label, this.filter, this.selectedFilter, this.onSelected,
      {super.key});

  @override
  State<FilterOption> createState() => _FilterOptionState();
}

class _FilterOptionState extends State<FilterOption> {
  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(widget.label),
      selected: widget.selectedFilter == widget.filter,
      onSelected: (selected) {
        if (selected) {
          widget.onSelected(widget.filter);
        }
      },
    );
  }
}

class FilterOptions extends StatefulWidget {
  const FilterOptions({super.key});

  @override
  State<FilterOptions> createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  String _selectedFilter = 'All';

  void onFilterSelected(String selectedFilter) {
    setState(() {
      _selectedFilter = selectedFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterOption('All', 'All', _selectedFilter, onFilterSelected),
          const SizedBox(width: 10),
          FilterOption('Active', 'Active', _selectedFilter, onFilterSelected),
          const SizedBox(width: 10),
          FilterOption(
              'Upcoming', 'Upcoming', _selectedFilter, onFilterSelected),
          const SizedBox(width: 10),
          FilterOption('Pending', 'Pending', _selectedFilter, onFilterSelected),
          const SizedBox(width: 10),
          FilterOption('Unpaid', 'Unpaid', _selectedFilter, onFilterSelected),
        ],
      ),
    );
  }
}
