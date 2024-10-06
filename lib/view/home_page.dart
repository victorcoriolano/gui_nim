import 'package:flutter/material.dart';
import 'package:gui_nim/model/gamesettings.dart';
import 'package:gui_nim/view-model/gui_nim.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameSettingsPage extends StatefulWidget {
  const GameSettingsPage({super.key});

  @override
  State<GameSettingsPage> createState() => _GameSettingsPageState();
}

class _GameSettingsPageState extends State<GameSettingsPage> {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  Future<void> setSelectedPalitos(int selectedPalitos) async {
    final prefs = await SharedPreferences.getInstance();
    _selectedPalitos = selectedPalitos;
    await prefs.setInt('selectedPalitos', selectedPalitos);
  }

  Future<void> setNickname(String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    _nickname = nickname;
    await prefs.setString('nickname', nickname);
  }

  Future<void> setCpuName(String cpuName) async {
    final prefs = await SharedPreferences.getInstance();
    _cpuName = cpuName;
    await prefs.setString('cpuName', cpuName);
  }

  Future<void> resetGameAndVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _selectedPalitos = 7;
      _nickname = '';
      _cpuName = '';
    });
  }

  Future<int> getSelectedPalitos() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedPalitos = prefs.getInt('selectedPalitos') ?? 7;
    return selectedPalitos;
  }

  Future<String> getNickname() async {
    final prefs = await SharedPreferences.getInstance();
    final nickname = prefs.getString('nickname') ?? '';
    return nickname;
  }

  Future<String> getCpuName() async {
    final prefs = await SharedPreferences.getInstance();
    final cpuName = prefs.getString('cpuName') ?? '';
    return cpuName;
  }

  @override
  void initState() {
    super.initState();
    getSelectedPalitos().then((value) {
      setState(() {
        _selectedPalitos = value;
      });
    });
    getNickname().then((value) {
      setState(() {
        _nickname = value;
      });
    });
    getCpuName().then((value) {
      setState(() {
        _cpuName = value;
      });
    });
  }

  // Definindo os valores iniciais
  int _selectedPalitos = 7; // Valor inicial da quantidade de palitos
  String _nickname = ''; // Nickname do jogador
  String _cpuName = '';

  // Definindo os controles de foco
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController cpuNameController = TextEditingController();
  final FocusNode nicknameFocusNode = FocusNode();
  final FocusNode cpuNameFocusNode = FocusNode();

  @override
  void dispose() {
    nicknameController.dispose();
    cpuNameController.dispose();
    nicknameFocusNode.dispose();
    cpuNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsividade baseada no tamanho da tela
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('N.I.M Game'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            child: Image.network(
              'https://p1.pxfuel.com/preview/992/549/179/match-fire-close-burn.jpg',
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.05,
                horizontal: screenWidth * 0.1,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container com título
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.05,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(192, 255, 205, 210),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'N.I.M!',
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  // DropdownButton para selecionar a quantidade de palitos
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quantidade de Palitos:',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      DropdownButton<int>(
                        dropdownColor: Colors.black,
                        focusColor: Colors.grey.shade600,
                        value: _selectedPalitos,
                        onChanged: (int? newValue) {
                          setState(() async {
                            await setSelectedPalitos(newValue!);
                          });
                        },
                        items: List<int>.generate(7, (index) => index + 7)
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value Palitos',
                                style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        icon: const Icon(Icons.arrow_drop_down),
                        isExpanded: true,
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // Campo de texto para o nickname do jogador
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Insira seu Nickname:',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      TextField(
                        controller: nicknameController,
                        focusNode: nicknameFocusNode,
                        keyboardType: TextInputType.name,
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          setState(() {
                            setNickname(value);
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nickname',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        textInputAction:
                            TextInputAction.next, // Define a ação de "próximo"
                        onSubmitted: (_) {
                          FocusScope.of(context).requestFocus(cpuNameFocusNode);
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Campo de texto para o nome do CPU
                      Text(
                        'Insira o nome do CPU:',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      TextField(
                          controller: cpuNameController,
                          focusNode: cpuNameFocusNode,
                          keyboardType: TextInputType.name,
                          onChanged: (value) {
                            setState(() {
                              setCpuName(value);
                            });
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(5),
                            labelText:
                                'Insira ou mude o nome do CPU (Opcional)',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          textInputAction: TextInputAction
                              .done, // Define a ação de "finalizar"
                          onSubmitted: (_) async {
                            if (nicknameController.text == '' ||
                                nicknameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Por favor, não insira nicknames vazios.'),
                                ),
                              );
                            } else if (nicknameController.text ==
                                cpuNameController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Por favor, não insira nicknames iguais.'),
                                ),
                              );
                            } else {
                              setState(() async {
                                _nickname = await getNickname();
                                _cpuName = await getCpuName();
                                _selectedPalitos = await getSelectedPalitos();
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GuiNim(
                                    gameSettings: GameSettings(
                                        quantidadePalitos: _selectedPalitos,
                                        nickname: _nickname,
                                        cpuName: _cpuName),
                                  ),
                                ),
                              );
                            }
                          }),
                      SizedBox(height: screenHeight * 0.05),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  // Botão para iniciar o jogo
                  SizedBox(
                    width: screenWidth * 0.6,
                    height: screenWidth * 0.09,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                          shape:
                              WidgetStatePropertyAll(RoundedRectangleBorder()),
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.redAccent),
                          overlayColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 255, 230, 230)),
                          shadowColor: WidgetStatePropertyAll(Colors.blue)),
                      onPressed: () {
                        // Lógica para iniciar o jogo, ex: navegar para outra página
                        if (nicknameController.text == '' ||
                            nicknameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Por favor, não insira nicknames vazios.'),
                            ),
                          );
                        } else if (nicknameController.text ==
                            cpuNameController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Por favor, não insira nicknames iguais.'),
                            ),
                          );
                        } else {
                          setState(() async {
                            _nickname = await getNickname();
                            _cpuName = await getCpuName();
                            _selectedPalitos = await getSelectedPalitos();
                            nicknameController.text = '';
                            cpuNameController.text = '';
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GuiNim(
                                gameSettings: GameSettings(
                                    quantidadePalitos: _selectedPalitos,
                                    nickname: _nickname,
                                    cpuName: _cpuName),
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Iniciar Jogo',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
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
    );
  }
}
