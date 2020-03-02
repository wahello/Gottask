import 'package:flutter/material.dart';
import 'package:gottask/constant.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SplashScreen extends StatefulWidget {
  final bool isInit;
  SplashScreen({this.isInit});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  PageController controller = PageController(viewportFraction: 0.8);
  bool _done = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF6F7F8),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 35,
            ),
            Flexible(
              flex: 5,
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: controller,
                itemBuilder: (context, pos) {
                  return FittedBox(
                    child: Container(
                      margin: const EdgeInsets.all(30),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 30,
                            spreadRadius: 5,
                            color: TodoColors.deepPurple.withOpacity(0.5),
                          ),
                        ],
                        color: TodoColors.deepPurple,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          splashScreen[pos],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
                onPageChanged: (value) {
                  setState(() {
                    if (value == 3)
                      _done = true;
                    else
                      _done = false;
                  });
                },
                itemCount: 4,
              ),
            ),
            Flexible(
              flex: 1,
              child: Center(
                child: _done == false
                    ? SmoothPageIndicator(
                        controller: controller,
                        count: 4,
                        effect: JumpingDotEffect(
                          activeDotColor: TodoColors.deepPurple,
                        ),
                      )
                    : Material(
                        borderRadius: BorderRadius.circular(15),
                        child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                          onTap: () async {
                            if (widget.isInit == null) {
                              await updateStartState();
                              Navigator.popAndPushNamed(context, '/config');
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 25,
                            ),
                            decoration: BoxDecoration(
                              color: TodoColors.deepPurple,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                  color: TodoColors.deepPurple.withOpacity(0.5),
                                ),
                              ],
                            ),
                            child: Text(
                              widget.isInit == null ? 'Let\'s go!' : 'Go back',
                              style: TextStyle(
                                fontFamily: 'Alata',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
