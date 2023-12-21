import 'dart:async';

import 'package:flutter/material.dart';
import 'package:apk_sinduuu/screens/signin_screen.dart';
import 'package:apk_sinduuu/widgets/custom_scaffold.dart';
import 'package:apk_sinduuu/widgets/welcome_button.dart';
import 'package:get/get.dart';

import '../Page/LoginPage.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    Timer(
        const Duration(seconds: 5),
            ()=> Get.off(()=> SignInScreen())
    );

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: Transform.translate(
                    offset: Offset(0.0, 300.0 * (1 - _animation.value)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 40.0,
                        horizontal: 40.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logosapta.png', // Sesuaikan dengan path gambar Anda
                            height: 150, // Sesuaikan tinggi gambar sesuai kebutuhan
                            width: 150, // Sesuaikan lebar gambar sesuai kebutuhan
                          ),
                          const SizedBox(height: 15),
                          RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'PT. Sapta Cakra Manunggal\n',
                                  style: TextStyle(
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.lightGreen
                                  ),
                                ),
                                TextSpan(
                                  text: '\nVictory Without Gun!',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.lightGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Flexible(
          //   flex: 1,
          //   child: Align(
          //     alignment: Alignment.bottomRight,
          //     child: Padding(
          //       padding: const EdgeInsets.all(20.0),
          //       child: Row(
          //         children: [
          //           Expanded(
          //             child: WelcomeButton(
          //               buttonText: 'Sign in',
          //               onTap: SignInScreen(),
          //               color: Colors.transparent,
          //               textColor: Colors.white,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
