import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {
  final String lastUserId;
  const RankingPage({super.key, required this.lastUserId});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;
  bool lightMode = false;
  String get lastUserId => widget.lastUserId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            lightMode ? Colors.white : const Color.fromARGB(255, 51, 51, 51),
        appBar: AppBar(
          title: const Text('Ranking'),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: lightMode
                  ? const Icon(Icons.dark_mode_rounded)
                  : const Icon(Icons.light_mode_rounded),
              onPressed: () {
                setState(() {
                  lightMode = !lightMode;
                });
              },
            ),
          ],
        ),
        body: Center(
          child: Container(
              width: screenWidth * 0.6 - 50,
              height: screenHeight * 0.8 - 50,
              color: lightMode
                  ? const Color.fromARGB(255, 165, 165, 165)
                  : const Color.fromARGB(255, 0, 0, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text('Ranking Page (Top 5)',
                                  style: TextStyle(
                                      color: lightMode
                                          ? Colors.black
                                          : Colors.white)))
                        ]),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('ranking')
                            .orderBy('points', descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Algo deu errado');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: CircularProgressIndicator(
                                    color: lightMode
                                        ? Colors.black
                                        : const Color.fromARGB(
                                            255, 255, 252, 229)));
                          }

                          if (!snapshot.hasData) {
                            return const Center(
                                child: Text(
                                    'Comece a jogar para começar o placar!',
                                    style: TextStyle(color: Colors.white)));
                          }

                          //lightMode ? Colors.black : Colors.white
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length <= 5
                                  ? snapshot.data!.docs.length
                                  : 5, // Limit to 5 elements
                              itemBuilder: (context, index) {
                                final DocumentSnapshot document =
                                    snapshot.data!.docs[index];
                                final Map<String, dynamic> data =
                                    document.data() as Map<String, dynamic>;
                                if (data.isEmpty || data.values.isEmpty) {
                                  return const Center(
                                      child: Text(
                                          'Nenhuma pontuação encontrada!'));
                                }
                                return ListTile(
                                  title: Text(data['nickname'],
                                      style: TextStyle(
                                        decoration:
                                            lastUserId == data['nickname']
                                                ? TextDecoration.combine([
                                                    TextDecoration.overline,
                                                    TextDecoration.underline
                                                  ])
                                                : null,
                                        decorationColor: Colors.red,
                                        color: lightMode
                                            ? Colors.black
                                            : Colors.white,
                                      )),
                                  subtitle: Text('Pontos: ${data['points']}',
                                      style: TextStyle(
                                          color: lightMode
                                              ? Colors.black
                                              : Colors.white)),
                                );
                              });
                        },
                      ),
                    ),
                  ])),
        ));
  }
}
