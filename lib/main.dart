import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProviderScope(child: Home()),
    );
  }
}

final translateProvider =
    FutureProvider.autoDispose.family<String, String>((ref, word) {
  ref.watch(refreshSearch);
  return getTranslate(text: word);
});

final refreshSearch = StateProvider((ref) => 0);

Future<String> getTranslate({required String text}) async {
  await Future.delayed(const Duration(seconds: 1), () {});
  if (text.contains("1")) {
    return "1имя [персональное название] (اسم): 2:31, 2:33, 2:114…";
  }
  if (text.contains("3")) {
    return "2Аллах [нет чего-либо подобного Ему, см. 42:11. Однокоренное слово «Бог» указано в 2:133] (الله): 1:2, 2:7-2:10, 2:15, 2:17, 2:19, 2:20, 2:22, 2:23, 2:26-2:28, 2:55…";
  }
  return "";
}

class Home extends ConsumerStatefulWidget {
  @override
  ConsumerState<Home> createState() => _HomeState();
}

String text = "1:1 С именем1 Аллаха2, Милостивого3 Милосердного4.";

class _HomeState extends ConsumerState<Home> {
  String search = "";

  late OverlayEntry overlayEntry;
  List<Two> name = List.generate(text.split(" ").length,
      (index) => Two(title: text.split(" ")[index], enable: false));

  @override
  Widget build(BuildContext context) {
    final future = ref.watch(translateProvider(search));
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              SizedBox(height: 200),
              SafeArea(
                child: Wrap(
                  children: List.generate(
                      text.split(" ").length,
                      (index) => Stack(

                            clipBehavior: Clip.none,
                            children: [
                              Visibility(
                                visible: name[index].enable,
                                child: Positioned(
                                  top: -20,
                                  child: future.when(
                                      data: (data) => Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text("перевод $data"),
                                          )),
                                      error: (error, stack) => Text("$error"),
                                      loading: () => Padding(
                                            padding: EdgeInsets.only(
                                                left: text
                                                    .split(" ")[index]
                                                    .length
                                                    .toDouble()),
                                            child: Center(
                                              child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator()),
                                            ),
                                          )),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    print("показать");
                                    ref.read(refreshSearch.notifier).state++;

                                    setState(() {
                                      search = name[index].title;
                                      for (int i = 0; i < name.length; i++)
                                        name[i].enable = false;
                                      name[index].enable = true;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(text.split(" ")[index]),
                                  )),
                            ],
                          )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Two {
  String title;
  bool enable;

  Two({this.title = "", this.enable = false});
}
