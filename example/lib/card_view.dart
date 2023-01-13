import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  const CardView({
    Key? key,
    this.text = "Card View",
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0.5,
            1,
          ],
          colors: [
            Colors.blueAccent,
            Color.fromARGB(255, 6, 28, 61),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w700),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 8.0)),
          Text("$text details",
              textAlign: TextAlign.start,
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
