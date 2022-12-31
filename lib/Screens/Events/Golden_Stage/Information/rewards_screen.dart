import 'package:flutter/material.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 79, 134),
      body: Center(
        child: Container(
          width: width * 0.95,
          height: double.infinity,
          margin: EdgeInsets.only(
            top: height * 0.05,
            bottom: width * 0.025,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  margin: EdgeInsets.only(top: height * 0.2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 239, 197, 1),
                        Color.fromARGB(255, 249, 224, 159).withOpacity(0.5),
                        Color.fromARGB(255, 239, 197, 1),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Rewards',
                      style: TextStyle(
                        fontSize: 23,
                        fontFamily: 'Open Sans',
                        letterSpacing: 0.2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: width * 0.95,
                  height: height * 0.2,
                  child: Image.asset('assets/Reward_Icon.png'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height * 0.2 + 40),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 25,
                          width: width * 0.95,
                          margin: EdgeInsets.only(top: 18),
                          padding: EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color.fromARGB(255, 1, 79, 134), Colors.white],
                            ),
                          ),
                          child: Text(
                            'RANKERS',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Open Sans',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 10),
                          height: height * 0.3,
                          width: width*95,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: height*0.3,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 199, 14).withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image.asset('assets/LeaderBoard_First_Batch.png'),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 233, 233, 233),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      offset: Offset(0,2),
                                      color: Colors.black.withOpacity(0.2),
                                    )
                                  ],
                                ),
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10, 10, 5, 5),
                                            child: SizedBox(
                                              width: width * 0.25,
                                              child: Image.asset('assets/Video_Voucher.png'),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(5, 10, 10, 5),
                                            child: SizedBox(
                                              width: width * 0.25,
                                              child: Stack(
                                                children: [
                                                  Image.asset('assets/Answer_Voucher.png'),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      width: 13,
                                                      height: 13,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.black,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '2',
                                                          style: TextStyle(
                                                            fontFamily: 'Blenda Script',
                                                            fontSize: 9,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                            child: SizedBox(
                                              width: width * 0.25,
                                              child: Stack(
                                                children: [
                                                  Image.asset(
                                                      'assets/Golden_Double_XP_Card.png'),
                                                  Positioned(
                                                    top: 2,
                                                    right: 1,
                                                    child: Container(
                                                      width: 13,
                                                      height: 13,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.black,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '2',
                                                          style: TextStyle(
                                                            fontFamily: 'Blenda Script',
                                                            fontSize: 9,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                                            child: SizedBox(
                                              width: width * 0.25,
                                              child: Stack(
                                                children: [
                                                  Image.asset('assets/Double_XP_Card.png'),
                                                  Positioned(
                                                    top: 2,
                                                    right: 1,
                                                    child: Container(
                                                      width: 13,
                                                      height: 13,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.black,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '5',
                                                          style: TextStyle(
                                                            fontFamily: 'Blenda Script',
                                                            fontSize: 9,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
                                            child: SizedBox(
                                              width: width * 0.25,
                                              child: Stack(
                                                children: [
                                                  Image.asset(
                                                      'assets/Double_Coin_Bonus_Card.png'),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      width: 13,
                                                      height: 13,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.black,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '3',
                                                          style: TextStyle(
                                                            fontFamily: 'Blenda Script',
                                                            fontSize: 9,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: width * 0.25,
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.fromLTRB(5, 5, 10, 10),
                                            child: FittedBox(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    '1000',
                                                    style: TextStyle(
                                                      fontFamily: 'Open Sans',
                                                      fontSize: 17,
                                                      color: Colors.black,
                                                      height: 1.3,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  SizedBox(
                                                    width: 17,
                                                    child: Image.asset('assets/Coin.png'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 10),
                          height: height * 0.3,
                          width: width*0.95,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: height*0.3,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 190, 195, 199).withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image.asset('assets/LeaderBoard_Second_Batch.png'),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 233, 233, 233),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      offset: Offset(0,2),
                                      color: Colors.black.withOpacity(0.2),
                                    )
                                  ],
                                ),
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10, 10, 5, 5),
                                            child: SizedBox(
                                              width: width * 0.25,
                                              child: Stack(
                                                children: [
                                                  Image.asset('assets/Answer_Voucher.png'),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(5, 10, 10, 5),
                                            child: SizedBox(
                                              width: width * 0.25,
                                              child: Stack(
                                                children: [
                                                  Image.asset(
                                                      'assets/Golden_Double_XP_Card.png'),
                                                  Positioned(
                                                    top: 2,
                                                    right: 1,
                                                    child: Container(
                                                      width: 13,
                                                      height: 13,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.black,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '2',
                                                          style: TextStyle(
                                                            fontFamily: 'Blenda Script',
                                                            fontSize: 9,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                            child: SizedBox(
                                              width: width * 0.25,
                                              child: Stack(
                                                children: [
                                                  Image.asset('assets/Double_XP_Card.png'),
                                                  Positioned(
                                                    top: 2,
                                                    right: 1,
                                                    child: Container(
                                                      width: 13,
                                                      height: 13,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.black,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '5',
                                                          style: TextStyle(
                                                            fontFamily: 'Blenda Script',
                                                            fontSize: 9,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                                            child: SizedBox(
                                              width: width * 0.25,
                                              child: Stack(
                                                children: [
                                                  Image.asset(
                                                      'assets/Double_Coin_Bonus_Card.png'),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      width: 13,
                                                      height: 13,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.black,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '2',
                                                          style: TextStyle(
                                                            fontFamily: 'Blenda Script',
                                                            fontSize: 9,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: width * 0.25,
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.fromLTRB(5, 5, 10, 10),
                                        child: FittedBox(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '700',
                                                style: TextStyle(
                                                  fontFamily: 'Open Sans',
                                                  fontSize: 17,
                                                  color: Colors.black,
                                                  height: 1.3,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              SizedBox(
                                                width: 17,
                                                child: Image.asset('assets/Coin.png'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 10),
                          height: height * 0.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: height*0.2,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 199, 14).withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image.asset('assets/LeaderBoard_Third_Batch.png'),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 233, 233, 233),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      offset: Offset(0,2),
                                      color: Colors.black.withOpacity(0.2),
                                    )
                                  ],
                                ),
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                            child: SizedBox(
                                              width: width * 0.25,
                                              child: Stack(
                                                children: [
                                                  Image.asset(
                                                      'assets/Golden_Double_XP_Card.png'),
                                                  Positioned(
                                                    top: 2,
                                                    right: 1,
                                                    child: Container(
                                                      width: 13,
                                                      height: 13,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.black,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '1',
                                                          style: TextStyle(
                                                            fontFamily: 'Blenda Script',
                                                            fontSize: 9,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                                            child: SizedBox(
                                              width: width * 0.25,
                                              child: Stack(
                                                children: [
                                                  Image.asset('assets/Double_XP_Card.png'),
                                                  Positioned(
                                                    top: 2,
                                                    right: 1,
                                                    child: Container(
                                                      width: 13,
                                                      height: 13,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.black,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '3',
                                                          style: TextStyle(
                                                            fontFamily: 'Blenda Script',
                                                            fontSize: 9,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
                                            child: SizedBox(
                                              width: width * 0.25,
                                              child: Stack(
                                                children: [
                                                  Image.asset(
                                                      'assets/Double_Coin_Bonus_Card.png'),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      width: 13,
                                                      height: 13,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.black,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '1',
                                                          style: TextStyle(
                                                            fontFamily: 'Blenda Script',
                                                            fontSize: 9,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: width * 0.25,
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.fromLTRB(5, 5, 10, 10),
                                            child: FittedBox(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    '500',
                                                    style: TextStyle(
                                                      fontFamily: 'Open Sans',
                                                      fontSize: 17,
                                                      color: Colors.black,
                                                      height: 1.3,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  SizedBox(
                                                    width: 17,
                                                    child: Image.asset('assets/Coin.png'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 20,
                          width: width * 0.95,
                          margin: EdgeInsets.only(top: 15),
                          padding: EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color.fromARGB(255, 1, 79, 134), Colors.white],
                            ),
                          ),
                          child: Text(
                            'POSITION',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Open Sans',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(width*0.025, 20, width*0.025, 10),
                          height: height * 0.2,
                          width: width*0.95,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 233, 233, 233),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      offset: Offset(0,2),
                                      color: Colors.black.withOpacity(0.2),
                                    )
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Center(
                                  child: SizedBox(
                                    width: 50,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '0%',
                                          style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Icon(
                                            Icons.south,
                                            size: 30,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '10%',
                                          style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 233, 233, 233),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      offset: Offset(0,2),
                                      color: Colors.black.withOpacity(0.2),
                                    )
                                  ],
                                ),
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10,10, 5, 5),
                                            child: SizedBox(
                                              width: width * 0.25,
                                              child: Stack(
                                                children: [
                                                  Image.asset('assets/Double_XP_Card.png'),
                                                  Positioned(
                                                    top: 2,
                                                    right: 1,
                                                    child: Container(
                                                      width: 13,
                                                      height: 13,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.black,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '2',
                                                          style: TextStyle(
                                                            fontFamily: 'Blenda Script',
                                                            fontSize: 9,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(5, 10, 10, 5),
                                            child: SizedBox(
                                              width: width * 0.25,
                                              child: Stack(
                                                children: [
                                                  Image.asset(
                                                      'assets/Double_Coin_Bonus_Card.png'),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      width: 13,
                                                      height: 13,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.black,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '1',
                                                          style: TextStyle(
                                                            fontFamily: 'Blenda Script',
                                                            fontSize: 9,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: width * 0.25,
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.fromLTRB(5, 5, 10, 10),
                                        child: FittedBox(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '300',
                                                style: TextStyle(
                                                  fontFamily: 'Open Sans',
                                                  fontSize: 17,
                                                  color: Colors.black,
                                                  height: 1.3,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              SizedBox(
                                                width: 17,
                                                child: Image.asset('assets/Coin.png'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 10),
                          height: height * 0.15,
                          width: width*0.95,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 233, 233, 233),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      offset: Offset(0,2),
                                      color: Colors.black.withOpacity(0.2),
                                    )
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Center(
                                  child: SizedBox(
                                    width: 50,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '10%',
                                          style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Icon(
                                            Icons.south,
                                            size: 30,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '20%',
                                          style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 233, 233, 233),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      offset: Offset(0,2),
                                      color: Colors.black.withOpacity(0.2),
                                    )
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                                      child: SizedBox(
                                        width: width * 0.25,
                                        child: Stack(
                                          children: [
                                            Image.asset('assets/Double_XP_Card.png'),
                                            Positioned(
                                              top: 2,
                                              right: 1,
                                              child: Container(
                                                width: 13,
                                                height: 13,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '1',
                                                    style: TextStyle(
                                                      fontFamily: 'Blenda Script',
                                                      fontSize: 9,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width * 0.25,
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.fromLTRB(5, 10, 10, 10),
                                      child: FittedBox(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '200',
                                              style: TextStyle(
                                                fontFamily: 'Open Sans',
                                                fontSize: 17,
                                                color: Colors.black,
                                                height: 1.3,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            SizedBox(
                                              width: 17,
                                              child: Image.asset('assets/Coin.png'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          height: height * 0.15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 233, 233, 233),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      offset: Offset(0,2),
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Center(
                                  child: SizedBox(
                                    width: 50,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '20%',
                                          style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Icon(
                                            Icons.south,
                                            size: 30,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '30%',
                                          style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 233, 233, 233),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      offset: Offset(0,2),
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  width: width * 0.5,
                                  padding: EdgeInsets.all(25),
                                  margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  child: FittedBox(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '100',
                                          style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 17,
                                            color: Colors.black,
                                            height: 1.3,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        SizedBox(
                                          width: 17,
                                          child: Image.asset('assets/Coin.png'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
