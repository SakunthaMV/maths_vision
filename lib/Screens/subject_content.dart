import 'package:flutter/material.dart';
import 'package:maths_vision/Splash_Screens/log_in_splash_screen.dart';

import 'navigation_drawer.dart';

class NotePage extends StatefulWidget {
  final String subject;

  const NotePage(this.subject);

  @override
  _NotePageState createState() => _NotePageState(subject);
}

class _NotePageState extends State<NotePage> {
  String subject;

  _NotePageState(this.subject);

  var photos = {
    'Mathematical Induction': [
      "assets/Mathematical_Induction_1.jpg",
      "assets/Mathematical_Induction_2.jpg",
      "assets/Mathematical_Induction_3.jpg"
    ],
    'Inequalities': [
      "assets/Inequalities_1.jpg",
      "assets/Inequalities_2.jpg",
      "assets/Inequalities_3.jpg",
      "assets/Inequalities_4.jpg",
      "assets/Inequalities_5.jpg"
    ],
    'Binomial Expansion': [
      "assets/Binomial_Expansion_1.jpg",
      "assets/Binomial_Expansion_2.jpg",
      "assets/Binomial_Expansion_3.jpg"
    ],
    'Limits': ["assets/Limits.jpg"],
    'Polynomial Equations': [
      "assets/Polynomial_Equations_1.jpg",
      "assets/Polynomial_Equations_2.jpg",
      "assets/Polynomial_Equations_3.jpg",
      "assets/Polynomial_Equations_4.jpg"
    ],
    'Quadratic Functions': [
      "assets/Quadratic_Functions_1.jpg",
      "assets/Quadratic_Functions_2.jpg"
    ],
    'Permutations and Combinations': [
      "assets/Permutations_and_Combinations_1.jpg",
      "assets/Permutations_and_Combinations_2.jpg",
      "assets/Permutations_and_Combinations_3.jpg",
      "assets/Permutations_and_Combinations_4.jpg"
    ],
    'Series': [
      "assets/Series_1.jpg",
      "assets/Series_2.jpg",
      "assets/Series_3.jpg"
    ],
    'Matrices': [
      "assets/Matrices_1.jpg",
      "assets/Matrices_2.jpg",
      "assets/Matrices_3.jpg",
      "assets/Matrices_4.jpg",
      "assets/Matrices_5.jpg",
      "assets/Matrices_6.jpg",
      "assets/Matrices_7.jpg"
    ],
    'Complex Numbers': [
      "assets/Complex_Numbers_1.jpg",
      "assets/Complex_Numbers_2.jpg",
      "assets/Complex_Numbers_3.jpg",
      "assets/Complex_Numbers_4.jpg",
      "assets/Complex_Numbers_5.jpg"
    ],
    'Differentiation': [
      "assets/Differentiation_1.jpg",
      "assets/Differentiation_2.jpg",
      "assets/Differentiation_3.jpg"
    ],
    'Integration': [
      "assets/Integration_1.jpg",
      "assets/Integration_2.jpg",
      "assets/Integration_3.jpg",
      "assets/Integration_4.jpg",
      "assets/Integration_5.jpg"
    ],
    'Straight Line': [
      "assets/Straight_Line_1.jpg",
      "assets/Straight_Line_2.jpg",
      "assets/Straight_Line_3.jpg",
      "assets/Straight_Line_4.jpg",
      "assets/Straight_Line_5.jpg",
      "assets/Straight_Line_6.jpg"
    ],
    'Circle': [
      "assets/Circle_1.jpg",
      "assets/Circle_2.jpg",
      "assets/Circle_3.jpg",
      "assets/Circle_4.jpg",
      "assets/Circle_5.jpg",
      "assets/Circle_6.jpg",
      "assets/Circle_7.jpg",
      "assets/Circle_8.jpg",
      "assets/Circle_9.jpg"
    ],
    'Trigonometry': [
      "assets/Trigonometry_1.jpg",
      "assets/Trigonometry_2.jpg",
      "assets/Trigonometry_3.jpg",
      "assets/Trigonometry_4.jpg",
      "assets/Trigonometry_5.jpg",
      "assets/Trigonometry_6.jpg",
      "assets/Trigonometry_7.jpg"
    ],
    'Collisions': [
      "assets/Collisions_1.jpg",
      "assets/Collisions_2.jpg",
      "assets/Collisions_3.jpg",
      "assets/Collisions_4.jpg"
    ],
    'Projectiles': [
      "assets/Projectiles_1.jpg",
      "assets/Projectiles_2.jpg",
      "assets/Projectiles_3.jpg"
    ],
    'Friction': [
      "assets/Friction_1.jpg",
      "assets/Friction_2.jpg",
      "assets/Friction_3.jpg",
      "assets/Friction_4.jpg"
    ],
    'Work, Energy, Power': [
      "assets/Work_Energy_Power_1.jpg",
      "assets/Work_Energy_Power_2.jpg",
      "assets/Work_Energy_Power_3.jpg",
      "assets/Work_Energy_Power_4.jpg",
    ],
    'Vectors': [
      "assets/Vectors_1.jpg",
      "assets/Vectors_2.jpg",
      "assets/Vectors_3.jpg",
      "assets/Vectors_4.jpg",
      "assets/Vectors_5.jpg",
      "assets/Vectors_6.jpg",
      "assets/Vectors_7.jpg"
    ],
    'Coplanar Forces': [
      "assets/Coplanar_Forces_1.jpg",
      "assets/Coplanar_Forces_2.jpg",
      "assets/Coplanar_Forces_3.jpg",
      "assets/Coplanar_Forces_4.jpg",
      "assets/Coplanar_Forces_5.jpg"
    ],
    'Equilibrium of Forces': [
      "assets/Equilibrium_of_Forces_1.jpg",
      "assets/Equilibrium_of_Forces_2.jpg",
      "assets/Equilibrium_of_Forces_3.jpg",
      "assets/Equilibrium_of_Forces_4.jpg",
      "assets/Equilibrium_of_Forces_5.jpg",
      "assets/Equilibrium_of_Forces_6.jpg",
      "assets/Equilibrium_of_Forces_7.jpg"
    ],
    'Velocity-Time Graphs': [
      "assets/Velocity-Time_Graphs_1.jpg",
      "assets/Velocity-Time_Graphs_2.jpg",
      "assets/Velocity-Time_Graphs_3.jpg"
    ],
    'Relative Velocity': [
      "assets/Relative_Velocity_1.jpg",
      "assets/Relative_Velocity_2.jpg",
      "assets/Relative_Velocity_3.jpg",
      "assets/Relative_Velocity_4.jpg",
      "assets/Relative_Velocity_5.jpg",
      "assets/Relative_Velocity_6.jpg"
    ],
    'Relative Acceleration': [
      "assets/Relative_Acceleration_1.jpg",
      "assets/Relative_Acceleration_2.jpg",
      "assets/Relative_Acceleration_3.jpg",
      "assets/Relative_Acceleration_4.jpg",
      "assets/Relative_Acceleration_5.jpg"
    ],
    'Circular Motion': [
      "assets/Circular_Motion_1.jpg",
      "assets/Circular_Motion_2.jpg",
      "assets/Circular_Motion_3.jpg",
      "assets/Circular_Motion_4.jpg"
    ],
    'Simple Harmonic Motion': [
      "assets/Simple_Harmonic_Motion_1.jpg",
      "assets/Simple_Harmonic_Motion_2.jpg",
      "assets/Simple_Harmonic_Motion_3.jpg",
      "assets/Simple_Harmonic_Motion_4.jpg",
      "assets/Simple_Harmonic_Motion_5.jpg",
      "assets/Simple_Harmonic_Motion_6.jpg",
      "assets/Simple_Harmonic_Motion_7.jpg",
      "assets/Simple_Harmonic_Motion_8.jpg",
      "assets/Simple_Harmonic_Motion_9.jpg",
      "assets/Simple_Harmonic_Motion_10.jpg",
      "assets/Simple_Harmonic_Motion_11.jpg",
      "assets/Simple_Harmonic_Motion_12.jpg",
      "assets/Simple_Harmonic_Motion_13.jpg",
      "assets/Simple_Harmonic_Motion_14.jpg"
    ],
    'Frame Works': [
      "assets/Frame_Works_1.jpg",
      "assets/Frame_Works_2.jpg",
      "assets/Frame_Works_3.jpg",
      "assets/Frame_Works_4.jpg",
      "assets/Frame_Works_5.jpg"
    ],
    'Jointed Rods': [
      "assets/Jointed_Rods_1.jpg",
      "assets/Jointed_Rods_2.jpg",
      "assets/Jointed_Rods_3.jpg",
      "assets/Jointed_Rods_4.jpg",
      "assets/Jointed_Rods_5.jpg"
    ],
    'Center of Gravity': [
      "assets/Center_of_Gravity_1.jpg",
      "assets/Center_of_Gravity_2.jpg",
      "assets/Center_of_Gravity_3.jpg",
      "assets/Center_of_Gravity_4.jpg",
      "assets/Center_of_Gravity_5.jpg",
      "assets/Center_of_Gravity_6.jpg",
      "assets/Center_of_Gravity_7.jpg",
      "assets/Center_of_Gravity_8.jpg",
      "assets/Center_of_Gravity_9.jpg",
      "assets/Center_of_Gravity_10.jpg",
      "assets/Center_of_Gravity_11.jpg",
      "assets/Center_of_Gravity_12.jpg",
      "assets/Center_of_Gravity_13.jpg",
      "assets/Center_of_Gravity_14.jpg"
    ],
    'Probability': [
      "assets/Probability_1.jpg",
      "assets/Probability_2.jpg",
      "assets/Probability_3.jpg",
      "assets/Probability_4.jpg",
      "assets/Probability_5.jpg",
      "assets/Probability_6.jpg"
    ],
    'Statistics': [
      "assets/Statistics_1.jpg",
      "assets/Statistics_2.jpg",
      "assets/Statistics_3.jpg",
      "assets/Statistics_4.jpg",
      "assets/Statistics_5.jpg",
      "assets/Statistics_6.jpg",
      "assets/Statistics_7.jpg",
      "assets/Statistics_8.jpg",
      "assets/Statistics_9.jpg"
    ],
  };

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          color: Color.fromARGB(255, 0, 135, 145),
        ),
        Opacity(
          opacity: 0.12,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/HomeBackground.jpg'),
                  fit: BoxFit.fill),
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              subject,
              style: TextStyle(
                fontFamily: 'Gabriola',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  iconSize: 35,
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    return Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 70,
            toolbarHeight: 70,
            actions: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 4),
                      color: Colors.grey.shade700,
                      blurRadius: 10,
                      spreadRadius: -9,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: ClipOval(
                    child: Image.asset(
                      'assets/HomeButton.jpg',
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) {
                          return LogInSplashScreen();
                        },
                      ),
                    );
                  },
                  iconSize: 35,
                  splashRadius: 25,
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          drawer: NavigationDrawer(),
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              width: size.width * 0.95,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: ListView.builder(
                    itemCount: photos[subject].length,
                    itemBuilder: (context, index) {
                      return Image.asset(photos[subject][index]);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
