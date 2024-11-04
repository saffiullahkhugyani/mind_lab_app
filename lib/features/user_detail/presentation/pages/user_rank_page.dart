import 'package:flutter/material.dart';
import 'package:mind_lab_app/features/project_list/presentation/widgets/text_box.dart';

class UserRankPage extends StatefulWidget {
  const UserRankPage({super.key});

  @override
  State<UserRankPage> createState() => _UserRankPageState();
}

class _UserRankPageState extends State<UserRankPage> {
  @override
  Widget build(BuildContext context) {
    final argsUserImageUrl =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ranking"),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 10),
        children: [
          //profile picture

          const SizedBox(height: 50),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                argsUserImageUrl.isNotEmpty
                    ? Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(argsUserImageUrl),
                        ),
                      )
                    : Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ],
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage(
                                  'lib/assets/images/no-user-image.png')),
                        ),
                      ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  'My Ranking Details',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // MyTextbox(text: userInfo.id, sectionName: 'User ID'),
              MyTextbox(
                text: "2.com",
                sectionName: 'Type of Race:',
              ),
              MyTextbox(text: "1", sectionName: 'User Name:'),
              MyTextbox(text: "111", sectionName: 'Age Group:'),
              MyTextbox(text: "1", sectionName: 'Country Rank:'),
              MyTextbox(text: "111", sectionName: 'City Rank:'),
              MyTextbox(text: "1", sectionName: 'Best Time:'),
              MyTextbox(text: "111", sectionName: 'Top Speed :'),
              MyTextbox(text: "1", sectionName: 'Number of Races:'),
            ],
          ),
        ],
      ),
    );
  }
}
