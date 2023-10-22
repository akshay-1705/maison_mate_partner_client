import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';

class MyJobsWidget extends StatefulWidget {
  const MyJobsWidget({Key? key}) : super(key: key);

  @override
  State<MyJobsWidget> createState() => _MyJobsWidgetState();
}

class _MyJobsWidgetState extends State<MyJobsWidget> {
  late Future<ApiResponse> futureData;
  static const String apiUrl = '$baseApiUrl/partners/payments_summary';

  @override
  void initState() {
    super.initState();
    futureData = GetClient.fetchData(apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    return GetRequestFutureBuilder<dynamic>(
        future: futureData,
        apiUrl: apiUrl,
        builder: (context, data) {
          return renderData(data);
        });
  }

  SingleChildScrollView renderData(data) {
    return const SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 5),
                FilterOptions(),
                SizedBox(height: 10),
                MyJobsList(),
              ],
            )));
  }
}

class FilterOptions extends StatefulWidget {
  const FilterOptions({super.key});

  @override
  State<FilterOptions> createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Allow horizontal scrolling
      child: Row(
        children: [
          FilterOption('Active', 'Active'),
          SizedBox(width: 10),
          FilterOption('Upcoming', 'Upcoming'),
          SizedBox(width: 10),
          FilterOption('Pending', 'Pending'),
          SizedBox(width: 10),
          FilterOption('Unpaid', 'Unpaid'),
        ],
      ),
    );
  }
}

class FilterOption extends StatelessWidget {
  final String _selectedFilter = 'Active';
  final String label;
  final String filter;

  const FilterOption(this.label, this.filter, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedFilter == filter,
      // selectedColor: Colors.green,
      onSelected: (selected) {
        if (selected) {
          // setState(() {
          //   _selectedFilter = filter;
          // });
        }
      },
    );
  }
}

class MyJobsList extends StatelessWidget {
  const MyJobsList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> partnerJobs = [
      {
        'title': 'Plumbing',
        'status': 'Upcoming',
        'date': 'Oct 20, 2023',
        'payment': Colors.green,
      },
      {
        'title': 'Painting',
        'status': 'Pending',
        'date': 'Oct 22, 2023',
        'payment': Colors.red
      },
      {
        'title': 'Plumbing',
        'status': 'Upcoming',
        'date': 'Oct 20, 2023',
        'payment': Colors.red
      },
      {
        'title': 'Painting',
        'status': 'Pending',
        'date': 'Oct 22, 2023',
        'payment': Colors.green
      },
      {
        'title': 'Plumbing',
        'status': 'Upcoming',
        'date': 'Oct 20, 2023',
        'payment': Colors.green,
      },
      {
        'title': 'Painting',
        'status': 'Pending',
        'date': 'Oct 22, 2023',
        'payment': Colors.red
      },
      {
        'title': 'Plumbing',
        'status': 'Upcoming',
        'date': 'Oct 20, 2023',
        'payment': Colors.red
      },
      {
        'title': 'Painting',
        'status': 'Pending',
        'date': 'Oct 22, 2023',
        'payment': Colors.green
      },
    ];

    return Column(
      children: partnerJobs.map((job) {
        return Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: Card(
              elevation: 0,
              color: const Color(secondaryColor),
              child: ListTile(
                leading: Icon(
                  Icons.currency_pound,
                  color: job['payment'],
                ),
                title: Text(job['title']),
                subtitle: Text(job['status']),
                trailing: Text('Job date: ${job['date']}'),
              ),
            ));
      }).toList(),
    );
  }
}
