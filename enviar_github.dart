import 'dart:io';

void main() async {
  print('=== Agente para enviar repositorio a GitHub ===\n');

  // 1. Pedir link del nuevo repositorio
  stdout.write('1. Ingresa el link del nuevo repositorio (ej: https://github.com/usuario/repo.git): ');
  String? repoUrl = stdin.readLineSync();

  if (repoUrl == null || repoUrl.trim().isEmpty) {
    print('Error: el link del repositorio no puede estar vacío.');
    exit(1);
  }

  // 2. Pedir mensaje de commit
  stdout.write('2. Ingresa el mensaje del commit: ');
  String? commitMsg = stdin.readLineSync();

  if (commitMsg == null || commitMsg.trim().isEmpty) {
    print('Error: el mensaje de commit no puede estar vacío.');
    exit(1);
  }

  // 3. Establecer nombre de la rama (main por default)
  stdout.write('3. Ingresa el nombre de la rama (presiona Enter para usar "main"): ');
  String? rama = stdin.readLineSync();

  if (rama == null || rama.trim().isEmpty) {
    rama = 'main';
  }

  print('\nConfiguración:');
  print('  Repositorio : $repoUrl');
  print('  Commit      : $commitMsg');
  print('  Rama        : $rama');
  print('\nEjecutando comandos Git...\n');

  // Ejecutar comandos git
  await _runCommand('git', ['init']);
  await _runCommand('git', ['add', '.']);
  await _runCommand('git', ['commit', '-m', commitMsg]);
  await _runCommand('git', ['branch', '-M', rama]);
  await _runCommand('git', ['remote', 'add', 'origin', repoUrl]);
  await _runCommand('git', ['push', '-u', 'origin', rama]);

  print('\n¡Repositorio enviado exitosamente a GitHub!');
}

Future<void> _runCommand(String command, List<String> args) async {
  print('> $command ${args.join(' ')}');
  final result = await Process.run(command, args);

  if (result.stdout.toString().isNotEmpty) {
    print(result.stdout);
  }
  if (result.stderr.toString().isNotEmpty) {
    print(result.stderr);
  }

  if (result.exitCode != 0) {
    print('Error al ejecutar: $command ${args.join(' ')}');
    exit(result.exitCode);
  }
}