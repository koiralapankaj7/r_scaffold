// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playground/r_scaffold.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, this.extended = true});

  final bool extended;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // NavigationRail
    return RScaffold(
      menu: RMenu(
        // type: RMenuType.rail, // TODO(kopan7): In mobile this should not consider
        theme: RMenuTheme(
          elevation: 0,
          // backgroundColor: Colors.amber,
          indicatorColor: theme.colorScheme.primary.withAlpha(30),
          radius: BorderRadius.circular(8),
          // indicatorShape: RoundedRectangleBorder(
          //   side: const BorderSide(),
          //   borderRadius: BorderRadius.circular(4),
          // ),
          // maxWidth: 400, // Issue
          // railWidth: 70, // Issue
          // itemMargin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          // selectedIconTheme: const IconThemeData(
          //   color: Colors.blue,
          // ),
          // unselectedIconTheme: IconThemeData(
          //   color: theme.disabledColor,
          // ),
          // selectedLabelTextStyle: theme.textTheme.titleMedium,
          // unselectedLabelTextStyle: theme.textTheme.titleMedium?.copyWith(
          //   color: theme.disabledColor,
          // ),
          // useIndicator: false,

          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
        ),
        header: RMenuHeader(
          avatarLabel: 'PK',
          title: const Text('Pankaj Koirala'),
          // subtitle: Text('Software Enginner'),
          // popupDropdown: true,
          dropdownItems: <MenuItemButton>[
            // Logout
            MenuItemButton(
              onPressed: () {
                debugPrint('Logout selected');
              },
              child: const Row(
                children: <Widget>[
                  Icon(Icons.logout),
                  SizedBox(width: 16),
                  Text('Logout'),
                ],
              ),
            ),
            // Setting
            MenuItemButton(
              onPressed: () {
                debugPrint('Setting selected');
              },
              shortcut: const SingleActivator(
                LogicalKeyboardKey.comma,
                control: true,
              ),
              child: const Row(
                children: <Widget>[
                  Icon(Icons.settings),
                  SizedBox(width: 16),
                  Text('Settings'),
                ],
              ),
            ),
          ],
        ),
        items: [
          // Normal items
          ...List.generate(10, (index) {
            return RMenuItem(
              icon: const Icon(Icons.info),
              label: Text('Item $index'),
              dividerAbove: index == 4,
              dividerBelow: index == 5 || index == 8,
              enabled: index != 5,
              // height: 60,
              tooltip: 'Item $index',
              onPressed: () {
                debugPrint('Item $index');
              },
            );
          }),

          // Dropdown
          RMenuItem.dropdown(
            dividerAbove: true,
            dividerBelow: true,
            builder: (context, animation) {
              return const Text('Dropdown');
            },
            items: List.generate(3, (index) {
              return RMenuItem(
                icon: const Icon(Icons.wallet),
                label: Text('Sub Item $index'),
                dividerAbove: index == 4,
                dividerBelow: index == 5 || index == 8,
                onPressed: () {
                  debugPrint('Sub Item $index');
                },
              );
            }),
          ),

          // Custom item
          RMenuItem.custom(
            dividerBelow: true,
            dividerAbove: true,
            builder: (context, animation) {
              return Container(
                height: 100,
                color: Colors.amber,
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Body'),
      ),
    );
  }
}
