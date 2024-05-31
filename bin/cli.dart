void main(List<String?> args) {
    var command = args.first;
    var arg = args.last;

    switch(command) {
        case 'new':
            newProject(arg);
            break;
        case 'run':
            runProject();
            break;
        case 'build':
            buildProject();
            break;
        default:
            printHelp();
            break;
    }
}

Future<void> newProject(String projectName) {
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
  // Clone the template repository.
  // Replace 'https://github.com/your/template-repo.git' with the actual URL of the template repository.
  var result = await Process.run('git', ['clone', 'https://github.com/your/template-repo.git', projectName]);
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