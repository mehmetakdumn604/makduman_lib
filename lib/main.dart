import 'dart:math';

import 'package:flutter/material.dart';
import 'package:makduman_lib/core/extensions/future_extensions.dart';
import 'package:makduman_lib/mongo_db/mongo_db.dart';
import 'package:provider/provider.dart';

import 'core/extensions/context_extensions.dart';
import 'custom_widgets/loading_buttons/loading_button.dart';
import 'mongo_db/models/user_model.dart';
import 'providers/provider_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDbService.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ProviderData(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: context.width,
          height: context.height,
          child: Column(
            children: [
              LoadingButton(
                buttonTxt: Text(
                  "Giriş Yap",
                  style: context.textTheme.button?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                indicatorColor: Colors.white,
                width: 300,
                bgColor: Colors.purple,
                onPressed: () async {
                  await Future.delayed(const Duration(seconds: 5));
                },
                whenLoaded: (value) {
                  print(value);
                  //todo go to main page
                },
              ),
              const Expanded(
                child: FutureUserListView(),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MongoDbService.addUser();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class FutureUserListView extends StatelessWidget {
  const FutureUserListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MongoDbService.getUsers().toBuild<List<Map<String, dynamic>>>(
      onSuccess: (data) {
        return buildListview(data);
      },
    );
  }

  Future<FutureBuilder<List<Map<String, dynamic>>>> futurebuilder() async {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: MongoDbService.getUsers(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text("Hiç veri yok... Hemen yeni bir tane ekle"),
            );
          }

          return buildListview(snapshot.data!);
        });
  }

  ListView buildListview(List<Map<String, dynamic>> data) {
    List<UserModel> users = data.map((e) => UserModel.fromJson(e["_id"], e)).toList();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) {
        UserModel element = users[index];
        return ListTile(
          onTap: () async {
            await MongoDbService.updateUser(element);
          },
          onLongPress: () async {
            await MongoDbService.deleteUser(element);
          },
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text("${element.name} ${element.surname}"),
          trailing: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Center(
              child: Text(
                element.age.toString(),
                style: context.textTheme.headline5!.copyWith(),
              ),
            ),
          ),
        );
      },
    );
  }
}
