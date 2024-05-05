import 'package:NonebotGUI/darts/utils.dart';
import 'package:NonebotGUI/ui/managecli.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:NonebotGUI/ui/stderr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ManageBot(),
    );
  }
}

class ManageBot extends StatefulWidget {
  const ManageBot({super.key});

  @override
  State<ManageBot> createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<ManageBot> {
  Timer? _timer;
  String _log = '[I]Welcome to Nonebot GUI!\n';
  final _filePath = '${manageBotReadCfgPath()}/nbgui_stdout.log';
  final _outputController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadFileContent();
    _startRefreshing();
  }

  void _startRefreshing() {
    _timer ??= Timer.periodic(
        const Duration(seconds: 1), (Timer t) => _loadFileContent());
  }

  void _loadFileContent() async {
    File stdoutfile = File(_filePath);
    if (stdoutfile.existsSync()) {
      try {
        final file = File(_filePath);
        final lines = await file.readAsLines();
        final last50Lines =
            lines.length > 50 ? lines.sublist(lines.length - 50) : lines;
        setState(() {
          _log = last50Lines.join('\n');
        });
      } catch (e) {
        print('Error reading file: $e');
      }
    }
  }

  //TODO: If this function is not used, shuld be not defined.
  void _executeCommands() async {
    _outputController.clear();

    List<String> commands = [''];

    for (String command in commands) {
      List<String> args = command.split(' ');

      String executable = args.removeAt(0);
      Process process = await Process.start(executable, args, runInShell: true);

      process.stdout.transform(systemEncoding.decoder).listen((data) {
        _outputController.text += data;
        _outputController.selection = TextSelection.fromPosition(
            TextPosition(offset: _outputController.text.length));
        setState(() {});
      });

      process.stderr.transform(systemEncoding.decoder).listen((data) {
        _outputController.text += data;
        _outputController.selection = TextSelection.fromPosition(
            TextPosition(offset: _outputController.text.length));
        setState(() {});
      });

      await process.exitCode;
    }
  }

  void _reloadConfig() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "${manageBotReadCfgName()}",
            style: const TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showConfirmationDialog(context),
              tooltip: "删除",
              color: Colors.white,
            )
          ],
          backgroundColor: const Color.fromRGBO(238, 109, 109, 1),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                margin: const EdgeInsets.all(4.0),
                child: Column(
                  children: <Widget>[
                    const Center(
                      child: Text(
                        'Bot信息',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '名称',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(manageBotReadCfgName().toString()),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '路径',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(manageBotReadCfgPath().toString()),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '创建时间',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(manageBotReadCfgTime().toString()),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '状态',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        if (manageBotReadCfgStatus().toString() == 'true')
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '运行中',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ),
                          ),
                        if (manageBotReadCfgStatus().toString() == 'false')
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '未运行',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '进程ID',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(manageBotReadCfgPid().toString()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                margin: const EdgeInsets.all(4.0),
                child: Column(
                  children: <Widget>[
                    const Center(
                        child: Text(
                      '操作',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            if (manageBotReadCfgStatus().toString() ==
                                'false') {
                              runBot(manageBotReadCfgPath());
                              _reloadConfig();
                              _startRefreshing();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    'Nonebot,启动！如果发现控制台无刷新请检查bot目录下的nbgui_stderr.log查看报错'),
                                duration: Duration(seconds: 3),
                              ));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Bot已经在运行中了！'),
                                duration: Duration(seconds: 3),
                              ));
                            }
                          },
                          tooltip: "运行",
                          icon: const Icon(Icons.play_arrow_rounded),
                          iconSize: 25,
                        ),
                        IconButton(
                          onPressed: () {
                            if (manageBotReadCfgStatus().toString() ==
                                'true') {
                              stopBot();
                              _reloadConfig();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Bot已停止'),
                                duration: Duration(seconds: 3),
                              ));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Bot未在运行！'),
                                duration: Duration(seconds: 3),
                              ));
                            }
                          },
                          tooltip: "停止",
                          icon: const Icon(Icons.stop_rounded),
                          iconSize: 25,
                        ),
                        IconButton(
                          onPressed: () {
                            if (manageBotReadCfgStatus().toString() ==
                                'true') {
                              stopBot();
                              runBot(manageBotReadCfgPath());
                              clearLog();
                              _reloadConfig();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Bot正在重启...'),
                                duration: Duration(seconds: 3),
                              ));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Bot未在运行！'),
                                duration: Duration(seconds: 3),
                              ));
                            }
                          },
                          tooltip: "重启",
                          icon: const Icon(Icons.refresh),
                          iconSize: 25,
                        ),
                        IconButton(
                          onPressed: () {
                            openFolder(manageBotReadCfgPath().toString());
                          },
                          tooltip: "打开文件夹",
                          icon: const Icon(Icons.folder),
                          iconSize: 25,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const ManageCli();
                            }));
                          },
                          tooltip: "管理CLI",
                          icon: const Icon(Icons.terminal_rounded),
                          iconSize: 25,
                        ),
                        IconButton(
                          onPressed: () {
                            clearLog();
                          },
                          tooltip: "清空日志",
                          icon: const Icon(Icons.delete_rounded),
                          iconSize: 25,
                        ),
                        Visibility(
                            visible: File(
                                    '${manageBotReadCfgPath()}/nbgui_stderr.log')
                                .readAsStringSync()
                                .isNotEmpty,
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const StdErr();
                                }));
                              },
                              tooltip: '查看报错日志',
                              icon: const Icon(Icons.error_rounded),
                              color: Colors.red,
                              iconSize: 25,
                            ))
                      ],
                    )
                  ],
                ),
              ),
              Card(
                margin: const EdgeInsets.all(4.0),
                child: Column(
                  children: <Widget>[
                    const Center(
                      child: Text(
                        '控制台输出',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    SizedBox(
                      height: 400,
                      width: 2000,
                      child: Card(
                        color: const Color.fromARGB(255, 31, 28, 28),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _log,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

void _showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('删除'),
        content: const Text('你确定要删除这个Bot吗？'),
        actions: <Widget>[
          TextButton(
            child: const Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              '确定',
              style: TextStyle(color: Color.fromRGBO(238, 109, 109, 1)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
              deleteBot();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Bot已删除'),
                duration: Duration(seconds: 3),
              ));
            },
          ),
          TextButton(
            child: const Text(
              '确定（连同bot目录一起删除）',
              style: TextStyle(color: Color.fromRGBO(255, 0, 0, 1)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
              deleteBotAll();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Bot已删除'),
                duration: Duration(seconds: 3),
              ));
            },
          ),
        ],
      );
    },
  );
}
