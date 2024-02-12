import 'package:flutter/material.dart';
import 'package:maison_mate/network/response/job_item_response.dart';
import 'package:maison_mate/network/response/my_jobs_response.dart';
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
  void onFilterSelected(int selectedFilter, String label) {
    widget.model.setActiveFilter(selectedFilter);
    if (selectedFilter == -1) {
      widget.model.filteredMyJobsList = widget.model.myJobsList;
    } else {
      List<JobItemResponse> filteredList = widget.model.myJobsList.myJobs
          .where((job) => job.statusToSearch == selectedFilter)
          .toList();

      widget.model.setFilteredMyJobsList(MyJobsResponse(filteredList));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> filterOptionWidgets = [];

    widget.data.forEach((label, filter) {
      filterOptionWidgets.add(
        FilterOption(
          label,
          filter,
          widget.model.activeFilter,
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
      label: Text(widget.label, style: const TextStyle(fontSize: 14)),
      selected: widget.selectedFilter == widget.filter,
      onSelected: (selected) {
        if (selected) {
          widget.onSelected(widget.filter, widget.label);
        }
      },
    );
  }
}
