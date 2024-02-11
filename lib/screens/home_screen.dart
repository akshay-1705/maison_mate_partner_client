import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/on_duty_model.dart';
import 'package:maison_mate/services/on_duty_service.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:maison_mate/widgets/account_widget.dart';
import 'package:maison_mate/widgets/dashboard_widget.dart';
import 'package:maison_mate/widgets/find_jobs.dart';
import 'package:maison_mate/widgets/refer_and_earn.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final int? index;
  const HomeScreen({super.key, this.index});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentIndex = 0;
  final List<Widget> pages = [
    const DashboardWidget(),
    const FindJobsWidget(),
    const ReferAndEarn(),
    const AccountWidget(),
  ];
  late Future<ApiResponse> futureData;
  static String onDutyApiUrl = '$baseApiUrl/partners/on_duty';

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index ?? 0;
    futureData = GetClient.fetchData(onDutyApiUrl);
    futureData.then((value) {
      var stateModel = Provider.of<OnDutyModel>(context, listen: false);
      setState(() {
        stateModel.setOnDuty(value.data['on_duty']);
        stateModel.setOffDutyAllowed(value.data['off_duty_allowed']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final OnDutyModel model = Provider.of<OnDutyModel>(context);
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: header(context, model),
          body: WillPopScope(
              onWillPop: () async {
                return Future.value(false);
              },
              child: SingleChildScrollView(child: pages[currentIndex])),
          bottomNavigationBar: bottomNavigation(),
        ));
  }

  Widget bottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Find Jobs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.currency_pound),
          label: 'Refer & Earn',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
      ],
      selectedItemColor: const Color(themeColor),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
    );
  }

  PreferredSize header(BuildContext context, OnDutyModel model) {
    if (currentIndex == 1) {
      return onOffDuty(model);
    } else {
      return logo();
    }
  }

  PreferredSize onOffDuty(OnDutyModel model) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: const Color(themeColor),
          actions: [
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(
                      right: 16.0, left: 16.0, bottom: 10.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.beach_access,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8.0),
                      Switch(
                        value: model.onDuty,
                        onChanged: (value) {
                          String confirmationMessage;
                          if (value) {
                            confirmationMessage =
                                'Do you want to enable work mode?';
                          } else {
                            confirmationMessage =
                                'Do you want to enable vacation mode?';
                          }
                          Future<bool> confirm =
                              CustomAppBar.showConfirmationDialog(
                                  context, confirmationMessage);
                          confirm.then((confirmed) async {
                            if (confirmed) {
                              if (!value && !model.offDutyAllowed) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    MySnackBar(
                                            message:
                                                'Please complete all jobs before enabling vacation mode',
                                            error: true)
                                        .getSnackbar());
                              } else {
                                var response = OnDutyService.toggle(value);
                                response.then((status) {
                                  if (status) {
                                    setState(() {
                                      model.setOnDuty(value);
                                    });
                                  }
                                });
                              }
                            }
                          });
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.red,
                      ),
                      const SizedBox(width: 8.0),
                      const Icon(
                        Icons.work,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  PreferredSize logo() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50.0),
      child: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Container(
          margin: const EdgeInsets.only(bottom: 10),
          width: 100,
          height: 100,
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
