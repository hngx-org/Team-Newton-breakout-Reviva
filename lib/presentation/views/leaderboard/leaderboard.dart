import 'package:flutter/material.dart';
import 'package:newton_breakout_revival/providers/leaderboard_provider.dart';
import 'package:provider/provider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboardProvider = Provider.of<LeaderboardProvider>(context);

    // List<Map<String, dynamic>> leaderboardData = [
    //   {
    //     'name': 'Phosah',
    //     'score': 100,
    //   },
    //   {
    //     'name': 'Sam',
    //     'score': 100,
    //   },
    //   {
    //     'name': 'David',
    //     'score': 100,
    //   },
    //   {
    //     'name': 'Alpha',
    //     'score': 100,
    //   },
    // ];

    return Material(
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/leaderboard-bg.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Expanded(
                    child: FutureBuilder(
                        future: leaderboardProvider.fetchLeaderboardData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(206, 255, 255, 255),
                              ),
                              child: Center(
                                  child: Text('Error: ${snapshot.error}')),
                            );
                          } else {
                            final leaderboardData = snapshot.data ?? [];
                            return ListView.builder(
                                itemCount: leaderboardData.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Container(
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              206, 255, 255, 255),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            leaderboardData[index]['name'],
                                            style: const TextStyle(
                                              fontFamily: 'Minecraft',
                                              fontSize: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Row(
                                              children: [
                                                Text(
                                                  ' ${leaderboardData[index]['score']}',
                                                  style: const TextStyle(
                                                    fontFamily: 'Minecraft',
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.star_outlined,
                                                  color: Colors.amber,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                        })),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
