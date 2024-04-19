import 'package:flutter/material.dart';
import 'package:mind_lab_app/core/constants/routes.dart';
import 'package:mind_lab_app/features/dashboard/presentation/widgets/card_item.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardItem(
              text: "Rashid Rover",
              image: 'lib/assets/images/rashid_rover.png',
              onTap: () {
                print('Rashid Rover');
                Navigator.pushNamed(context, roverMainPageRoute);
              },
            ),
            CardItem(
              text: 'Moddish',
              image: 'lib/assets/images/modish.png',
              onTap: () {
                print('modish');
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardItem(
              text: 'Mecanum Car',
              image: 'lib/assets/images/mecanum_car.png',
              onTap: () {
                print('Mecanum car');
              },
            ),
            CardItem(
              text: 'Battle Bot',
              image: 'lib/assets/images/battle_bot.png',
              onTap: () {
                print('Battle bot');
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardItem(
              text: 'Airplane',
              image: 'lib/assets/images/airplane.png',
              onTap: () {
                print('Airplane');
              },
            ),
            CardItem(
              text: 'Rocket',
              image: 'lib/assets/images/rocket.png',
              onTap: () {
                print('Rocket');
              },
            ),
          ],
        ),
      ],
    );
  }
}
