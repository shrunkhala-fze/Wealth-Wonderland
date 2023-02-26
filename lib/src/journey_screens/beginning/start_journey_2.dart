import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:wealth_wonderland/src/style/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_animation/weather_animation.dart';

import '../../style/rough/button.dart';

class StartJourney2 extends StatefulWidget {
  const StartJourney2({super.key});

  @override
  State<StartJourney2> createState() => _StartJourney2State();
}

class _StartJourney2State extends State<StartJourney2> {
  static final _log = Logger('PlaySessionScreen');

  int _questionIndex = 0;
  final List<String> _questions = [
    "First, tell us your name! What should we call you?",
    "What kind of adventurer do you want to be?",
    "How old are you?",
    "Every adventurer needs a strong foundation to build on, and the same goes for investing. How much do you plan to invest regularly?",
    "Finally, What's your investing horizon? Do you have any financial goals in mind, like saving for a down payment on a house or planning for retirement?"
  ];

  static const dialogues = [
    "But before we set off on this adventure, we'll need to know a bit more about you!",
    "Now that we have a better understanding of your starting point, we can start to create your smart SIP. Think of it as your trusty pack, filled with a curated selection of investment options that align with your goals and risk profile. You'll be able to customize your smart SIP as you go, adding and removing investments based on your interests and market trends."
  ];

  late String _name = '';
  late bool _isDaring = false;
  late int _age = 0;
  late int _sipAmount = 0;
  late int _horizon = 0;

  String kind = '';
  String radioVal = 'lol';

  bool introFinished = false;

  @override
  void initState() {
    super.initState();
    _loadData();

    _log.info(_name);
    _log.info(_isDaring);
    _log.info(_age);
    _log.info(_sipAmount);
    _log.info(_horizon);
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name')!;
      _isDaring = prefs.getBool('isDaring')!;
      _age = prefs.getInt('age')!;
      _sipAmount = prefs.getInt('sipAmount')!;
      _horizon = prefs.getInt('horizon')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    String kindImage = '';

    if (kind == 'cautious') {
      kindImage = "assets/images/journey/beginning/cautious.png";
    } else if (kind == 'brave') {
      kindImage = "assets/images/journey/beginning/brave.png";
    }

    return Scaffold(
      backgroundColor: palette.beige,
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Visibility(
            visible: _questionIndex == 1 && kind != '',
            child: Opacity(
              opacity: 0.5,
              child: SizedBox.expand(
                  child: kind == 'brave'
                      ? WeatherScene.values.byName('stormy').getWeather()
                      : WeatherScene.values
                          .byName('scorchingSun')
                          .getWeather()),
            ),
          ),
          Container(
              constraints: const BoxConstraints.expand(),
              // decoration: const BoxDecoration(
              //     image: DecorationImage(
              //         image:
              //             AssetImage("assets/images/journey/beginning/bg1.jpg"),
              //         fit: BoxFit.cover)),
              child: Column(
                children: [
                  Expanded(
                      child: Visibility(
                          visible: !introFinished, child: _introTitle())),
                  Expanded(
                      flex: 3,
                      child: Center(
                        child: Visibility(
                          visible: introFinished,
                          child: AnimatedSwitcher(
                            // reverseDuration: Duration(milliseconds: 1000),
                            duration: const Duration(milliseconds: 500),
                            child: _buildCurrentQuestion(),
                          ),
                          // child: SharedAxisSwitcher(
                          //   // reverseDuration: Duration(milliseconds: 1000),
                          //   // duration: const Duration(milliseconds: 1000),
                          //   child: _buildCurrentQuestion(),
                          // ),
                        ),
                      ))
                ],
              )),
          Positioned(
              top: 65,
              width: 255,
              height: 255,
              child: Visibility(
                visible: _questionIndex == 1 && kind != '',
                child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(kindImage), fit: BoxFit.cover))),
              )),
        ],
      ),
    );
  }

  Widget _introTitle() {
    final palette = context.watch<Palette>();

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 65, bottom: 15),
      height: 120,
      width: 345,
      decoration: BoxDecoration(
          color: palette.trueWhite,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: palette.black, width: 2)),
      child: AnimatedTextKit(
        animatedTexts: [
          TyperAnimatedText(dialogues[0],
              textStyle:
                  const TextStyle(fontFamily: "Inconsolata", fontSize: 20)),
        ],
        // isRepeatingAnimation: false,
        totalRepeatCount: 1,
        pause: const Duration(milliseconds: 2000),
        displayFullTextOnTap: true,
        stopPauseOnTap: true,
        onFinished: () {
          setState(() {
            introFinished = true;
          });
        },
      ),
    );
  }

  Widget _buildCurrentQuestion() {
    final palette = context.watch<Palette>();
    if (_questionIndex == 0) {
      return _buildNameInput(palette);
    } else if (_questionIndex == 1) {
      return _buildRiskProfileSelection(palette);
    } else if (_questionIndex == 2) {
      return _buildAgeInput(palette);
    } else if (_questionIndex == 3) {
      return _buildSipAmountInput(palette);
    } else if (_questionIndex == 4) {
      return _buildHorizonInput(palette);
    } else {
      return _buildFinalMessage(palette);
    }
  }

  Widget _buildNameInput(Palette palette) {
    return Column(
      key: const Key('1'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Text(
            _questions[_questionIndex],
            style: const TextStyle(fontSize: 30, fontFamily: 'Inconsolata'),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(40, 20, 40, 10),
          padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: palette.gray)),
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: "Your name",
            ),
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('name', _name);
              setState(() {
                _questionIndex++;
              });
            },
            child: const Text(
              'Next',
              style: TextStyle(fontSize: 18),
            ),
          ),
          // child: RoughButton(
          //   onTap: () async {
          //     SharedPreferences prefs = await SharedPreferences.getInstance();
          //     prefs.setString('name', _name);
          //     setState(() {
          //       _questionIndex++;
          //     });
          //   },
          //   child: const Text('Next'),
          // ),
        ),
      ],
    );
  }

  // Widget _buildRiskProfileSelection() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Container(
  //         padding: const EdgeInsets.only(left: 40, right: 40),
  //         child: Text(
  //           _questions[_questionIndex],
  //           style: const TextStyle(fontSize: 30, fontFamily: 'Inconsolata'),
  //         ),
  //       ),
  //       RadioListTile(
  //           title: const Text(
  //             'Are you brave and daring, ready to take on high-risk investments?',
  //             style: TextStyle(fontSize: 20, fontFamily: 'Inconsolata'),
  //           ),
  //           value: 'brave',
  //           groupValue: kind,
  //           onChanged: (value) {
  //             setState(() {
  //               _isDaring = true;
  //               kind = 'brave';
  //             });
  //           }),
  //       RadioListTile(
  //           title: const Text(
  //             'Or are you more cautious and methodical, sticking to lower-risk options?',
  //             style: TextStyle(fontSize: 20, fontFamily: 'Inconsolata'),
  //           ),
  //           value: 'cautious',
  //           groupValue: kind,
  //           onChanged: (value) {
  //             setState(() {
  //               _isDaring = false;
  //               kind = 'cautious';
  //             });
  //           }),
  //       ElevatedButton(
  //         onPressed: () async {
  //           SharedPreferences prefs = await SharedPreferences.getInstance();
  //           prefs.setBool('isDaring', _isDaring);
  //           setState(() {
  //             _questionIndex++;
  //           });
  //         },
  //         child: const Text('This is me!'),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildRiskProfileSelection(Palette palette) {
    return Container(
      key: const Key('2'),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _questions[_questionIndex],
            style: const TextStyle(fontSize: 30, fontFamily: 'Inconsolata'),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 20),
                child: Radio(
                    value: 'brave',
                    groupValue: kind,
                    onChanged: (value) {
                      setState(() {
                        _isDaring = true;
                        kind = 'brave';
                      });
                    }),
              ),
              Flexible(
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontFamily: 'Inconsolata',
                          fontSize: 20,
                          color: palette.ink),
                      children: const [
                        TextSpan(text: 'Are you '),
                        TextSpan(
                          text: 'brave',
                          style: TextStyle(
                              fontFamily: 'Permanent Marker',
                              fontSize: 20,
                              color: Color(0xffc13e49)),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'daring',
                          style: TextStyle(
                              fontFamily: 'Permanent Marker',
                              fontSize: 20,
                              color: Color(0xffc13e49)),
                        ),
                        TextSpan(
                            text: ', ready to take on high-risk investments?'),
                      ]),
                ),
              )
              // child: Text(
              //   'Are you brave and daring, ready to take on high-risk investments?',
              //   style: TextStyle(fontSize: 20, fontFamily: 'Inconsolata'),
              // ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 20),
                child: Radio(
                    value: 'cautious',
                    groupValue: kind,
                    onChanged: (value) {
                      setState(() {
                        _isDaring = false;
                        kind = 'cautious';
                      });
                    }),
              ),
              // const Flexible(
              //   child: Text(
              //     'Or are you more cautious and methodical, sticking to lower-risk options?',
              //     style: TextStyle(fontSize: 20, fontFamily: 'Inconsolata'),
              //   ),
              // ),
              Flexible(
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontFamily: 'Inconsolata',
                          fontSize: 20,
                          color: palette.ink),
                      children: const [
                        TextSpan(text: 'Or are you more '),
                        TextSpan(
                          text: 'cautious',
                          style: TextStyle(
                              fontFamily: 'Permanent Marker',
                              fontSize: 20,
                              color: Color(0xff2a6d43)),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'methodical',
                          style: TextStyle(
                              fontFamily: 'Permanent Marker',
                              fontSize: 20,
                              color: Color(0xff2a6d43)),
                        ),
                        TextSpan(text: ', sticking to lower-risk options?'),
                      ]),
                ),
              )
            ],
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('isDaring', _isDaring);
              setState(() {
                _questionIndex++;
              });
            },
            child: const Text('This is me!'),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeInput(Palette palette) {
    return Column(
      key: const Key('3'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Text(
            _questions[_questionIndex],
            style: const TextStyle(fontSize: 30, fontFamily: 'Inconsolata'),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(40, 20, 40, 10),
          padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: palette.gray)),
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: "Your age",
            ),
            onChanged: (value) {
              setState(() {
                _age = int.tryParse(value)!;
              });
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setInt('age', _age);
              setState(() {
                _questionIndex++;
              });
            },
            child: const Text(
              'Next',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSipAmountInput(Palette palette) {
    return Column(
      key: const Key('4'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          // child: Text(
          //   _questions[_questionIndex],
          //   style: const TextStyle(fontSize: 30, fontFamily: 'Inconsolata'),
          // )

          child: AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(_questions[_questionIndex],
                    textStyle: const TextStyle(
                        fontFamily: "Inconsolata", fontSize: 30)),
              ],
              // isRepeatingAnimation: false,
              totalRepeatCount: 1,
              // pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(40, 20, 40, 10),
          padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: palette.gray)),
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: "SIP amount",
            ),
            onChanged: (value) {
              setState(() {
                _sipAmount = int.tryParse(value)!;
              });
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setInt('sipAmount', _sipAmount);
              setState(() {
                _questionIndex++;
              });
            },
            child: const Text('Next'),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizonInput(Palette palette) {
    return Column(
      key: const Key('5'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(_questions[_questionIndex],
                    textStyle: const TextStyle(
                        fontFamily: "Inconsolata", fontSize: 30)),
              ],
              // isRepeatingAnimation: false,
              totalRepeatCount: 1,
              // pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(
              value: 'five',
              groupValue: radioVal,
              onChanged: (value) {
                setState(() {
                  radioVal = 'five';

                  _horizon = 5;
                });
              },
            ),
            const Text(
              '5+',
              style: TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 20,
              ),
            ),
            Radio(
              value: 'ten',
              groupValue: radioVal,
              onChanged: (value) {
                setState(() {
                  radioVal = 'ten';

                  _horizon = 10;
                });
              },
            ),
            const Text(
              '10+',
              style: TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 20,
              ),
            ),
            Radio(
              value: 'twenty',
              groupValue: radioVal,
              onChanged: (value) {
                setState(() {
                  radioVal = 'twenty';

                  _horizon = 20;
                });
              },
            ),
            const Text(
              '20+',
              style: TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 20,
              ),
            ),
            Radio(
              value: 'thirty',
              groupValue: radioVal,
              onChanged: (value) {
                setState(() {
                  radioVal = 'thirty';

                  _horizon = 30;
                });
              },
            ),
            const Text(
              '30+',
              style: TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 20,
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setInt('horizon', _horizon);
            setState(() {
              _questionIndex++;
            });
          },
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildFinalMessage(Palette palette) {
    final palette = context.watch<Palette>();

    return Container(
      padding: const EdgeInsets.all(8),
      height: 420,
      width: 345,
      decoration: BoxDecoration(
          color: palette.trueWhite,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: palette.black, width: 2)),
      child: AnimatedTextKit(
        animatedTexts: [
          TyperAnimatedText(dialogues[1],
              textStyle:
                  const TextStyle(fontFamily: "Inconsolata", fontSize: 20)),
        ],
        // isRepeatingAnimation: false,
        totalRepeatCount: 1,
        pause: const Duration(milliseconds: 5000),
        displayFullTextOnTap: true,
        stopPauseOnTap: true,
      ),
    );
  }
}
