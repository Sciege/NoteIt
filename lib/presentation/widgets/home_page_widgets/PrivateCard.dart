import 'package:flutter/material.dart';

class Privatecard extends StatefulWidget {
  Privatecard({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    // required this.lockColor,
    required this.onUnlock,
  });

  final screenHeight;
  final screenWidth;

  //final Color lockColor;
  final Future<void> Function() onUnlock;

  @override
  State<Privatecard> createState() => _PrivatecardState();
}

class _PrivatecardState extends State<Privatecard> {
  Color lockColor = Colors.grey;

  Future<void> _handleTap() async {

    setState(() => lockColor = const Color(0xFFF6D14C));

        try {
      await widget.onUnlock();
    } finally {
      //go back to grey even if auth fails or is cancelled
      if (mounted) {
        setState(() => lockColor = Colors.grey);
      }
    }
  }

  // Color lockColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: widget.screenHeight * 0.3,
      width: widget.screenWidth * 0.41,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: GestureDetector(
          onTapDown: (_) {
            setState(() {
              lockColor = const Color(0xFFF6D14C); // Yellow
            });
          },
          onTapCancel: () {
            setState(() {
              lockColor = Colors.grey;
            });
          },
          child: IconButton(
            color: lockColor,
            onPressed: _handleTap,
            iconSize: 30,
            icon: Icon(Icons.lock_outline),
          ),
        ),
      ),
    );
  }
}
