import 'package:flutter/material.dart';
import 'package:gui_nim/model/gamesettings.dart';
import 'package:gui_nim/view-model/gui_nim.dart';

class GameSettingsPage extends StatefulWidget {
  const GameSettingsPage({super.key});

  @override
  State<GameSettingsPage> createState() => _GameSettingsPageState();
}

class _GameSettingsPageState extends State<GameSettingsPage> {
  int _selectedPalitos = 7; // Valor inicial da quantidade de palitos
  String _nickname = 'Jogador'; // Nickname do jogador
  String _cpuName = 'CPU';
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
      backgroundColor: Colors.red,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Imagem de fundo
            Positioned.fill(
              child: Image.network(
                'https://images.pexels.com/photos/68543/match-matches-sticks-lighter-68543.jpeg?cs=srgb&dl=pexels-pixabay-68543.jpg&fm=jpg',
                width: screenWidth,
                height: screenHeight,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
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
                      color: Colors.red.shade100,
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
                        ),
                      ),
                      DropdownButton<int>(
                        value: _selectedPalitos,
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedPalitos = newValue!;
                          });
                        },
                        items: List<int>.generate(7, (index) => index + 7)
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value Palitos'),
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
                        ),
                      ),
                      TextField(
                        controller: nicknameController,
                        focusNode: nicknameFocusNode,
                        onChanged: (value) {
                          setState(() {
                            _nickname = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nickname',
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
                        ),
                      ),
                      TextField(
                        controller: cpuNameController,
                        focusNode: cpuNameFocusNode,
                        onChanged: (value) {
                          setState(() {
                            _cpuName = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nome do CPU',
                        ),
                        textInputAction: TextInputAction
                            .done, // Define a ação de "finalizar"
                        onSubmitted: (_) {
                          setState(() {
                            _nickname = nicknameController.text;
                            _cpuName = cpuNameController.text;
                            _selectedPalitos = _selectedPalitos;
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
                        },
                      ),
                      SizedBox(height: screenHeight * 0.05),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  // Botão para iniciar o jogo
                  SizedBox(
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.08,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_nickname.isNotEmpty) {
                          // Lógica para iniciar o jogo, ex: navegar para outra página
                          setState(() {
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
                        } else {
                          // Mostrar um alerta se o nickname estiver vazio
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Por favor, insira um nickname.'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Iniciar Jogo',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder para a tela do jogo
class GamePage extends StatelessWidget {
  final int palitos;
  final String nickname;

  const GamePage({super.key, required this.palitos, required this.nickname});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N.I.M Game'),
      ),
      body: Center(
        child: Text(
          'Jogador: $nickname, Palitos: $palitos',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
