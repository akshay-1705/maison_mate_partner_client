import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/provider/my_jobs_model.dart';

class FilterOptions extends StatefulWidget {
  final Map<String, dynamic> data;
  final MyJobsModel model;
  const FilterOptions({Key? key, required this.data, required this.model})
      : super(key: key);

  @override
  State<FilterOptions> createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  late int _selectedFilter;

  void onFilterSelected(int selectedFilter, String label) {
    widget.model.setActiveFilter(selectedFilter);
    String dataApiUrl = '$baseApiUrl/partners/my_jobs?filter=$label';
    widget.model.setDataFutureData(GetClient.fetchData(dataApiUrl));
  }

  @override
  Widget build(BuildContext context) {
    _selectedFilter = widget.model.activeFilter;
    List<Widget> filterOptionWidgets = [];

    widget.data.forEach((label, filter) {
      filterOptionWidgets.add(
        FilterOption(
          label,
          filter,
          _selectedFilter,
          onFilterSelected,
        ),
      );
      filterOptionWidgets.add(const SizedBox(width: 10));
    });
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filterOptionWidgets,
      ),
    );
  }
}

class FilterOption extends StatefulWidget {
  final String label;
  final int filter;
  final int selectedFilter;
  final Function(int, String) onSelected;

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
          widget.onSelected(widget.filter, widget.label);
        }
      },
    );
  }
}
