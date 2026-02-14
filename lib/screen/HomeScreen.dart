import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: Text('avena'),
          bottom: TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: [
              Tab(text: "Monday"),
              Tab(text: "Tuesday"),
              Tab(text: "Wednesday"),
              Tab(text: "Thursday"),
              Tab(text: "Friday"),
              Tab(text: "Saturday"),
              Tab(text: "Sunday"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.directional(
                    start: 16,
                    top: 16,
                    bottom: 8,
                    end: 24,
                  ),
                  child: Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 0.45,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                          trackGap: 8,
                        ),
                      ),
                      Text(
                        "540/1200 kCal",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Image.network("https://picsum.photos/200/200"),
                  title: Text('Breakfast'),
                  subtitle: Text('Toast with eggs'),
                  trailing: Text('140 kCal'),
                ),
                ListTile(
                  leading: Padding(
                    padding: EdgeInsetsGeometry.all(16),
                    child: Icon(Icons.error_outline),
                  ),
                  title: Text('Second Breakfast'),
                  subtitle: Text(
                    'Nothing',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                ListTile(
                  leading: Image.network("https://picsum.photos/200/200"),
                  title: Text('Lunch'),
                  subtitle: Text('Chicken and potatoes'),
                  trailing: Text('400 kCal'),
                ),
                ListTile(
                  leading: Padding(
                    padding: EdgeInsetsGeometry.all(16),
                    child: Icon(Icons.error_outline),
                  ),
                  title: Text('Dinner'),
                  subtitle: Text(
                    'Nothing',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
            Text("Tuesday"),
            Text("Wednesdays"),
            Text("Thursday"),
            Text("Friday"),
            Text("Saturday"),
            Text("Sunday"),
          ],
        ),
      ),
    );
  }
}
