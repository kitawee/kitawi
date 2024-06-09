import 'dart:io';

void main(List<String?> args) {
  String? command;
  List<String?> rest;

  try {
    command = args.first;
    rest = args.sublist(1);
  } catch (e) {
    printHelp();
    return;
  }

  switch (command) {
    case 'new':
      newProject(rest.isNotEmpty ? rest.first : null);
      break;
    case 'get':
      getPackages(rest);
      break;

    case 'run':
      runProject();
      break;
    case 'build':
      buildProject(rest);
      break;
    default:
      printHelp();
      break;
  }
}

Future<void> newProject(String? projectName) async {
  while (projectName == null) {
    print('Enter the project name:');
    projectName = stdin.readLineSync();
    if (projectName == null || projectName.isEmpty) {
      print('Please enter a valid project name.');
    }
  }

  // Check if Git is installed.
  if (!await _isGitInstalled()) {
    print('Error: Git is not installed.');
    return;
  }

  // Check if Dart is installed.
  if (!await _isDartInstalled()) {
    print('Error: Dart is not installed.');
    return;
  }
  // Create the project folder.
  var projectDir = Directory(projectName);
  if (await projectDir.exists()) {
    print('Error: A directory with the name "$projectName" already exists.');
    return;
  }
  await projectDir.create();

  var result = await Process.run('git',
      ['clone', 'https://github.com/bryanbill/view-template', projectName]);
  if (result.exitCode != 0) {
    print('Error: Failed to clone the template repository.');
    print(result.stderr);
    return;
  }
  // Clear the .git folder.
  var gitDir = Directory('$projectName/.git');
  if (await gitDir.exists()) {
    await gitDir.delete(recursive: true);
  }
  print('Project "$projectName" created successfully.');
}

Future<bool> _isGitInstalled() async {
  try {
    await Process.run('git', ['--version']);
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> _isDartInstalled() async {
  try {
    await Process.run('dart', ['--version']);
    return true;
  } catch (e) {
    return false;
  }
}

Future<void> getPackages(List<String?> args) async {
  if (args.isEmpty) {
    var result = await Process.run('dart', ['pub', 'get']);
    print(result.stdout);
    print(result.stderr);
    return;
  }

  var result =
      await Process.run('dart', ['pub', 'add', ...args as List<String>]);
  print(result.stdout);
  print(result.stderr);
}

Future<void> runProject() async {
  var result =
      await Process.run('dart', ['pub', 'global', 'activate', 'webdev']);
  print(result.stderr);

  //run the project
  var process = await Process.start(
    'webdev',
    [
      'serve',
      '--auto',
      'refresh',
      '--hostname',
      '0.0.0.0',
    ],
  );

  process.stdout.listen((event) {
    stdout.add(event);
  });

  process.stderr.listen((event) {
    stderr.add(event);
  });

  // Wait for the process to finish.
  await process.exitCode;

  // Stop the process when the user presses Enter.
  await stdin.first;
  process.kill();

  // Clear the line after the process is killed.
  stdout.write('\r');
  stdout.write(' ' * stdout.terminalColumns);

  // Print a message.
  print('Server stopped.');
}

Future<void> buildProject(List<String?> args) async {
  final options = args.where((element) => element!.startsWith('-')).toList();

  print(args);

  optionsLoop:
  for (var option in options) {
    switch (option) {
      case '-o':
        print("Building for production: JS and Wasm files will be generated.");

        String? directoryName;
        try {
          directoryName = args[args.indexOf(option) + 1];
        } catch (e) {
          throw Exception("Please provide a directory name.");
        }

        await _build(directoryName!);
        break;
      default:
        break optionsLoop;
    }
  }

  _build('build');
}

Future<void> _build(String directoryName) async {
  final directory = Directory(directoryName);
  if (!await directory.exists()) {
    await directory.create();
  }

  //wasm
  var result = await Process.run('dart', [
    'compile',
    'wasm',
    'web/main.dart',
    '-o',
    '${directory.path}/main.wasm'
  ]);

  print(result.stdout);
  print(result.stderr);

  //js
  var jsResult = await Process.run('dart',
      ['compile', 'js', 'web/main.dart', '-o', '${directory.path}/main.js']);

  print(jsResult.stdout);
  print(jsResult.stderr);

  // copy index.html, main.js, style.css and assets folder to directory
  await Process.run('cp', [
    'web/index.html',
    'web/styles.css',
    'web/bootstrap.js',
    '${directory.path}/',
  ]);

  await Process.run('cp', [
    '-r',
    'web/assets',
    '${directory.path}/',
  ]);

  print("Project built successfully.");
}

void printHelp() {
  print('''
  Usage: view <command> [arguments]

  Commands:
    new <project-name>    Create a new project.
    get [package-names]   Get packages.
    run                   Run the project.
    build                 Build the project.
  ''');
}
