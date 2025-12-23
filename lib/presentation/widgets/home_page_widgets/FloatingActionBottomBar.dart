import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FloatingActionBottomBar extends StatefulWidget {
  final Future<void> Function() handleLock;

  const FloatingActionBottomBar({super.key, required this.handleLock});

  @override
  State<FloatingActionBottomBar> createState() =>
      _FloatingActionBottomBarState();
}

class _FloatingActionBottomBarState extends State<FloatingActionBottomBar> {

  // Future<void > onTap() async {
  //  try{
  //    await widget.handleLock;
  //    print('trying to unlock');
  //  }catch(e){
  //    print('Error tapping: {$e}');
  //  }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 60),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF202020),
        borderRadius: BorderRadius.circular(30),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.check_box_outlined, color: Colors.white),
              onPressed: () {
                //TodolistPage
                context.go('/todolist_page');
              },
            ),

            const Spacer(),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color(0xFFF6D14C),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.black,
                  size: 25,
                ),

                onPressed: () {
                  //NotesPage
                  context.go('/notes_page');
                },
              ),
            ),

            const Spacer(),
            IconButton(
              icon: const Icon(Icons.lock_outline, color: Colors.white),
              onPressed: () async {
                // todo: REMEMBER
                // widget.handleLock() and widget.handleLock is not the same
                widget.handleLock();
               // print('tapping');
              },
            ),
          ],
        ),
      ),
    );
  }
}
