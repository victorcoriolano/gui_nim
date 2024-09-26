import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gui_nim/nim_logic.dart';

class GuiNim extends StatefulWidget {
  const GuiNim({super.key});

  @override
  State<GuiNim> createState() => _GuiNimState();
}

class _GuiNimState extends State<GuiNim> {
  // Lista que define se o item está visível ou não
  List<bool> visibleItems = List<bool>.generate(13, (index) => true);
  int _valueToHide = 1;
  int? _cpuValueToHide = 0;
  bool _isCpuTurn = false;
  Computador cpuPlayer = Computador(maxRetirar: 3);

  @override
  void initState() {
    resetVisibility();
    super.initState();
  }

  int getVisibleItemsCount() {
    return visibleItems.where((item) => item == true).length;
  }

  // Função para esconder dois itens
  void hideTwoItems() {
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
    if (getVisibleItemsCount() == 0) {
      Get.to(const LoserPage());
      return;
    }
    cpuTurn();
    return;
  }

  void hideCpuItems() {
    int hiddenCount = 0;
    if (_cpuValueToHide == null) {
      return;
    }
    if (_cpuValueToHide! - getVisibleItemsCount() == 0) {
      Get.to(const WinnerPage());
      return;
    }
    for (int i = 0; i < visibleItems.length; i++) {
      if (visibleItems[i] && hiddenCount < _cpuValueToHide!) {
        visibleItems[i] = false;
        hiddenCount++;
      }
    }
    Get.closeAllSnackbars();
    Get.snackbar('CPU', 'O CPU retirou $_cpuValueToHide',
        duration: const Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true,
        dismissDirection: DismissDirection.vertical,
        forwardAnimationCurve: Curves.easeOutBack,
        margin: const EdgeInsets.all(10),
        icon: const Icon(Icons.videogame_asset_rounded));
    return;
  }

  void cpuTurn() {
    int currentItems = getVisibleItemsCount();
    setState(() {
      _isCpuTurn = true;
      _cpuValueToHide = cpuPlayer.jogar(currentItems);
      hideCpuItems();
      _isCpuTurn = false;
    });
    if (getVisibleItemsCount() == 0) {
      Get.to(const WinnerPage());
    }
    return;
  }

  // Função para restaurar todos os itens
  void resetVisibility() {
    setState(() {
      visibleItems = List<bool>.generate(13, (index) => true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('N.I.M GAME')),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 600,
              width: 600,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 colunas
                ),
                itemCount: visibleItems.length,
                itemBuilder: (context, index) {
                  return Visibility(
                    visible: visibleItems[index], // Controla visibilidade
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _isCpuTurn
                    ? const CircularProgressIndicator()
                    : Wrap(
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
                              hideTwoItems();
                            },
                            child: const Text('RETIRAR'),
                          ),
                        ],
                      ),
              ],
            ),
            const SizedBox(height: 70),
            getVisibleItemsCount() == 0
                ? ElevatedButton(
                    onPressed: () {
                      resetVisibility();
                    },
                    child: const Text('RECOMEÇAR O JOGO'),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}

class WinnerPage extends StatelessWidget {
  const WinnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(child: Text('GANHOU')),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('RECOMEÇAR O JOGO'),
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
    return Column(
      children: [
        const Center(child: Text('PERDEU')),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('RECOMEÇAR O JOGO'),
            ),
          ],
        ),
      ],
    );
  }
}
