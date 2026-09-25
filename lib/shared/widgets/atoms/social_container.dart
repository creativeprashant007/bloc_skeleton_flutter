import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class SocialContainer extends StatelessWidget {
  const SocialContainer({
    super.key,
    required this.socialName,
    required this.assets,
  });

  final String socialName;
  final String assets;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(assets, height: 24, width: 24),
          SizedBox(width: 8),
          Text(
            "Sign in with $socialName",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
