// core/widgets/section_title.dart
import 'package:flutter/material.dart';
import 'package:day_os/core/theme/font_util.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: FontUtil.titleMedium(
        color: Colors.white,
        
      ),
    );
  }
}

