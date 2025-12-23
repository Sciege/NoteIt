import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  const Tabs({
    super.key,
    required this.head,
    required this.ind,
    required this.selectedTab,
    required this.currentTab,
  });

  final String head;
  final int ind;
  final int currentTab;
  final ValueChanged<int> selectedTab;

  /*
  // Remember methods/functions cant be assigned or hold a value when passing
  // so doing this wont work
  int selectedTab = 0;
  Future<void> _selectedTab() async{
    setState(() {
      selectedTab = widget.ind;
    });
  }
  THIS ALSO WONT WORK
  int _selectedTab = 0;

  void selectedTab() {
    setState(() {
      _selectedTab = widget.ind;
    });
  }
*/
  //int selected = 0;

  @override
  Widget build(BuildContext context) {
    // currentTab == ind ans: 0
    // isSelected = 0
    final isSelected = currentTab == ind;
    return GestureDetector(
      onTap: () => selectedTab(ind),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF6D14C) : const Color(0xFF202020),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          head,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
