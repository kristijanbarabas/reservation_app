import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservation_app/services/authentication.dart';
import 'package:reservation_app/services/constants.dart';

class GoogleSignInButton extends ConsumerStatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends ConsumerState<GoogleSignInButton>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customSignInWithGoogle = ref.watch(authenticationFunctionsProvider);
    _scale = 1 - _controller.value;
    return Center(
      child: GestureDetector(
        onTap: () =>
            customSignInWithGoogle!.customSignInWithGoogle(context: context),
        onTapDown: _tapDown,
        onTapUp: _tapUp,
        child: Transform.scale(
          scale: _scale,
          child: _animatedButton(),
        ),
      ),
    );
  }

  Widget _animatedButton() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              blurRadius: 5,
              color: Color.fromARGB(255, 36, 36, 36),
              spreadRadius: 0.1)
        ],
      ),
      child: const CircleAvatar(
        radius: 35,
        backgroundColor: kButtonColor,
        child: FaIcon(
          FontAwesomeIcons.google,
          color: Colors.white,
        ),
      ),
    );
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
