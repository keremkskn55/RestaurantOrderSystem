import 'package:flutter/material.dart';

class CreateAccontNameSelectFloor extends StatefulWidget {
  Function callback;
  CreateAccontNameSelectFloor({required this.callback});

  @override
  State<CreateAccontNameSelectFloor> createState() =>
      _CreateAccontNameSelectFloorState();
}

class _CreateAccontNameSelectFloorState
    extends State<CreateAccontNameSelectFloor> {
  int numberOfFloor = 3;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Number Of Places:   ',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          DropdownButton<int>(
            value: numberOfFloor,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.black,
            ),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            onChanged: (int? newValue) {
              setState(() {
                numberOfFloor = newValue!;
                widget.callback(newValue);
              });
            },
            items: <int>[1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(
                  '$value',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
