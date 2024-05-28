import 'package:web/web.dart';

final isChrome =
    RegExp(r'(Chrome|Chromium)').hasMatch(window.navigator.userAgent);
final isSafari = RegExp(r'Safari').hasMatch(window.navigator.userAgent);
final isFirefox = RegExp(r'Firefox').hasMatch(window.navigator.userAgent);
final isOpera = RegExp(r'Opera').hasMatch(window.navigator.userAgent);
final isIE = RegExp(r'Trident').hasMatch(window.navigator.userAgent);

final isMobile = RegExp(r'Mobile').hasMatch(window.navigator.userAgent);
final isTablet = RegExp(r'Tablet').hasMatch(window.navigator.userAgent);
final isDesktop = !isMobile && !isTablet;

final isIOS = RegExp(r'iPhone|iPad|iPod').hasMatch(window.navigator.userAgent);
final isAndroid = RegExp(r'Android').hasMatch(window.navigator.userAgent);
final isWindows = RegExp(r'Windows').hasMatch(window.navigator.userAgent);
final isMacOS = RegExp(r'Mac OS').hasMatch(window.navigator.userAgent);
final isLinux = RegExp(r'Linux').hasMatch(window.navigator.userAgent);
