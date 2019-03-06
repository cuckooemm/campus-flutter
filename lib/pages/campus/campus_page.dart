import 'package:campus/pages/campus/dynamic/dynamic_page.dart';
import 'package:campus/pages/campus/notification/notification_page.dart';
import 'package:flutter/material.dart';

class CampusPage extends StatefulWidget{
  @override
  State<CampusPage> createState() => _CampusPage();
}

class _CampusPage extends State<CampusPage> with SingleTickerProviderStateMixin{
  TabController tabController;
  final List<Tab> _tabs = <Tab>[
    Tab(key:Key("dynamic"),text: '动态'),
//    Tab(key:Key("notification"),text: '待完成'),
  ];
  final List<Widget> _tabViews = [
    DynamicPage(),
//    NotificationPage()
  ];
  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: new Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              TabBar(
                controller: tabController,
                tabs: _tabs,
                labelPadding: const EdgeInsets.only(left: 14.0,right: 14.0),
                indicatorWeight: 1.0,
                indicatorPadding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 0.0,bottom: 0.0),
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: true,
                labelColor: Colors.black,
                labelStyle: TextStyle(fontSize: 15.0),
                unselectedLabelColor: Colors.black38,
                unselectedLabelStyle: TextStyle(fontSize: 15.0)
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: _tabViews,
                ),
              )
            ],
          ),
        )
    );
  }

}