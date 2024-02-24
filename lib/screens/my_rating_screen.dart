import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';

class MyRatingScreen extends StatefulWidget {
  const MyRatingScreen({Key? key}) : super(key: key);

  @override
  State<MyRatingScreen> createState() => _MyRatingScreenState();
}

class _MyRatingScreenState extends State<MyRatingScreen> {
  late Future<ApiResponse> futureData;
  static String apiUrl = '$baseApiUrl/partners/average_rating';

  @override
  void initState() {
    super.initState();
    futureData = GetClient.fetchData(apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Rating',
          ),
        ),
        body: GetRequestFutureBuilder<dynamic>(
            future: futureData,
            apiUrl: apiUrl,
            builder: (context, data) {
              return renderData(data);
            }));
  }

  SingleChildScrollView renderData(data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Rating:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                data['average_rating'].toString(),
                style: const TextStyle(fontSize: 30),
              )
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Introducing partner ratings:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const ListTile(
            leading: Icon(Icons.rate_review),
            title: Text(
                'Just like you rate the customers for the quality of service.'),
          ),
          const SizedBox(height: 10),
          const ListTile(
            leading: Icon(Icons.scale_outlined),
            title: Text('Customers rate you on a scale of 1 to 5.'),
          ),
          const SizedBox(height: 30),
          const Text(
            'Tips for Positive Ratings:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const ListTile(
            leading: Icon(Icons.people),
            title: Text('Communicate openly and courteously with customers.'),
          ),
          const ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Be supportive and empathetic towards customer needs.'),
          ),
          const SizedBox(height: 30),
          const Text(
            'General App Behavior:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const ListTile(
            leading: Icon(Icons.thumb_up),
            title: Text('Keep interactions civil and respectful.'),
          ),
          const ListTile(
            leading: Icon(Icons.warning),
            title: Text('Avoid harassment or abusive behavior.'),
          ),
          const SizedBox(height: 30),
          const Text(
            'How Rating is Calculated:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const ListTile(
            leading: Icon(Icons.calculate),
            title: Text(
                'Your rating is an average of all ratings received from your customers.'),
          ),
          const ListTile(
            leading: Icon(Icons.star),
            title: Text('Higher ratings indicate better behavior.'),
          ),
        ],
      ),
    );
  }
}
