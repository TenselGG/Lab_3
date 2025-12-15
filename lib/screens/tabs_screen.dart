import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'groups_screen.dart';
import 'contact_list_screen.dart';
import '../providers/contacts_provider.dart';
import '../providers/theme_provider.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    ref.read(contactsProvider.notifier).loadContacts();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _toggleTheme() {
    final currentMode = ref.read(themeProvider);
    final newMode = currentMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    ref.read(themeProvider.notifier).state = newMode;
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = GroupsScreen();
    String activePageTitle = 'Groups';

    if (_selectedPageIndex == 1) {
      activePage = const ContactListScreen();
      activePageTitle = 'Contacts';
    }

    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        actions: [
          IconButton(
            onPressed: _toggleTheme,
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Contacts'),
        ],
      ),
    );
  }
}
