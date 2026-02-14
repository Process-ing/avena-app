import 'package:flutter/material.dart';

class CookBookScreen extends StatelessWidget {
  const CookBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cook Book')),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    children: [
                      ChoiceChip(
                        label: Text('Breakfast'),
                        selected: false,
                        onSelected: (v) => {},
                      ),
                      SizedBox(width: 4),
                      ChoiceChip(
                        label: Text('Second Breakfast'),
                        selected: false,
                        onSelected: (v) => {},
                      ),
                      SizedBox(width: 4),
                      ChoiceChip(
                        label: Text('Morning Snack'),
                        selected: false,
                        onSelected: (v) => {},
                      ),
                      SizedBox(width: 4),
                      ChoiceChip(
                        label: Text('Lunch'),
                        selected: false,
                        onSelected: (v) => {},
                      ),
                      SizedBox(width: 4),
                      ChoiceChip(
                        label: Text('Afternoon Snack'),
                        selected: false,
                        onSelected: (v) => {},
                      ),
                      SizedBox(width: 4),
                      ChoiceChip(
                        label: Text('Dinner'),
                        selected: false,
                        onSelected: (v) => {},
                      ),
                      SizedBox(width: 4),
                      ChoiceChip(
                        label: Text('Supper'),
                        selected: false,
                        onSelected: (v) => {},
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40, child: VerticalDivider(width: 1)),
              SizedBox(width: 4),
              ChoiceChip(
                label: Text('Pantry'),
                selected: true,
                onSelected: (v) => {},
              ),
              SizedBox(width: 8),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => Card(
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  alignment: AlignmentGeometry.center,
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        "https://picsum.photos/800/450",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.all(32),
                      child: Text(
                        'Recipe title very nice',
                        style: Theme.of(context).primaryTextTheme.displayLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              itemCount: 1000,
            ),
          ),
        ],
      ),
    );
  }
}
