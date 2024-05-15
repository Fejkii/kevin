import 'package:flutter/material.dart';

class AppLoginButton extends StatelessWidget {
  final String text;
  final Color color;
  final ImageProvider image;
  final VoidCallback onPressed;
  const AppLoginButton({
    super.key,
    required this.text,
    required this.color,
    required this.image,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const SizedBox(width: 5),
              Image(
                image: image,
                width: 25,
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyle(color: color, fontSize: 18),
                  ),
                  const SizedBox(width: 35),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
