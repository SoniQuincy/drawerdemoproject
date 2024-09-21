import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<MenuItem> menuItems = [];

  @override
  void initState() {
    super.initState();
    loadMenuItems();
  }

  Future<void> loadMenuItems() async {
    String jsonString = await rootBundle.loadString('assets/menu.json');
    Map<String, dynamic> jsonResponse = json.decode(jsonString);
    List<dynamic> items = jsonResponse['items'];

    setState(() {
      menuItems = items.map((item) => MenuItem.fromJson(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3-Tier Side Menu'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: menuItems.map((item) => buildMenuItem(item)).toList(),

        ),
      ),
      body : Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/image1.jpg'), // Background image
            fit: BoxFit.cover,
          ),
        ),

    ));
  }

  Widget buildMenuItem(MenuItem item) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Icon(Icons.ac_unit, color: Colors.black), // Custom icon color
        title: Text(
          item.title,
          style: TextStyle(
            fontWeight: item.subItems.isNotEmpty ? FontWeight.bold : FontWeight.normal,
            fontSize: item.subItems.isNotEmpty ? 16 : 14,
            color: Colors.black87,
          ),
        ),
        children: item.subItems.map((subItem) => buildSubMenuItem(subItem)).toList(),
      ),
    );
  }

  Widget buildSubMenuItem(MenuItem subItem) {
    return InkWell(
      onTap: () {
        // Add action if needed
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Text(
          subItem.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }


 }

class MenuItem {
  final String title;
  final String? imgSrc;
  final List<MenuItem> subItems;

  MenuItem(this.title, [this.subItems = const [], this.imgSrc]);

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    var subItemsJson = json['subItems'] as List<dynamic>? ?? [];
    return MenuItem(
      json['title'] as String,
      subItemsJson.map((items) => MenuItem.fromJson(items)).toList(),
      json['img']?['src'] as String?,

    );
  }
}