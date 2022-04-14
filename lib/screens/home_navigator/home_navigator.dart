import 'package:cardkarobar/screens/history/history_view.dart';
import 'package:cardkarobar/screens/lead_update/lead_update.dart';
import 'package:flutter/material.dart';

import '../../helper/constant.dart';
import '../dashboard/dasboard_view.dart';
import '../partner/partner.dart';
import '../payment/payment.dart';
import '../upload_status/upload_status.dart';
import '../user_details/user.dart';

class HomeNavigator extends StatefulWidget {
  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  int _selectedIndex = 0;

  Widget callPage(int currentIdex) {
    switch (currentIdex) {
      case 0:
        return DashBoardView();
      case 1:
        return HistoryView();
      case 2:
        return UserView();
      case 3:
        return PartnerView();
      case 4:
        return LeadUpdate();
      case 5:
        return LeadExcel();
      case 6:
        return PaymentView();

        break;
      default:
        return DashBoardView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackGroundColor,
      body: Row(
        children: <Widget>[
          Column(
            children: [
             const Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 25, top: 25),
                  child: Text(
                    "DashBoard",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )),
              Expanded(
                child: NavigationRail(
                  backgroundColor: appBackGroundColor,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.selected,
                  destinations: <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: const Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      selectedIcon:const Icon(
                        Icons.home,
                        color: mainColor,
                      ),
                      label: Text(
                        'Home',
                        style: TextStyle(
                            color:
                                _selectedIndex == 0 ? mainColor : Colors.white),
                      ),
                    ),
                    NavigationRailDestination(
                      icon:const Icon(
                        Icons.assignment,
                        color: Colors.white,
                      ),
                      selectedIcon: const Icon(
                        Icons.assignment,
                        color: mainColor,
                      ),
                      label: Text(
                        'History',
                        style: TextStyle(
                            color:
                                _selectedIndex == 1 ? mainColor : Colors.white),
                      ),
                    ),
                    NavigationRailDestination(
                      icon:const Icon(
                        Icons.account_circle,
                        color: Colors.white,
                      ),
                      selectedIcon: const Icon(
                        Icons.account_circle,
                        color: mainColor,
                      ),
                      label: Text(
                        'Users',
                        style: TextStyle(
                            color:
                                _selectedIndex == 2 ? mainColor : Colors.white),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(
                        Icons.add_box_rounded,
                        color: Colors.white,
                      ),
                      selectedIcon: const Icon(
                        Icons.add_box_rounded,
                        color: mainColor,
                      ),
                      label: Text(
                        'Product',
                        style: TextStyle(
                            color:
                                _selectedIndex == 2 ? mainColor : Colors.white),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(
                        Icons.signal_wifi_statusbar_4_bar,
                        color: Colors.white,
                      ),
                      selectedIcon: const Icon(
                        Icons.signal_wifi_statusbar_4_bar,
                        color: mainColor,
                      ),
                      label: Text(
                        'Lead Update',
                        style: TextStyle(
                            color:
                                _selectedIndex == 2 ? mainColor : Colors.white),
                      ),
                    ),

                    NavigationRailDestination(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      selectedIcon: const Icon(
                        Icons.add_comment_outlined,
                        color: mainColor,
                      ),
                      label: Text(
                        'Excel',
                        style: TextStyle(
                            color:
                            _selectedIndex == 5 ? mainColor : Colors.white),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(
                        Icons.payments,
                        color: Colors.white,
                      ),
                      selectedIcon: const Icon(
                        Icons.payments,
                        color: mainColor,
                      ),
                      label: Text(
                        'Payment',
                        style: TextStyle(
                            color:
                            _selectedIndex == 6 ? mainColor : Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.

          Expanded(
            child: callPage(_selectedIndex),
          )
        ],
      ),
    );
  }
}
