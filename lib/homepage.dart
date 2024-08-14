import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'signalscreen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E2EE Signal POC',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
        toolbarHeight: 45,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          color: Colors.white12,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Expanded(
                child: Icon(
                  Icons.keyboard_command_key,
                  size: 160,
                ),
              )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 500))
                  .shake(),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(30),
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignalTestScreen(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(10)),
                    height: MediaQuery.of(context).size.width * .3,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                        child: Text(
                      "One to One Chat",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(30),
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(10)),
                    height: MediaQuery.of(context).size.width * .3,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                        child: Text(
                      "Group Chat",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
