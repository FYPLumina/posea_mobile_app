import 'package:flutter/material.dart';
import 'package:posea_mobile_app/core/widgets/custom_button.dart';

class PoseOfTheDayCard extends StatelessWidget {
  const PoseOfTheDayCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            //TODO: Replace with dynamic image
            child: Image.asset(
              'assets/images/pose-of-the-day-sample-image.png',
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Pose of the Day', style: TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(width: 12),
                CustomButton(
                  backgroundColor: const Color.fromARGB(255, 179, 116, 57),
                  onPressed: () {},
                  label: 'Try this pose',
                  width: 150,
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
