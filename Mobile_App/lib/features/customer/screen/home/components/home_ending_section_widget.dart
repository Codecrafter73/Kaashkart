import 'package:flutter/material.dart';
import 'package:kaashtkart/core/ui_helper/app_colors.dart';

// Gradient Background Version (with vertical layout)
class HomeEndingSectionGradient extends StatelessWidget {
  const HomeEndingSectionGradient({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 45),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade50,
            Colors.white,
            Colors.orange.shade50,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Make',
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: Colors.grey.shade300,
              height: 1.1,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Text(
                'The',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey.shade300,
                  height: 1.1,
                  letterSpacing: 2,
                ),
              ),
              Icon(
                Icons.favorite,
                color: Colors.red,
                size: 42,
              ),
              const SizedBox(height: 8),
              Text(
                'MOST',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey.shade300,
                  height: 1.1,
                  letterSpacing: 2,
                ),
              ),

            ],
          ),
          const SizedBox(height: 8),
          Text('Fresh Fields Digital Feast', style: TextStyle(
            fontSize: 14, color: AppColors.txtGreyColor,),),
        ],
      ),
    );
  }
}
