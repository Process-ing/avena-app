import 'package:flutter/material.dart';
import 'package:avena/screen/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required void Function() onProfilePressed});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomIndex = 0;

  final String userName = "Alice"; // TODO: Make this dynamic in your app

  final List<String> daysOfWeek = [
    "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
  ];

  static const List<Map<String, dynamic>> demoMeals = [
    {
      'label': 'Breakfast',
      'image': 'https://images.unsplash.com/photo-1488900128323-21503983a07e?w=400',
      'desc': 'Toast with eggs',
      'kcal': '140 kCal',
      'done': true,
    },
    {
      'label': 'Second Breakfast',
      'image': null,
      'desc': 'Nothing',
      'kcal': null,
      'done': false,
    },
    {
      'label': 'Lunch',
      'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
      'desc': 'Chicken and potatoes',
      'kcal': '400 kCal',
      'done': true,
    },
    {
      'label': 'Dinner',
      'image': null,
      'desc': 'Nothing',
      'kcal': null,
      'done': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final Color bgColor = Colors.white;

    return DefaultTabController(
      length: 7,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          centerTitle: true,
          leadingWidth: 90,
          leading: Padding(
            padding: const EdgeInsets.only(left: 22, right: 6, top: 8, bottom: 8),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size(30, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: Colors.transparent,
              ),
              child: Text(
                userName,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          title: const Text(
            'Home',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              indicatorWeight: 3,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              tabs: [
                for (final day in daysOfWeek) Tab(text: day),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildDayTab(context, progress: 0.45, kcal: "540/1200 kCal", meals: demoMeals),
            ...daysOfWeek.skip(1).map((day) => _buildDayPlaceholder(day)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDayTab(
      BuildContext context, {
        required double progress,
        required String kcal,
        required List<Map<String, dynamic>> meals,
      }) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                    backgroundColor: Colors.grey[200],
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 18),
                Text(
                  kcal,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        ...meals.map((meal) => _buildMealCard(meal, context)).toList(),
      ],
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal, BuildContext context) {
    final bool done = meal['done'] == true;
    final hasImage = meal['image'] != null;
    final String label = meal['label'];
    final String desc = meal['desc'];
    final String? kcal = meal['kcal'];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: done ? Colors.black : Colors.grey[300]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: hasImage
            ? ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            meal['image'],
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (context, e, s) => _imageFallbackIcon(),
          ),
        )
            : Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.error_outline, color: Colors.grey[500]),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        subtitle: desc == "Nothing"
            ? Text(
          desc,
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        )
            : Text(
          desc,
          style: TextStyle(
            color: done ? Colors.black87 : Colors.black54,
            fontWeight: done ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        trailing: kcal != null
            ? Text(
          kcal,
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        )
            : null,
      ),
    );
  }

  Widget _imageFallbackIcon() => Container(
    color: Colors.grey[300],
    width: 48,
    height: 48,
    child: Icon(Icons.image, color: Colors.grey[500]),
  );

  Widget _buildDayPlaceholder(String label) {
    return Center(
      child: Text(
        'No data for $label yet.',
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}