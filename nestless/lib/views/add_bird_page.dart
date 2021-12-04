import 'package:flutter/material.dart';

class AddBirdPage extends StatefulWidget {
  const AddBirdPage({Key? key,}): super(key: key);

  @override
  State<AddBirdPage> createState() => _AddBirdPageState();
}


class _AddBirdPageState extends State<AddBirdPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height, 
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/forest-background.jpg')
            ),
          )));
  }
}