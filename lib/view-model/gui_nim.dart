import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gui_nim/model/nim_logic.dart';
import 'package:gui_nim/model/gamesettings.dart';

class GuiNim extends StatefulWidget {
  final GameSettings gameSettings;
  const GuiNim({
    super.key,
    required this.gameSettings,
  });

  @override
  State<GuiNim> createState() => _GuiNimState();
}

class _GuiNimState extends State<GuiNim> {
  List<bool> visibleItems = List<bool>.generate(0, (index) => true);
  Computador cpuPlayer = Computador(maxRetirar: 3);
  int qtdPalitos = 7;
  String nickname = 'Jogador';
  String cpuName = 'CPU';
  int _valueToHide = 1;
  int _cpuValueToHide = 1;
  bool _isCpuTurn = false;

  @override
  void initState() {
    qtdPalitos = widget.gameSettings.quantidadePalitos;
    nickname = widget.gameSettings.nickname;
    cpuName = widget.gameSettings.cpuName;
    visibleItems = List<bool>.generate(qtdPalitos, (index) => true);
    cpuPlayer.nickname = cpuName;
    resetGameAndVisibility();
    super.initState();
  }

  int getVisibleItemsCount() {
    return visibleItems.where((item) => item == true).length;
  }

  // Função para esconder dois itens
  void hideItems() {
    _isCpuTurn = false;
    int hiddenCount = 0;
    if (_valueToHide > getVisibleItemsCount()) {
      return;
    }
    for (int i = 0; i < visibleItems.length; i++) {
      if (visibleItems[i] && hiddenCount < _valueToHide) {
        visibleItems[i] = false;
        hiddenCount++;
      }
    }

    checkGameOver();
    if (getVisibleItemsCount() > 0) {
      cpuTurn();
    }
  }

  void hideCpuItems() {
    Get.closeCurrentSnackbar();
    int hiddenCount = 0;
    for (int i = 0; i < visibleItems.length; i++) {
      if (visibleItems[i] && hiddenCount < _cpuValueToHide) {
        visibleItems[i] = false;
        hiddenCount++;
      }
    }
    Get.snackbar('${cpuPlayer.nickname}', 'O CPU retirou $_cpuValueToHide',
        duration: const Duration(milliseconds: 1000),
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true,
        dismissDirection: DismissDirection.vertical,
        forwardAnimationCurve: Curves.elasticInOut,
        margin: const EdgeInsets.all(10),
        icon: const Icon(Icons.videogame_asset_rounded));
  }

  void cpuTurn() {
    int currentItems = getVisibleItemsCount();
    setState(() {
      _isCpuTurn = true;
      _cpuValueToHide =
          int.tryParse(cpuPlayer.jogar(currentItems).toString()) ?? 1;
      hideCpuItems();
    });
    checkGameOver();
    return;
  }

  // Função para restaurar todos os itens
  void resetGameAndVisibility() {
    setState(() {
      visibleItems = List<bool>.generate(qtdPalitos, (index) => true);
      _isCpuTurn = false;
      _cpuValueToHide = 1;
      _valueToHide = 1;
    });
    return;
  }

  void checkGameOver() async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (getVisibleItemsCount() == 0) {
      if (!_isCpuTurn) {
        Get.to(const LoserPage())?.then((_) {
          resetGameAndVisibility();
        });
      } else {
        Get.to(WinnerPage(nickname: nickname))?.then((_) {
          resetGameAndVisibility();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Center(
              child: Text(
            'N.I.M GAME',
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
          )),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                'https://images.pexels.com/photos/68543/match-matches-sticks-lighter-68543.jpeg?cs=srgb&dl=pexels-pixabay-68543.jpg&fm=jpg',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                    ),
                    itemCount: qtdPalitos,
                    itemBuilder: (context, index) {
                      return Visibility(
                        visible: visibleItems[index],
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: SizedBox(
                              height: 50,
                              width: 20,
                              child: Image(
                                  image: NetworkImage(
                                      'https://static.vecteezy.com/system/resources/previews/008/505/843/non_2x/burning-match-illustration-png.png'))),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 3),
                Expanded(
                  flex: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Wrap(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              _valueToHide == 1
                                  ? null
                                  : setState(() {
                                      _valueToHide--;
                                    });
                            },
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                _valueToHide.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              _valueToHide == 3
                                  ? null
                                  : setState(() {
                                      _valueToHide++;
                                    });
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _valueToHide > getVisibleItemsCount()
                                  ? null
                                  : hideItems();
                            },
                            child: const Text('RETIRAR'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WinnerPage extends StatelessWidget {
  final String nickname;
  const WinnerPage({super.key, required this.nickname});
  @override
  Widget build(BuildContext context) {
    int screenWidth = MediaQuery.of(Get.context!).size.width.toInt();
    int screenHeight = MediaQuery.of(Get.context!).size.height.toInt();
    return Stack(
      children: [
        Image.network(
          'https://i.imgur.com/ATI5M98.gif',
          width: screenWidth.toDouble(),
          height: screenHeight.toDouble(),
          fit: BoxFit.cover,
        ),
        Column(
          children: [
            Expanded(child: Center(child: Text('GANHOU, $nickname'))),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      maximumSize: WidgetStatePropertyAll(Size(250, 100)),
                      minimumSize: WidgetStatePropertyAll(Size(120, 50)),
                      textStyle: WidgetStatePropertyAll(TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins')),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('RECOMEÇAR O JOGO'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class LoserPage extends StatelessWidget {
  const LoserPage({super.key});

  @override
  Widget build(BuildContext context) {
    int screenWidth = MediaQuery.of(Get.context!).size.width.toInt();
    int screenHeight = MediaQuery.of(Get.context!).size.height.toInt();
    return Stack(
      children: [
        Image.network(
          'https://i.imgur.com/ATI5M98.gif',
          width: screenWidth.toDouble(),
          height: screenHeight.toDouble(),
          fit: BoxFit.cover,
        ),
        Column(
          children: [
            const Expanded(child: Center(child: Text('PERDEU'))),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      maximumSize: WidgetStatePropertyAll(Size(250, 100)),
                      minimumSize: WidgetStatePropertyAll(Size(120, 50)),
                      textStyle: WidgetStatePropertyAll(TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins')),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('RECOMEÇAR O JOGO'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
