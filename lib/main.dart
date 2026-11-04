import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' show lerpDouble;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

void main() => runApp(const MAINavigatorApp());

/// Тема приложения: по умолчанию следует за системой, переключается кнопкой.
final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);

ThemeData _themeFor(Pal p) {
  final base = ThemeData(brightness: p.brightness, useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: p.bg.last,
    colorScheme: ColorScheme.fromSeed(seedColor: kMaiBlue, brightness: p.brightness)
        .copyWith(primary: p.accent, surface: p.sheet),
    textTheme: base.textTheme.apply(bodyColor: p.text, displayColor: p.text),
    iconTheme: IconThemeData(color: p.text),
  );
}

class MAINavigatorApp extends StatelessWidget {
  const MAINavigatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (_, mode, __) => MaterialApp(
        title: 'МАИ · Навигатор',
        debugShowCheckedModeBanner: false,
        theme: _themeFor(Pal.light),
        darkTheme: _themeFor(Pal.dark),
        themeMode: mode,
        home: const MapScreen(),
      ),
    );
  }
}

// ============================================================================
// ЦВЕТА МАИ И ТЕМЫ
// Фирменные цвета (mai.ru/press/brand): синий #0271FF, белый, графит #232323.
// Зелёный у выходов оставлен как у эвакуационных знаков.
// ============================================================================

const kMaiBlue = Color(0xFF0271FF);
const kMaiInk = Color(0xFF232323);

class _Style {
  final Color c1, c2, edge, text;
  const _Style(this.c1, this.c2, this.edge, this.text);
}

class Pal {
  final Brightness brightness;
  final List<Color> bg; // радиальный фон: центр → край
  final Color sheet, glass, glassBorder, shadow, field;
  final Color text, dim, faint;
  final Color accent, accentSoft;
  final Color start, end, exit;
  final Color side; // боковая грань комнат в 3D
  final Color corr1, corr2, corrDash;
  final List<Color> route;
  final Color routeGlow, markerFill;
  final _Style room, unn, stairs, wc, service, hall, big, cowork, startS, endS, foot;

  const Pal({
    required this.brightness,
    required this.bg,
    required this.sheet,
    required this.glass,
    required this.glassBorder,
    required this.shadow,
    required this.field,
    required this.text,
    required this.dim,
    required this.faint,
    required this.accent,
    required this.accentSoft,
    required this.start,
    required this.end,
    required this.exit,
    required this.side,
    required this.corr1,
    required this.corr2,
    required this.corrDash,
    required this.route,
    required this.routeGlow,
    required this.markerFill,
    required this.room,
    required this.unn,
    required this.stairs,
    required this.wc,
    required this.service,
    required this.hall,
    required this.big,
    required this.cowork,
    required this.startS,
    required this.endS,
    required this.foot,
  });

  static Pal of(BuildContext c) => Theme.of(c).brightness == Brightness.dark ? dark : light;
  bool get isDark => brightness == Brightness.dark;

  static const dark = Pal(
    brightness: Brightness.dark,
    bg: [Color(0xFF1B2433), Color(0xFF0F1218), Color(0xFF08090C)],
    sheet: Color(0xFF15181E),
    glass: Color(0xE61B1F26),
    glassBorder: Color(0x2AFFFFFF),
    shadow: Color(0xAA000000),
    field: Color(0xFF242933),
    text: Color(0xFFFFFFFF),
    dim: Color(0x99FFFFFF),
    faint: Color(0x61FFFFFF),
    accent: kMaiBlue,
    accentSoft: Color(0xFF6FB1FF),
    start: Color(0xFF3D9BFF),
    end: Color(0xFFFF8A3D),
    exit: Color(0xFF2BD47D),
    side: Color(0xFF05060A),
    corr1: Color(0xFF222833),
    corr2: Color(0xFF1B2029),
    corrDash: Color(0x40586A8C),
    route: [Color(0xFF7DC0FF), Color(0xFF3D9BFF), Color(0xFF0271FF)],
    routeGlow: kMaiBlue,
    markerFill: Color(0xFF0B2B5C),
    room: _Style(Color(0xFF2C323C), Color(0xFF232830), Color(0xFF454E5E), Color(0xFFE9EEF7)),
    unn: _Style(Color(0xFF23272F), Color(0xFF1C2027), Color(0xFF343B47), Color(0xFF8591A6)),
    stairs: _Style(Color(0xFF0F3F7E), Color(0xFF0A2F61), Color(0xFF2A6FCC), Color(0xFFC4E0FF)),
    wc: _Style(Color(0xFF124C4F), Color(0xFF0D3A3D), Color(0xFF2A8A8D), Color(0xFFA9F2EF)),
    service: _Style(Color(0xFF4D3C1C), Color(0xFF362A12), Color(0xFF8F7030), Color(0xFFFFD98F)),
    hall: _Style(Color(0xFF173F7A), Color(0xFF102F5C), Color(0xFF2F6CC4), Color(0xFFCFE3FF)),
    big: _Style(Color(0xFF1F242C), Color(0xFF171B21), Color(0xFF394150), Color(0xFF93A3BE)),
    cowork: _Style(Color(0xFF0B54C9), Color(0xFF083F9B), Color(0xFF4A9BFF), Color(0xFFEAF3FF)),
    startS: _Style(Color(0xFF0D4FAF), Color(0xFF093A83), Color(0xFF3D9BFF), Color(0xFFFFFFFF)),
    endS: _Style(Color(0xFF8A3B0C), Color(0xFF5E2807), Color(0xFFFF8A3D), Color(0xFFFFFFFF)),
    foot: _Style(Color(0xFF161A21), Color(0xFF11151B), Color(0xFF2A313C), Color(0xFFFFFFFF)),
  );

  static const light = Pal(
    brightness: Brightness.light,
    bg: [Color(0xFFFFFFFF), Color(0xFFEEF3FA), Color(0xFFDCE6F3)],
    sheet: Color(0xFFFFFFFF),
    glass: Color(0xF2FFFFFF),
    glassBorder: Color(0x1F0B2A5B),
    shadow: Color(0x33284A80),
    field: Color(0xFFEDF2FA),
    text: kMaiInk,
    dim: Color(0x99232323),
    faint: Color(0x66232323),
    accent: kMaiBlue,
    accentSoft: kMaiBlue,
    start: Color(0xFF0271FF),
    end: Color(0xFFE8620C),
    exit: Color(0xFF0E9F5B),
    side: Color(0xFFA9B8D0),
    corr1: Color(0xFFF6F9FD),
    corr2: Color(0xFFE9EFF8),
    corrDash: Color(0x558CA0C2),
    route: [Color(0xFF0271FF), Color(0xFF0158D0), Color(0xFF003C99)],
    routeGlow: kMaiBlue,
    markerFill: Color(0xFFFFFFFF),
    room: _Style(Color(0xFFFFFFFF), Color(0xFFF1F5FB), Color(0xFFB5C4DB), kMaiInk),
    unn: _Style(Color(0xFFF3F6FB), Color(0xFFE8EDF5), Color(0xFFC9D4E5), Color(0xFF6C7A93)),
    stairs: _Style(Color(0xFFD6E7FF), Color(0xFFC4DCFF), Color(0xFF5E9FF2), Color(0xFF0A4DA8)),
    wc: _Style(Color(0xFFD3F0EE), Color(0xFFBFE6E3), Color(0xFF5DBDB7), Color(0xFF0B6560)),
    service: _Style(Color(0xFFFFEFD0), Color(0xFFFFE2AC), Color(0xFFDDAE55), Color(0xFF7A5200)),
    hall: _Style(Color(0xFFCFE3FF), Color(0xFFBAD6FF), Color(0xFF4B93F0), Color(0xFF083A85)),
    big: _Style(Color(0xFFE7EEF9), Color(0xFFD9E4F4), Color(0xFFAEC0DD), Color(0xFF52668C)),
    cowork: _Style(Color(0xFFB9D6FF), Color(0xFFA3C7FF), Color(0xFF0271FF), Color(0xFF06316F)),
    startS: _Style(Color(0xFFCFE3FF), Color(0xFFB5D3FF), Color(0xFF0271FF), kMaiInk),
    endS: _Style(Color(0xFFFFDCC4), Color(0xFFFFC9A5), Color(0xFFE8620C), kMaiInk),
    foot: _Style(Color(0xFFE2E9F4), Color(0xFFD6DFEE), Color(0xFFB5C3DA), kMaiInk),
  );
}

// ============================================================================
// ДАННЫЕ КАРТЫ (координаты — в пикселях фото плана, ось Y вниз)
// ============================================================================

const Rect kWorld = Rect.fromLTRB(430, 80, 2075, 855);

/// Растяжение плана по вертикали (поперёк здания). На телефоне карта
/// ограничена длиной здания, а ширины экрана хватает с запасом — поэтому
/// комнаты делаем «глубже», и в них помещаются номера. 1.0 = как на плане.
const double kYStretch = 1.5;

/// Соотношение сторон карты с учётом растяжения.
final double kAspect = kWorld.width / (kWorld.height * kYStretch);
const double kHalf = 20;
const double kNorthTop = 478, kNorthBottom = 528;
const double kSouthTop = 568, kSouthBottom = 622;

/// Номера помещений, которых НЕТ на плане эвакуации (или они закрашены).
/// Впишите сюда реальные номера, и они появятся на карте и в поиске:
///   'n_mid': '107в',
const Map<String, String> kRoomNumbers = {};

/// УСЛОВНЫЕ номера для помещений, у которых на плане номера нет. Они подобраны
/// по соседям (суффикс буквы) и по пропускам в нумерации, поэтому могут не
/// совпадать с настоящими. В списке выбора помечены «номер условный».
/// Как только узнаете настоящий номер — впишите его в kRoomNumbers выше.
const Map<String, String> kProvisionalNumbers = {
  'n_mid': '107в', // между 107а и 107
  'n_vest': '101', // у холла, рядом с 103 (в нумерации нет 101)
  'n_104': '104а', // между 104 и 106
  's_notch': '121а', // левее 121
  's_blot': '112', // номер закрашен на плане; в нумерации нет 112
  'nw_top': '153а', // северный угол левого крыла
  'w_bot': '123а', // левое крыло, у санузла
  'e_w1': '142', // правое крыло, под 144
  'e_w2': '140',
  'e_n1': '152', // правое крыло, северо-восток
  'e_n2': '150',
  'e_n3': '148',
  'e_s1': '102а', // у кухни, над 102
  'e_s2': '136а', // под 136
  'e_s3': '136б',
};

/// Фото меню: нажатие на помещение открывает их в окне. Положите файлы в
/// assets/menu/ и добавьте в pubspec.yaml:
///   flutter:
///     assets:
///       - assets/menu/
/// Фото может быть несколько — они листаются свайпом.
const Map<String, List<String>> kMenuPhotos = {
  'cofe': ['assets/menu/cafe.jpg'],
  'dining': ['assets/menu/dining.jpg'],
};

enum PlaceKind { room, stairs, wc, service, exit, marker }

class Corridor {
  final String id;
  final bool horizontal;
  final double fixed, from, to, half;
  const Corridor(this.id, this.horizontal, this.fixed, this.from, this.to,
      [this.half = kHalf]);

  Rect get rect => horizontal
      ? Rect.fromLTRB(from, fixed - half, to, fixed + half)
      : Rect.fromLTRB(fixed - half, from, fixed + half, to);

  Offset at(double t) => horizontal ? Offset(t, fixed) : Offset(fixed, t);
}

const List<Corridor> kCorridors = [
  Corridor('H', true, 548, 470, 2045),
  Corridor('L', false, 549, 132, 835, 17),
  Corridor('R', false, 1960, 350, 843, 17.5),
  Corridor('E', false, 1290, 548, 745),
];

class Place {
  final String id, name, corridor;
  final String? label;
  final Rect? rect;
  final PlaceKind kind;
  final Offset? door;
  final bool provisional; // номер условный (подобран, а не взят с плана)
  const Place({
    required this.id,
    required this.name,
    required this.corridor,
    this.label,
    this.rect,
    this.kind = PlaceKind.room,
    this.door,
    this.provisional = false,
  });
  bool get unnumbered => id.startsWith('u_') && label == 'б/н';
}

String _lat(String s) =>
    s.replaceAll('а', 'a').replaceAll('б', 'b').replaceAll('в', 'v');

List<Place> buildPlaces() {
  final p = <Place>[];

  void rm(String n, double l, double t, double r, double b, String c,
      {String? dup, String? tag}) {
    p.add(Place(
      id: 'r_${_lat(n)}${dup == null ? '' : '_$dup'}',
      name: 'Ауд. $n${tag == null ? '' : ' ($tag)'}',
      label: n,
      rect: Rect.fromLTRB(l, t, r, b),
      corridor: c,
    ));
  }

  void un(String key, double l, double t, double r, double b, String c, String hint) {
    final real = kRoomNumbers[key];
    final n = real ?? kProvisionalNumbers[key];
    p.add(Place(
      id: 'u_$key',
      name: n == null
          ? 'Без номера · $hint'
          : real != null
              ? 'Ауд. $n'
              : 'Ауд. $n · номер условный ($hint)',
      label: n ?? 'б/н',
      rect: Rect.fromLTRB(l, t, r, b),
      corridor: c,
      provisional: real == null && n != null,
    ));
  }

  void sp(String id, String name, String label, double l, double t, double r,
      double b, String c, PlaceKind kind, {Offset? door}) {
    p.add(Place(
        id: id, name: name, label: label, rect: Rect.fromLTRB(l, t, r, b),
        corridor: c, kind: kind, door: door));
  }

  void ex(String id, String name, Offset door, String c) {
    p.add(Place(id: id, name: name, corridor: c, kind: PlaceKind.exit, door: door));
  }

  // Выходы
  ex('exit_main', 'Главный выход (юг)', const Offset(1290, 745), 'E');
  ex('exit_w', 'Аварийный выход (запад)', const Offset(470, 548), 'H');
  ex('exit_e', 'Аварийный выход (восток)', const Offset(2045, 548), 'H');

  // QR-точки: наклейки на стенах. Скан задаёт начало маршрута ровно здесь.
  // Содержимое QR = id точки (Запад-1 / Вход-1 / Восток-1).
  void qr(String id, String name, Offset at, String c) {
    p.add(Place(id: id, name: name, label: 'QR', corridor: c, kind: PlaceKind.marker, door: at));
  }

  qr('Запад-1', 'QR Запад-1', const Offset(519, 533), 'H');
  qr('Вход-1', 'QR Вход-1', const Offset(1323, 565), 'H');
  qr('Восток-1', 'QR Восток-1', const Offset(1981, 535), 'H');

  // Северный ряд главного коридора
  const nt = kNorthTop, nb = kNorthBottom;
  rm('119б', 627, nt, 663, nb, 'H');
  rm('119а', 663, nt, 698, nb, 'H');
  rm('119', 698, nt, 772, nb, 'H');
  rm('113', 772, nt, 845, nb, 'H', tag: 'зап.');
  rm('113', 845, nt, 885, nb, 'H', dup: '2', tag: 'вост.');
  rm('107б', 885, nt, 925, nb, 'H');
  rm('107а', 925, nt, 964, nb, 'H');
  un('n_mid', 964, nt, 1004, nb, 'H', 'между 107а и 107');
  rm('107', 1004, nt, 1044, nb, 'H');
  rm('105', 1044, nt, 1082, nb, 'H');
  rm('103', 1082, nt, 1122, nb, 'H');
  sp('hall', 'Главный холл', 'ХОЛЛ', 1122, 478, 1432, nb, 'H', PlaceKind.service,
      door: const Offset(1290, nb));
  sp('hall_big', 'Большая аудитория (амфитеатр)', 'АМФИТЕАТР', 1122, 80, 1432,
      478, 'H', PlaceKind.room, door: const Offset(1290, 470));
  rm('104', 1432, nt, 1475, nb, 'H');
  un('n_104', 1475, nt, 1507, nb, 'H', 'между 104 и 106');
  rm('106', 1507, nt, 1543, nb, 'H');
  rm('108', 1543, nt, 1581, nb, 'H');
  rm('110', 1581, nt, 1649, nb, 'H', tag: 'зап.');
  rm('110', 1649, nt, 1686, nb, 'H', dup: '2', tag: 'вост.');
  rm('126', 1686, nt, 1724, nb, 'H');
  rm('126', 1724, nt, 1759, nb, 'H');
  rm('130', 1759, nt, 1791, nb, 'H', tag: 'зап.');
  rm('130', 1791, nt, 1826, nb, 'H', dup: '2', tag: 'вост.');
  rm('132', 1826, nt, 1864, nb, 'H');
  rm('132а', 1864, 505, 1920, nb, 'H');
  sp('wc_w', 'Санузел (запад)', 'WC', 476, 480, 532, nb, 'H', PlaceKind.wc);
  sp('wc_e', 'Санузел (восток)', 'WC', 1980, 482, 2037, 540, 'H', PlaceKind.wc);

  // Южный ряд главного коридора
  const st = kSouthTop, sb = kSouthBottom;
  un('s_notch', 626, st, 709, sb, 'H', 'левее 121');
  rm('121', 709, st, 747, sb, 'H');
  rm('115', 747, st, 822, sb, 'H');
  rm('111', 822, st, 927, sb, 'H');
  rm('109', 927, st, 1076, sb, 'H');
  rm('109а', 1076, st, 1120, sb, 'H');
  sp('st_c_w', 'Лестница (центр, запад)', 'ЛЕСТН.', 1120, st, 1215, sb, 'H', PlaceKind.stairs); // от 109а до коворкинга
  sp('cofe', 'кофейня', 'КОФЕЙНЯ', 1362, st, 1409, sb, 'H', PlaceKind.service);
  sp('st_c_e', 'Лестница (центр, восток)', 'ЛЕСТН.', 1409, st, 1444, sb, 'H', PlaceKind.stairs);
  rm('114б', 1444, st, 1518, sb, 'H');
  rm('114', 1518, st, 1554, sb, 'H', tag: '1');
  rm('114', 1554, st, 1592, sb, 'H', dup: '2', tag: '2');
  rm('114', 1592, st, 1631, sb, 'H', dup: '3', tag: '3');
  rm('118', 1631, st, 1673, sb, 'H');
  rm('120', 1673, st, 1712, sb, 'H');
  rm('124', 1712, st, 1785, sb, 'H');
  rm('124а', 1785, st, 1817, sb, 'H');
  rm('134', 1817, st, 1864, sb, 'H');
  rm('134б', 1864, st, 1945, sb, 'H');

  // Вход
  sp('cowork', 'Коворкинг', 'КОВОРКИНГ', 1215, 568, 1365, 745, 'E', PlaceKind.service,
      door: const Offset(1290, 656));

  // Левое крыло, север (коридор L)
  sp('st_nw', 'Лестница (северо-запад)', 'ЛЕСТН.', 566, 82, 620, 132, 'L',
      PlaceKind.stairs, door: const Offset(549, 132));
  un('nw_top', 476, 107, 532, 133, 'L', 'левое крыло, северный угол');
  rm('153', 476, 133, 532, 203, 'L');
  rm('137', 476, 203, 532, 272, 'L');
  rm('129а', 476, 272, 532, 305, 'L');
  rm('129', 476, 305, 532, 338, 'L');
  rm('127', 476, 338, 532, 405, 'L');
  rm('123', 476, 405, 532, 438, 'L');
  un('w_bot', 476, 438, 532, 480, 'L', 'левое крыло, у санузла');
  rm('155', 566, 137, 626, 187, 'L', tag: 'север');
  rm('155', 566, 187, 626, 237, 'L', dup: '2', tag: 'центр');
  rm('155', 566, 237, 626, 270, 'L', dup: '3', tag: 'юг');
  rm('135а', 566, 270, 626, 302, 'L');
  rm('135', 566, 302, 626, 338, 'L');
  rm('133', 566, 338, 626, 375, 'L');
  rm('133а', 566, 375, 626, 407, 'L');
  rm('131', 566, 407, 626, 478, 'L');
  sp('st_w', 'Лестница (запад, у 119б)', 'ЛЕСТН.', 566, 478, 626, 528, 'L', PlaceKind.stairs);

  // Левое крыло, юг
  rm('141', 476, 568, 532, 657, 'L');
  rm('143', 476, 657, 532, 748, 'L');
  rm('145', 476, 748, 532, 855, 'L');
  rm('139', 566, 568, 626, 660, 'L');
  rm('151в', 566, 660, 626, 698, 'L');
  rm('151б', 566, 698, 626, 730, 'L');
  rm('151а', 566, 747, 626, 783, 'L');
  rm('147', 566, 783, 626, 813, 'L');
  sp('st_sw', 'Лестница (юго-запад)', 'ЛЕСТН.', 566, 815, 626, 855, 'L', PlaceKind.stairs);

  // Правое крыло
  rm('146', 1887, 350, 1943, 380, 'R');
  rm('144', 1887, 380, 1943, 412, 'R');
  un('e_w1', 1887, 412, 1943, 445, 'R', 'правое крыло, запад 1');
  un('e_w2', 1887, 445, 1943, 478, 'R', 'правое крыло, запад 2');
  un('e_n1', 1978, 350, 2038, 393, 'R', 'правое крыло, северо-восток 1');
  un('e_n2', 1978, 393, 2038, 438, 'R', 'правое крыло, северо-восток 2');
  un('e_n3', 1979, 438, 2038, 482, 'R', 'правое крыло, северо-восток 3');
  sp('dining', 'Обеденный зал', 'ОБЕДЕННЫЙ ЗАЛ', 1945, 568, 2038, 667, 'R',
      PlaceKind.service, door: const Offset(1960, 617));
  sp('kitchen1', 'Кухня (1)', 'КУХНЯ', 1975, 667, 2038, 687, 'R', PlaceKind.service);
  sp('kitchen2', 'Кухня (2)', 'КУХНЯ', 1975, 688, 2038, 708, 'R', PlaceKind.service);
  un('e_s1', 1975, 708, 2038, 760, 'R', 'правое крыло, у кухни');
  rm('136', 1887, 622, 1942, 760, 'R');
  un('e_s2', 1887, 760, 1942, 791, 'R', 'правое крыло, юг 1');
  un('e_s3', 1887, 791, 1942, 823, 'R', 'правое крыло, юг 2');
  sp('st_se', 'Лестница (юго-восток)', 'ЛЕСТН.', 1890, 823, 1942, 855, 'R', PlaceKind.stairs);
  sp('st_ne', 'Лестница (северо-восток)', 'ЛЕСТН.', 1864, 478, 1920, 505, 'H', PlaceKind.stairs);
  rm('102', 1975, 760, 2038, 855, 'R');

  return p;
}

class Block {
  final Rect rect;
  final String? label;
  const Block(this.rect, [this.label]);
}

/// Мелкие помещения без номера: рисуются, но в маршрутах не участвуют.
const List<Block> kBlocks = [
  Block(Rect.fromLTRB(1060, 335, 1122, 390)),
  Block(Rect.fromLTRB(566, 730, 626, 747)),
  Block(Rect.fromLTRB(1817, 568, 1834, 622)),
  Block(Rect.fromLTRB(1980, 482, 2003, 540)),
  Block(Rect.fromLTRB(1897, 568, 1912, 628)),
];

/// Контуры зданий: закрашивают просветы между комнатами.
const List<Rect> kFootprints = [
  Rect.fromLTRB(476, 98, 626, 478),
  Rect.fromLTRB(476, 568, 626, 848),
  Rect.fromLTRB(626, 478, 1920, 528),
  Rect.fromLTRB(631, 568, 1896, 628),
  Rect.fromLTRB(1887, 345, 2040, 477),
  Rect.fromLTRB(1865, 477, 2040, 540),
  Rect.fromLTRB(1887, 565, 2032, 850),
];

// ============================================================================
// ГРАФ МАРШРУТОВ
// ============================================================================

class MapEdge {
  final String startId, endId;
  final double weight;
  const MapEdge(this.startId, this.endId, [this.weight = 1.0]);
}

class FloorGraph {
  final Map<String, Place> places = {};
  final Map<String, Offset> pos = {};
  final Map<String, List<MapEdge>> adj = {};

  FloorGraph(List<Place> list, List<Corridor> cs, [List<Block> blocks = const []]) {
    final corridors = {for (final c in cs) c.id: c};
    final pts = {
      for (final c in cs) c.id: <Offset>[c.at(c.from), c.at(c.to)],
    };
    for (final h in cs.where((c) => c.horizontal)) {
      for (final v in cs.where((c) => !c.horizontal)) {
        final pt = Offset(v.fixed, h.fixed);
        if (pt.dx >= h.from && pt.dx <= h.to && pt.dy >= v.from && pt.dy <= v.to) {
          pts[h.id]!.add(pt);
          pts[v.id]!.add(pt);
        }
      }
    }
    for (final pl in list) {
      places[pl.id] = pl;
      var c = corridors[pl.corridor]!;
      var door = pl.door ?? _doorOf(pl.rect!, c);
      var proj = c.horizontal ? Offset(door.dx, c.fixed) : Offset(c.fixed, door.dy);
      if (pl.door == null && pl.rect != null) {
        // дверь выбирается так, чтобы путь к коридору не шёл сквозь другие помещения
        final f = _freeDoor(pl, list, blocks, cs, c);
        if (f != null) {
          door = f.door;
          proj = f.proj;
          c = f.corridor;
        }
      }
      pos[pl.id] = door;
      pts[c.id]!.add(proj);
      _node(proj);
      _link(pl.id, _key(proj), (door - proj).distance);
    }
    for (final c in cs) {
      final l = pts[c.id]!
        ..sort((a, b) => (c.horizontal ? a.dx : a.dy).compareTo(c.horizontal ? b.dx : b.dy));
      for (int i = 0; i < l.length - 1; i++) {
        final a = l[i], b = l[i + 1];
        if (_key(a) == _key(b)) continue;
        _node(a);
        _node(b);
        _link(_key(a), _key(b), (a - b).distance);
      }
    }
  }

  static bool _segHits(Offset a, Offset b, Rect r) {
    var t0 = 0.0, t1 = 1.0;
    final dx = b.dx - a.dx, dy = b.dy - a.dy;
    bool clip(double p, double q) {
      if (p == 0) return q >= 0;
      final t = q / p;
      if (p < 0) {
        if (t > t1) return false;
        if (t > t0) t0 = t;
      } else {
        if (t < t0) return false;
        if (t < t1) t1 = t;
      }
      return true;
    }

    return clip(-dx, a.dx - r.left) &&
        clip(dx, r.right - a.dx) &&
        clip(-dy, a.dy - r.top) &&
        clip(dy, r.bottom - a.dy);
  }

  /// Лучшая дверь помещения: точка на его границе и проекция на коридор,
  /// отрезок между ними не пересекает чужие помещения и блоки.
  static ({Offset door, Offset proj, Corridor corridor})? _freeDoor(
      Place pl, List<Place> list, List<Block> blocks, List<Corridor> cs, Corridor own) {
    final r = pl.rect!;
    final obs = <Rect>[];
    bool overlapsSelf(Rect o) {
      final i = o.intersect(r);
      if (i.isEmpty) return false;
      return i.width * i.height > 0.3 * math.min(o.width * o.height, r.width * r.height);
    }

    for (final o in list) {
      if (o.id == pl.id || o.rect == null || o.kind == PlaceKind.marker) continue;
      if (overlapsSelf(o.rect!)) continue;
      obs.add(o.rect!.deflate(1.5));
    }
    for (final b in blocks) {
      if (!overlapsSelf(b.rect)) obs.add(b.rect.deflate(1.5));
    }
    final doors = <Offset>[];
    for (final k in const [0.5, 0.25, 0.75]) {
      final x = r.left + r.width * k, y = r.top + r.height * k;
      doors.addAll([Offset(x, r.top), Offset(x, r.bottom), Offset(r.left, y), Offset(r.right, y)]);
    }
    ({Offset door, Offset proj, Corridor corridor})? best;
    var bestCost = double.infinity;
    for (final c in cs) {
      final pen = c.id == own.id ? 0.0 : 40.0;
      for (final d in doors) {
        final proj = c.horizontal
            ? Offset(d.dx.clamp(c.from, c.to).toDouble(), c.fixed)
            : Offset(c.fixed, d.dy.clamp(c.from, c.to).toDouble());
        final cost = (d - proj).distance + pen;
        if (cost >= bestCost) continue;
        var hit = false;
        for (final o in obs) {
          if (_segHits(d, proj, o)) {
            hit = true;
            break;
          }
        }
        if (!hit) {
          bestCost = cost;
          best = (door: d, proj: proj, corridor: c);
        }
      }
    }
    return best;
  }

  static Offset _doorOf(Rect r, Corridor c) {
    if (c.horizontal) {
      return r.bottom <= c.fixed ? Offset(r.center.dx, r.bottom) : Offset(r.center.dx, r.top);
    }
    return r.right <= c.fixed ? Offset(r.right, r.center.dy) : Offset(r.left, r.center.dy);
  }

  String _key(Offset o) => 'c_${o.dx.round()}_${o.dy.round()}';
  void _node(Offset o) => pos[_key(o)] = o;
  void _link(String a, String b, double w) {
    adj.putIfAbsent(a, () => []).add(MapEdge(a, b, w));
    adj.putIfAbsent(b, () => []).add(MapEdge(b, a, w));
  }

  List<String> route(String from, String to) {
    final dist = <String, double>{for (final k in pos.keys) k: double.infinity};
    final prev = <String, String?>{};
    final open = <String>{...pos.keys};
    dist[from] = 0;
    while (open.isNotEmpty) {
      String? cur;
      for (final id in open) {
        if (cur == null || dist[id]! < dist[cur]!) cur = id;
      }
      if (cur == null || dist[cur]!.isInfinite) break;
      open.remove(cur);
      if (cur == to) break;
      for (final e in adj[cur] ?? const <MapEdge>[]) {
        final alt = dist[cur]! + e.weight;
        if (alt < dist[e.endId]!) {
          dist[e.endId] = alt;
          prev[e.endId] = cur;
        }
      }
    }
    if (dist[to]!.isInfinite) return [];
    final path = <String>[];
    String? c = to;
    while (c != null) {
      path.add(c);
      c = prev[c];
    }
    return path.reversed.toList();
  }

  Offset centerOf(String id) => places[id]?.rect?.center ?? pos[id]!;
}

// ============================================================================
// ЭТАЖИ 2–4
// Планы верхних этажей сняты с фото планов эвакуации. Корпус на всех этажах
// один и тот же, поэтому коридоры, лестницы и санузлы лежат в тех же мировых
// координатах, что и на 1 этаже. Комнаты заданы в пикселях фото плана
// (подпись + центр на фото) и пересчитываются в мировые координаты классом
// _Photo. Границы соседних комнат — середины между центрами подписей.
// Если комната на карте сдвинута — правьте центры в списках _Sp(...) ниже.
// _Sp(null, x) — помещение без номера (рисуется, но в маршрутах не участвует).
// ============================================================================

final List<Corridor> kUpperCorridors = const [
  Corridor('H', true, 548, 470, 2045),
  Corridor('L', false, 549, 132, 835, 17),
  Corridor('R', false, 1960, 350, 843, 17.5),
];

class FloorData {
  final int number;
  final List<Corridor> corridors;
  final List<Place> places;
  final List<Block> blocks;
  final List<Rect> footprints;
  final String defaultStart, defaultEnd;
  late final FloorGraph graph = FloorGraph(places, corridors, blocks);
  /// Контур корпуса по периметру помещений (в мировых координатах).
  late final Path outline = _buildOutline(this);
  FloorData({
    required this.number,
    required this.corridors,
    required this.places,
    required this.blocks,
    required this.footprints,
    required this.defaultStart,
    required this.defaultEnd,
  });
}

/// Привязка фото плана к мировым координатам: по двум коридорам крыльев
/// (масштаб по X), высоте главного коридора (с поправкой на наклон фото)
/// и торцам крыльев (масштаб по Y вдоль крыла).
class _Photo {
  final double lx, rx; // X коридоров левого и правого крыла на фото
  final double hyL, hyR; // Y главного коридора у левого и правого края
  final double rowN; // Y верха северного ряда относительно коридора (<0)
  final double topL, botL, topR, botR; // торцы крыльев на фото
  const _Photo(this.lx, this.rx, this.hyL, this.hyR, this.rowN, this.topL,
      this.botL, this.topR, this.botR);

  double get sx => (1960 - 549) / (rx - lx);
  double wx(double px) => 549 + (px - lx) * sx;
  double px(double w) => lx + (w - 549) / sx;
  double yN(bool left) => (left ? hyL : hyR) + rowN; // низ северной части крыла
  double yS(bool left) => (left ? hyL : hyR) - rowN * 0.42; // верх южной части
  double top(bool left) => left ? topL : topR;
  double bot(bool left) => left ? botL : botR;

  double wy(bool left, double py) {
    final k = [top(left), yN(left), yS(left), bot(left)];
    final w = left ? const [82.0, 478.0, 568.0, 855.0] : const [345.0, 478.0, 568.0, 855.0];
    final i = py <= k[1] ? 0 : (py <= k[2] ? 1 : 2);
    final v = w[i] + (py - k[i]) * (w[i + 1] - w[i]) / (k[i + 1] - k[i]);
    return v.clamp(w.first, w.last).toDouble();
  }
}

class _Sp {
  final String? label;
  final double l, r; // границы на фото (X для рядов, Y для колонок)
  const _Sp(this.label, this.l, this.r);
}

class _FloorBuilder {
  final int n;
  final _Photo ph;
  final List<Place> places = [];
  final List<Block> blocks = [];
  final Map<String, int> _seen = {};
  _FloorBuilder(this.n, this.ph);

  void _room(String label, Rect r, String corridor) {
    final k = (_seen[label] ?? 0) + 1;
    _seen[label] = k;
    places.add(Place(
      id: 'r_${_lat(label)}${k == 1 ? '' : '_$k'}',
      name: 'Ауд. $label${k == 1 ? '' : ' ($k)'}',
      label: label,
      rect: r,
      corridor: corridor,
    ));
  }

  /// Ряд комнат вдоль главного коридора: границы — реальные стены с фото.
  void row(bool north, List<_Sp> items) {
    for (final it in items) {
      var l = ph.wx(it.l), r = ph.wx(it.r);
      var t = north ? kNorthTop : kSouthTop;
      final b = north ? kNorthBottom : kSouthBottom;
      if (north && r > 1860) {
        r = 1920; // последняя комната северного ряда — под лестницей
        t = 505;
      }
      final rect = Rect.fromLTRB(l, t, r, b);
      final lb = it.label;
      if (lb == null) {
        blocks.add(Block(rect));
      } else {
        _room(lb, rect, 'H');
      }
    }
  }

  /// Колонка комнат в крыле. minT/maxB — ограничения (мировые), чтобы не наезжать на лестницы.
  void col(bool left, bool west, List<_Sp> items, {double? minT, double? maxB}) {
    final xl = left ? (west ? 476.0 : 566.0) : (west ? 1887.0 : 1978.0);
    final xr = left ? (west ? 532.0 : 626.0) : (west ? 1943.0 : 2038.0);
    for (final it in items) {
      var t = ph.wy(left, it.l), b = ph.wy(left, it.r);
      if (minT != null) t = math.max(t, minT);
      if (maxB != null) b = math.min(b, maxB);
      if (b - t < 5) continue;
      final rect = Rect.fromLTRB(xl, t, xr, b);
      final lb = it.label;
      if (lb == null) {
        blocks.add(Block(rect));
      } else {
        _room(lb, rect, left ? 'L' : 'R');
      }
    }
  }

  void _sp(String id, String name, String label, double l, double t, double r,
      double b, String c, PlaceKind kind, {Offset? door}) {
    places.add(Place(
        id: id, name: name, label: label, rect: Rect.fromLTRB(l, t, r, b),
        corridor: c, kind: kind, door: door));
  }

  /// Лестничные клетки, санузлы и QR-точки: одинаковы на всех этажах.
  void common({bool stWHalf = false}) {
    _sp('st_nw', 'Лестница (северо-запад)', 'ЛЕСТН.', 566, 82, 620, 132, 'L',
        PlaceKind.stairs, door: const Offset(549, 132));
    _sp('st_w', 'Лестница (запад)', 'ЛЕСТН.', 566, 478, 626, stWHalf ? 503 : 528,
        'L', PlaceKind.stairs);
    if (stWHalf) _room('239', const Rect.fromLTRB(566, 503, 626, 528), 'L');
    _sp('st_c_w', 'Лестница (центр, запад)', 'ЛЕСТН.', 1141, kSouthTop, 1187,
        kSouthBottom, 'H', PlaceKind.stairs);
    _sp('st_c_e', 'Лестница (центр, восток)', 'ЛЕСТН.', 1362, kSouthTop, 1409,
        kSouthBottom, 'H', PlaceKind.stairs);
    _sp('st_ne', 'Лестница (северо-восток)', 'ЛЕСТН.', 1850, 478, 1920, 505, 'H',
        PlaceKind.stairs);
    _sp('st_se', 'Лестница (юго-восток)', 'ЛЕСТН.', 1890, 823, 1942, 856, 'R',
        PlaceKind.stairs);
    _sp('wc_w', 'Санузел (запад)', 'WC', 476, 479, 532, kNorthBottom, 'H', PlaceKind.wc);
    _sp('wc_e', 'Санузел (восток)', 'WC', 1979, 478, 2037, 540, 'H', PlaceKind.wc);
    _sp('st_sw', 'Лестница (юго-запад)', 'ЛЕСТН.', 566, 815, 626, 855, 'L', PlaceKind.stairs);
    void qr(String id, String name, Offset at) {
      places.add(Place(id: id, name: name, label: 'QR', corridor: 'H',
          kind: PlaceKind.marker, door: at));
    }

    // Содержимое QR = id точки (Запад-2 / Центр-2 / Восток-2 и т.д.)
    qr('Запад-$n', 'QR Запад-$n', const Offset(519, 533));
    qr('Центр-$n', 'QR Центр-$n', const Offset(1275, 565));
    qr('Восток-$n', 'QR Восток-$n', const Offset(1981, 535));
  }

  /// Большой зал (амфитеатр) виден на всех этажах: на 1-м это помещение,
  /// выше — проём/галерея.
  void amphitheater() {
    blocks.add(const Block(Rect.fromLTRB(1122, 80, 1432, 478), 'АМФИТЕАТР'));
  }

  FloorData build(String start, String end) => FloorData(
        number: n,
        corridors: kUpperCorridors,
        places: places,
        blocks: blocks,
        footprints: kFootprints,
        defaultStart: start,
        defaultEnd: end,
      );
}

// --- 2 этаж ---
FloorData _floor2() {
  const ph = _Photo(308, 1448, 418, 431, -50, 78, 655, 258, 695);
  final b = _FloorBuilder(2, ph);
  b.common(stWHalf: true); // над комнатой 239 — лестница
  b.amphitheater();

  b.row(true, const [
    _Sp('237', 370, 457),
    _Sp('231', 457, 541),
    _Sp('217б', 541, 570),
    _Sp('217а', 570, 601),
    _Sp('215', 601, 631),
    _Sp('211', 631, 659),
    _Sp('209', 659, 688),
    _Sp('209', 688, 717),
    _Sp('209а', 717, 758),
  ]);
  b.row(true, const [
    _Sp(null, 758, 863),
    _Sp(null, 863, 988),
  ]);
  b.row(true, const [
    _Sp('206', 988, 1022),
    _Sp('208', 1022, 1051),
    _Sp('214', 1051, 1083),
    _Sp('214', 1083, 1113),
    _Sp('216', 1113, 1143),
    _Sp('216', 1143, 1169),
    _Sp('222', 1169, 1195),
    _Sp('226', 1195, 1221),
    _Sp('228', 1221, 1247),
    _Sp('234', 1247, 1276),
    _Sp('236', 1276, 1302),
    _Sp('236а', 1302, 1329),
    _Sp('238', 1329, 1359),
    _Sp('238а', 1359, 1416),
  ]);
  b.row(false, const [
    _Sp('225', 437, 494),
    _Sp('221', 494, 551),
    _Sp('219', 551, 581),
    _Sp('217', 581, 610),
    _Sp('213', 610, 669),
    _Sp('207', 669, 728),
    _Sp('203', 728, 755),
    _Sp(null, 755, 786),
  ]);
  b.row(false, const [
    _Sp(null, 823, 855),
    _Sp(null, 855, 915),
    _Sp(null, 915, 965),
  ]);
  b.row(false, const [
    _Sp('204', 1003, 1021),
    _Sp('210', 1021, 1050),
    _Sp('210', 1050, 1079),
    _Sp('210', 1079, 1109),
    _Sp('218', 1109, 1136),
    _Sp('218', 1136, 1166),
    _Sp('220', 1166, 1193),
    _Sp('230', 1193, 1223),
    _Sp('230', 1223, 1256),
    _Sp('232', 1256, 1305),
  ]);
  b.col(true, true, const [
    _Sp(null, 78, 103),
    _Sp('259', 103, 130),
    _Sp('257', 130, 206),
    _Sp('255', 206, 233),
    _Sp(null, 233, 258),
    _Sp('253', 258, 334),
    _Sp('251', 334, 368),
  ]);
  b.col(true, false, const [
    _Sp(null, 78, 104),
    _Sp('261', 104, 130),
    _Sp('263', 130, 180),
    _Sp('265', 180, 256),
    _Sp('267', 256, 283),
    _Sp('269', 283, 368),
  ], minT: 134);
  b.col(true, true, const [
    _Sp('245', 439, 512),
    _Sp('249', 512, 584),
    _Sp('249а', 584, 610),
    _Sp('245а', 610, 630),
    _Sp(null, 630, 655),
  ]);
  b.col(true, false, const [
    _Sp('241', 439, 498),
    _Sp('243', 498, 567),
    _Sp('247', 567, 620),
    _Sp(null, 639, 655),
  ]);
  b.col(false, true, const [
    _Sp('240', 258, 342),
    _Sp('240', 342, 381),
  ]);
  b.col(false, false, const [
    _Sp(null, 258, 322),
    _Sp('240', 322, 381),
  ]);
  b.col(false, true, const [
    _Sp('242', 452, 478),
    _Sp('244', 478, 504),
    _Sp('246', 504, 529),
    _Sp('248', 529, 562),
    _Sp('252', 562, 590),
    _Sp(null, 590, 611),
    _Sp('250', 611, 645),
    _Sp(null, 645, 681),
    _Sp(null, 681, 695),
  ], maxB: 823);
  b.col(false, false, const [
    _Sp('258', 452, 526),
    _Sp('256', 526, 584),
    _Sp('256', 584, 612),
    _Sp('254', 612, 695),
  ]);
  return b.build('r_259', 'r_216');
}

// --- 3 этаж ---
FloorData _floor3() {
  const ph = _Photo(390, 1472, 480, 453, -56, 163, 707, 297, 707);
  final b = _FloorBuilder(3, ph);
  b.common();
  b.amphitheater();

  b.row(true, const [
    _Sp('323', 449, 484),
    _Sp('325', 484, 512),
    _Sp('325а', 512, 539),
    _Sp('319', 539, 595),
    _Sp('315', 595, 650),
    _Sp('313', 650, 707),
    _Sp(null, 707, 735),
    _Sp(null, 735, 760),
    _Sp('305', 760, 815),
    _Sp('303', 815, 871),
    _Sp('303а', 871, 913),
    _Sp('303а', 913, 986),
    _Sp('304', 986, 1018),
    _Sp(null, 1018, 1056),
    _Sp('308', 1056, 1127),
    _Sp('312', 1127, 1160),
    _Sp('318', 1160, 1185),
    _Sp('318а', 1185, 1212),
    _Sp('322б', 1212, 1241),
    _Sp('322а', 1241, 1265),
    _Sp('322', 1265, 1325),
    _Sp('326', 1325, 1391),
    _Sp('328', 1391, 1413),
  ]);
  b.row(false, const [
    _Sp('321', 514, 543),
    _Sp('321а', 543, 571),
    _Sp('321б', 571, 602),
    _Sp('317б', 602, 629),
    _Sp('317а', 629, 656),
    _Sp('317', 656, 711),
    _Sp('311', 711, 764),
    _Sp('307', 764, 844),
  ]);
  b.row(false, const [
    _Sp('301', 879, 936),
    _Sp('302', 936, 1013),
  ]);
  b.row(false, const [
    _Sp('310', 1049, 1151),
    _Sp('314', 1151, 1208),
    _Sp('316', 1208, 1261),
    _Sp(null, 1261, 1289),
    _Sp(null, 1289, 1319),
    _Sp('320', 1319, 1360),
  ]);
  b.col(true, true, const [
    _Sp('369', 163, 234),
    _Sp('367', 234, 258),
    _Sp('363', 258, 280),
    _Sp('361', 280, 306),
    _Sp('357', 306, 332),
    _Sp('355', 332, 424),
  ]);
  b.col(true, false, const [
    _Sp(null, 163, 186),
    _Sp('365', 186, 277),
    _Sp('359а', 277, 302),
    _Sp('359', 302, 328),
    _Sp('353', 328, 354),
    _Sp('351', 354, 424),
  ], minT: 134);
  b.col(true, true, const [
    _Sp('345', 504, 519),
    _Sp('345а', 519, 538),
    _Sp('343', 538, 571),
    _Sp('343а', 571, 590),
    _Sp('341', 590, 612),
    _Sp('341а', 612, 635),
    _Sp('341б', 635, 657),
    _Sp('339', 657, 677),
    _Sp('337', 677, 707),
  ]);
  b.col(true, false, const [
    _Sp('329', 504, 538),
    _Sp('329а', 538, 561),
    _Sp('329б', 561, 586),
    _Sp('331', 586, 620),
    _Sp('333', 620, 655),
    _Sp('333', 655, 681),
    _Sp(null, 681, 707),
  ]);
  b.col(false, true, const [
    _Sp('330', 297, 370),
    _Sp(null, 370, 397),
  ]);
  b.col(false, false, const [
    _Sp(null, 297, 361),
    _Sp(null, 361, 397),
  ]);
  b.col(false, true, const [
    _Sp('342', 477, 523),
    _Sp('344', 523, 600),
    _Sp(null, 600, 626),
    _Sp('346', 626, 707),
  ], maxB: 823);
  b.col(false, false, const [
    _Sp('334', 477, 497),
    _Sp(null, 497, 552),
    _Sp('336', 552, 577),
    _Sp('336', 577, 602),
    _Sp('338', 602, 627),
    _Sp('340', 627, 651),
    _Sp('350', 651, 674),
    _Sp('352', 674, 707),
  ]);
  return b.build('r_369', 'r_304');
}

// --- 4 этаж ---
FloorData _floor4() {
  const ph = _Photo(325, 1535, 462, 453, -62, 95, 722, 280, 725);
  final b = _FloorBuilder(4, ph);
  b.common();
  b.amphitheater();

  b.row(true, const [
    _Sp('425', 391, 431),
    _Sp('423', 431, 495),
    _Sp('417', 495, 556),
    _Sp('413', 556, 620),
    _Sp('413а', 620, 682),
    _Sp('409', 682, 745),
    _Sp('405', 745, 812),
    _Sp('401', 812, 878),
    _Sp('402', 878, 1002),
    _Sp('406', 1002, 1067),
    _Sp('412', 1067, 1186),
    _Sp('418а', 1186, 1219),
    _Sp('418', 1219, 1249),
    _Sp('420', 1249, 1309),
    _Sp('424', 1309, 1343),
    _Sp('426', 1343, 1395),
    _Sp('430', 1395, 1424),
    _Sp('432', 1424, 1441),
    _Sp('436', 1441, 1474),
  ]);
  b.row(false, const [
    _Sp('421', 470, 505),
    _Sp('419', 505, 570),
    _Sp('415', 570, 634),
    _Sp('411', 634, 695),
    _Sp('407', 695, 755),
    _Sp('403', 755, 833),
  ]);
  b.row(false, const [
    _Sp('404', 872, 1022),
  ]);
  b.row(false, const [
    _Sp('408', 1062, 1109),
    _Sp(null, 1109, 1138),
    _Sp('410', 1138, 1201),
    _Sp('414', 1201, 1265),
    _Sp('414а', 1265, 1297),
    _Sp('422', 1297, 1328),
    _Sp('428а', 1328, 1386),
    _Sp('428', 1386, 1420),
  ]);
  b.col(true, true, const [
    _Sp('445а', 95, 152),
    _Sp('445', 152, 234),
    _Sp('441', 234, 315),
    _Sp('437', 315, 400),
  ]);
  b.col(true, false, const [
    _Sp(null, 95, 114),
    _Sp('451', 114, 229),
    _Sp('447', 229, 258),
    _Sp('443а', 258, 286),
    _Sp('443', 286, 368),
    _Sp('439', 368, 400),
  ], minT: 134);
  b.col(true, true, const [
    _Sp(null, 488, 587),
    _Sp(null, 587, 618),
    _Sp(null, 618, 637),
    _Sp('435', 637, 722),
  ]);
  b.col(true, false, const [
    _Sp('453', 488, 534),
    _Sp('427', 534, 617),
    _Sp(null, 617, 645),
    _Sp(null, 645, 690),
  ]);
  b.col(false, true, const [
    _Sp('434', 280, 391),
  ]);
  b.col(false, false, const [
    _Sp(null, 280, 391),
  ]);
  b.col(false, true, const [
    _Sp('446', 479, 585),
    _Sp('444', 585, 673),
    _Sp('448', 673, 725),
  ], maxB: 823);
  b.col(false, false, const [
    _Sp('438', 479, 497),
    _Sp(null, 497, 522),
    _Sp('440', 522, 584),
    _Sp('442', 584, 644),
    _Sp('450', 644, 725),
  ]);
  return b.build('r_445', 'r_420');
}

/// Все этажи корпуса (индекс 0 = 1 этаж).
List<FloorData> buildFloors() => _rawFloors().map(_withFill).toList();

/// Контур корпуса: сплошная стена по периметру помещений. Помещения и коридоры
/// растеризуются на сетку, щели и мелкие уступы закрываются (морфологическое
/// замыкание), затем рисуются границы между «внутри» и «снаружи».
Path _buildOutline(FloorData f) {
  const x0 = 430.0, y0 = 80.0, st = 2.0, rad = 12;
  final w = ((2075 - x0) / st).ceil(), h = ((855 - y0) / st).ceil();
  final rects = <Rect>[
    for (final b in f.blocks) b.rect,
    for (final p in f.places)
      if (p.rect != null) p.rect!,
  ];
  if (rects.isEmpty) return Path();
  var bounds = rects.first;
  for (final r in rects) {
    bounds = bounds.expandToInclude(r);
  }
  rects.addAll(f.corridors.map((c) => c.rect.intersect(bounds)));
  final g = Uint8List(w * h);
  for (final r in rects) {
    if (r.isEmpty) continue;
    final c0 = ((r.left - x0) / st).floor().clamp(0, w).toInt();
    final c1 = ((r.right - x0) / st).ceil().clamp(0, w).toInt();
    final r0 = ((r.top - y0) / st).floor().clamp(0, h).toInt();
    final r1 = ((r.bottom - y0) / st).ceil().clamp(0, h).toInt();
    for (var y = r0; y < r1; y++) {
      g.fillRange(y * w + c0, y * w + c1, 1);
    }
  }
  // замыкание (закрыть щели) -> размыкание (убрать выступы уже стены) -> убрать узкие «дырки»
  final closed = _morph(_morph(g, w, h, rad, true), w, h, rad, false);
  final c = _morph(_morph(closed, w, h, 9, false), w, h, 9, true);
  _fillSmallHoles(c, w, h, 1 << 20); // только внешний периметр, без внутренних контуров
  bool at(int x, int y) => x >= 0 && y >= 0 && x < w && y < h && c[y * w + x] == 1;
  final path = Path();
  for (var y = 0; y <= h; y++) {
    int s = -1;
    final yy = y0 + y * st;
    for (var x = 0; x <= w; x++) {
      final e = x < w && at(x, y) != at(x, y - 1);
      if (e && s < 0) {
        s = x;
      } else if (!e && s >= 0) {
        path.moveTo(x0 + s * st, yy);
        path.lineTo(x0 + x * st, yy);
        s = -1;
      }
    }
  }
  for (var x = 0; x <= w; x++) {
    int s = -1;
    final xx = x0 + x * st;
    for (var y = 0; y <= h; y++) {
      final e = y < h && at(x, y) != at(x - 1, y);
      if (e && s < 0) {
        s = y;
      } else if (!e && s >= 0) {
        path.moveTo(xx, y0 + s * st);
        path.lineTo(xx, y0 + y * st);
        s = -1;
      }
    }
  }
  return path;
}

/// Закрашивает замкнутые пустоты, у которых меньшая сторона < minDim клеток.
void _fillSmallHoles(Uint8List c, int w, int h, int minDim) {
  final seen = Uint8List(w * h);
  final q = Int32List(w * h);
  for (var i = 0; i < w * h; i++) {
    if (c[i] != 0 || seen[i] != 0) continue;
    var head = 0, tail = 0;
    q[tail++] = i;
    seen[i] = 1;
    var minX = w, maxX = -1, minY = h, maxY = -1;
    var outside = false;
    while (head < tail) {
      final p = q[head++];
      final x = p % w, y = p ~/ w;
      if (x < minX) minX = x;
      if (x > maxX) maxX = x;
      if (y < minY) minY = y;
      if (y > maxY) maxY = y;
      if (x == 0 || y == 0 || x == w - 1 || y == h - 1) outside = true;
      if (x > 0 && c[p - 1] == 0 && seen[p - 1] == 0) {
        seen[p - 1] = 1;
        q[tail++] = p - 1;
      }
      if (x < w - 1 && c[p + 1] == 0 && seen[p + 1] == 0) {
        seen[p + 1] = 1;
        q[tail++] = p + 1;
      }
      if (y > 0 && c[p - w] == 0 && seen[p - w] == 0) {
        seen[p - w] = 1;
        q[tail++] = p - w;
      }
      if (y < h - 1 && c[p + w] == 0 && seen[p + w] == 0) {
        seen[p + w] = 1;
        q[tail++] = p + w;
      }
    }
    if (!outside && math.min(maxX - minX + 1, maxY - minY + 1) < minDim) {
      for (var k = 0; k < tail; k++) {
        c[q[k]] = 1;
      }
    }
  }
}

/// Расширение (dil) или сужение квадратным окном радиуса r; за краем сетки
/// при сужении считается «занято», чтобы границы не съедались.
Uint8List _morph(Uint8List a, int w, int h, int r, bool dil) {
  final tmp = Uint8List(w * h), out = Uint8List(w * h);
  final pre = Int32List(math.max(w, h) + 1);
  int pass(int n, int lo, int hi) {
    final l = lo < 0 ? 0 : lo, rr = hi >= n ? n - 1 : hi;
    return pre[rr + 1] - pre[l];
  }

  int val(int s, int n, int lo, int hi) {
    if (dil) return s > 0 ? 1 : 0;
    final outside = (lo < 0 ? -lo : 0) + (hi >= n ? hi - n + 1 : 0);
    return s + outside == 2 * r + 1 ? 1 : 0;
  }

  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      pre[x + 1] = pre[x] + a[y * w + x];
    }
    for (var x = 0; x < w; x++) {
      tmp[y * w + x] = val(pass(w, x - r, x + r), w, x - r, x + r);
    }
  }
  for (var x = 0; x < w; x++) {
    for (var y = 0; y < h; y++) {
      pre[y + 1] = pre[y] + tmp[y * w + x];
    }
    for (var y = 0; y < h; y++) {
      out[y * w + x] = val(pass(h, y - r, y + r), h, y - r, y + r);
    }
  }
  return out;
}

/// 1) лестницы растягиваются до соседних помещений (без зазоров);
/// 2) свободное место внутри рядов и крыльев заполняется безымянными аудиториями.
FloorData _withFill(FloorData f) {
  final ext = FloorData(
    number: f.number,
    corridors: f.corridors,
    places: _extendStairs(f.places, f.blocks),
    blocks: f.blocks,
    footprints: f.footprints,
    defaultStart: f.defaultStart,
    defaultEnd: f.defaultEnd,
  );
  return FloorData(
    number: f.number,
    corridors: f.corridors,
    places: ext.places,
    blocks: [...f.blocks, ..._computeFills(ext)],
    footprints: f.footprints,
    defaultStart: f.defaultStart,
    defaultEnd: f.defaultEnd,
  );
}

List<Place> _extendStairs(List<Place> ps, List<Block> blocks) {
  final others = <Rect>[
    for (final b in blocks) b.rect,
    for (final p in ps)
      if (p.rect != null && p.kind != PlaceKind.stairs && p.kind != PlaceKind.marker) p.rect!,
  ];
  const hor = {'st_c_w', 'st_c_e', 'st_e'};
  const ver = {'st_nw', 'st_sw', 'st_se'};
  Place ext(Place p) {
    var r = p.rect!;
    if (hor.contains(p.id)) {
      var l = r.left, rt = r.right;
      var bl = -1e9, br = 1e9;
      for (final o in others) {
        final ov = math.min(o.bottom, r.bottom) - math.max(o.top, r.top);
        if (ov < r.height * 0.5) continue;
        if (o.right <= r.left + 4 && r.left - o.right < 80 && o.right > bl) bl = o.right;
        if (o.left >= r.right - 4 && o.left - r.right < 80 && o.left < br) br = o.left;
      }
      if (bl > -1e8) l = bl;
      if (br < 1e8) rt = br;
      r = Rect.fromLTRB(l, r.top, rt, r.bottom);
    } else if (ver.contains(p.id)) {
      // растягиваем на всю ширину колонки и до соседей по вертикали
      var l = r.left, rt = r.right, t = r.top, b = r.bottom;
      if (p.id == 'st_se') {
        l = 1887;
        rt = 1943;
      } else {
        l = 566;
        rt = 626;
      }
      final rr = Rect.fromLTRB(l, t, rt, b);
      var bt = -1e9, bb = 1e9;
      for (final o in others) {
        final ov = math.min(o.right, rr.right) - math.max(o.left, rr.left);
        if (ov < rr.width * 0.5) continue;
        if (o.bottom <= rr.top + 4 && rr.top - o.bottom < 80 && o.bottom > bt) bt = o.bottom;
        if (o.top >= rr.bottom - 4 && o.top - rr.bottom < 80 && o.top < bb) bb = o.top;
      }
      if (bt > -1e8) t = bt;
      if (bb < 1e8) b = bb;
      if (p.id == 'st_nw') t = math.min(t, 82);
      r = Rect.fromLTRB(l, t, rt, b);
    } else {
      return p;
    }
    return Place(
      id: p.id,
      name: p.name,
      corridor: p.corridor,
      label: p.label,
      rect: r,
      kind: p.kind,
      door: p.door,
      provisional: p.provisional,
    );
  }

  return [for (final p in ps) p.kind == PlaceKind.stairs && p.rect != null ? ext(p) : p];
}

class _Zone {
  final Rect r;
  final bool horizontal; // true — ряд вдоль главного коридора, false — колонка в крыле
  const _Zone(this.r, this.horizontal);
}

const List<_Zone> _kZones = [
  _Zone(Rect.fromLTRB(626, 478, 1920, 528), true),
  _Zone(Rect.fromLTRB(626, 568, 1920, 622), true),
  _Zone(Rect.fromLTRB(476, 82, 532, 478), false),
  _Zone(Rect.fromLTRB(476, 568, 532, 856), false),
  _Zone(Rect.fromLTRB(566, 82, 626, 478), false),
  _Zone(Rect.fromLTRB(566, 568, 626, 856), false),
  _Zone(Rect.fromLTRB(1887, 345, 1943, 477), false),
  _Zone(Rect.fromLTRB(1887, 565, 1943, 856), false),
  _Zone(Rect.fromLTRB(1978, 345, 2038, 477), false),
  _Zone(Rect.fromLTRB(1978, 565, 2038, 856), false),
];

/// Пустые места внутри рядов и колонок, не занятые помещениями, — безымянные аудитории.
/// Границы рядов берутся по крайним помещениям, поэтому за пределы плана заливка не выходит.
List<Block> _computeFills(FloorData f) {
  const x0 = 430.0, y0 = 80.0, st = 2.0;
  final w = ((2075 - x0) / st).ceil(), h = ((855 - y0) / st).ceil();
  final g = List<int>.filled(w * h, 0);
  void mark(Rect r, int v) {
    final xa = math.max(0, ((r.left - x0) / st - 0.5).ceil());
    final xb = math.min(w - 1, ((r.right - x0) / st - 0.5).floor());
    final ya = math.max(0, ((r.top - y0) / st - 0.5).ceil());
    final yb = math.min(h - 1, ((r.bottom - y0) / st - 0.5).floor());
    for (int y = ya; y <= yb; y++) {
      for (int x = xa; x <= xb; x++) {
        final i = y * w + x;
        if (v == 1) {
          if (g[i] == 0) g[i] = 1;
        } else {
          g[i] = 2;
        }
      }
    }
  }

  final rooms = <Rect>[
    for (final b in f.blocks) b.rect,
    for (final p in f.places)
      if (p.rect != null) p.rect!,
  ];
  for (final z in _kZones) {
    final inside = rooms.where((r) => z.r.contains(r.center)).toList();
    if (inside.isEmpty) continue;
    var bb = inside.first;
    for (final r in inside) {
      bb = bb.expandToInclude(r);
    }
    mark(
        z.horizontal
            ? Rect.fromLTRB(bb.left, z.r.top, bb.right, z.r.bottom)
            : Rect.fromLTRB(z.r.left, bb.top, z.r.right, bb.bottom),
        1);
  }
  for (final c in f.corridors) {
    mark(c.rect, 2);
  }
  for (final r in rooms) {
    mark(r, 2);
  }

  final out = <Block>[];
  var open = <String, int>{}; // 'xa_xb' -> первая строка
  void flush(Map<String, int> m, int yEnd) {
    m.forEach((k, ys) {
      final parts = k.split('_');
      final r = Rect.fromLTRB(x0 + int.parse(parts[0]) * st, y0 + ys * st,
          x0 + int.parse(parts[1]) * st, y0 + yEnd * st);
      if (math.min(r.width, r.height) >= 8) out.add(Block(r)); // узкие щели — это стены
    });
  }

  for (int y = 0; y <= h; y++) {
    final cur = <String, int>{};
    if (y < h) {
      int x = 0;
      while (x < w) {
        if (g[y * w + x] == 1) {
          final s = x;
          while (x < w && g[y * w + x] == 1) {
            x++;
          }
          final k = '${s}_$x';
          cur[k] = open[k] ?? y;
        } else {
          x++;
        }
      }
    }
    flush({
      for (final e in open.entries)
        if (!cur.containsKey(e.key)) e.key: e.value
    }, y);
    open = cur;
  }
  return out;
}

List<FloorData> _rawFloors() => [
      FloorData(
        number: 1,
        corridors: kCorridors,
        places: buildPlaces(),
        blocks: kBlocks,
        footprints: kFootprints,
        defaultStart: 'r_153',
        defaultEnd: 'r_104',
      ),
      _floor2(),
      _floor3(),
      _floor4(),
    ];

// ============================================================================
// ЯЗЫК (RU / EN)
// ============================================================================

/// true — интерфейс на английском. Переключается кнопкой RU/EN в шапке.
final ValueNotifier<bool> isEn = ValueNotifier(false);

String _latR(String s) =>
    s.replaceAll('а', 'a').replaceAll('б', 'b').replaceAll('в', 'v');

const Map<String, String> _enUi = {
  'Откуда': 'From',
  'Куда': 'To',
  'ОТКУДА': 'FROM',
  'КУДА': 'TO',
  'эт.': 'fl.',
  'Светлая тема': 'Light theme',
  'Тёмная тема': 'Dark theme',
  'Сканировать QR': 'Scan QR',
  'Поменять местами': 'Swap',
  'Маршрут не найден': 'No route found',
  'Аудитория': 'Room',
  'Лестница': 'Stairs',
  'Санузел': 'Restroom',
  'Сервис': 'Service',
  'Выход': 'Exit',
  'Ввести код вручную': 'Enter code manually',
  'например, Запад-1': 'e.g. Запад-1',
  'Отмена': 'Cancel',
  'Сканирование QR': 'Scan QR',
  'Фонарик': 'Flashlight',
  'Нет доступа к камере.\nНастройки → Приложения → МАИ Навигатор → Разрешения → Камера.':
      'No camera access.\nSettings → Apps → MAI Navigator → Permissions → Camera.',
  'Ввести код': 'Enter code',
  'Наведите камеру на QR-код на стене': 'Point the camera at the QR code on the wall',
  'Номер или название…': 'Room number or name…',
  'QR-точки': 'QR points',
  'Выходы, лестницы, сервисы': 'Exits, stairs, services',
  'Аудитории': 'Rooms',
  'Номер условный (на плане не указан)': 'Provisional number (not on the plan)',
  'Без номера на плане': 'Unnumbered on the plan',
  'Этот QR-код не относится к карте': 'This QR code is not part of the map',
  'Вы здесь': 'You are here',
  'Меню': 'Menu',
  'Фото меню пока не добавлено': 'Menu photo has not been added yet',
  'Маршрут сюда': 'Route here',
  'Отсюда': 'From here',
  'Сюда': 'To here',
  'Выберите помещение…': 'Choose a place…',
  'Выберите начало и конец маршрута': 'Choose a start and a destination',
  '1 палец — двигать · 2 пальца — масштаб и поворот · свайп двумя пальцами вверх/вниз — наклон':
      'One finger — pan · two fingers — zoom and rotate · two-finger vertical swipe — tilt',
};

/// Перевод строки интерфейса (если перевода нет — остаётся русский).
String tx(String ru) => isEn.value ? (_enUi[ru] ?? ru) : ru;

String floorTitle(int n) => isEn.value ? 'Floor $n' : '$n этаж';

const List<List<String>> _enFrag = [
  ['Запад-', 'West-'],
  ['Центр-', 'Center-'],
  ['Восток-', 'East-'],
  ['Вход-', 'Entrance-'],
  ['Большая аудитория (амфитеатр)', 'Large lecture hall (amphitheater)'],
  ['Главный выход (юг)', 'Main exit (south)'],
  ['Аварийный выход', 'Emergency exit'],
  ['у центральных лестниц', 'by the central stairs'],
  ['у главного входа', 'by the main entrance'],
  ['у санузла', 'by the restroom'],
  ['Главный холл', 'Main hall'],
  ['Обеденный зал', 'Dining hall'],
  ['Коворкинг', 'Coworking'],
  ['Лестница', 'Staircase'],
  ['Санузел', 'Restroom'],
  ['кофейня', 'Cafe'],
  ['Кухня', 'Kitchen'],
  ['QR-точка', 'QR point'],
  ['северо-запад', 'north-west'],
  ['северо-восток', 'north-east'],
  ['юго-восток', 'south-east'],
  ['юго-запад', 'south-west'],
  ['запад', 'west'],
  ['восток', 'east'],
  ['центр', 'center'],
  ['север', 'north'],
  ['юг', 'south'],
  ['у ', 'near '],
];

/// Название помещения на текущем языке.
String placeName(Place p) {
  if (!isEn.value) return p.name;
  var s = p.name;
  if (s.startsWith('Без номера')) return 'Unnumbered room';
  if (s.startsWith('Ауд. ')) {
    final i = s.indexOf(' · номер условный');
    if (i > 0) return 'Room ${_latR(s.substring(5, i))} · provisional number';
    s = 'Room ${s.substring(5)}'
        .replaceAll('(зап.)', '(W)')
        .replaceAll('(вост.)', '(E)')
        .replaceAll('(север)', '(north)')
        .replaceAll('(центр)', '(center)')
        .replaceAll('(юг)', '(south)');
    return _latR(s);
  }
  s = s.replaceAllMapped(RegExp(r'(\d) этаж'), (m) => 'floor ${m[1]}');
  for (final f in _enFrag) {
    s = s.replaceAll(f[0], f[1]);
  }
  return _latR(s);
}

/// Подпись на карте на текущем языке.
String locLabel(String s) {
  if (!isEn.value) return s;
  const m = {
    'ЛЕСТН.': 'STAIRS',
    'КОФЕЙНЯ': 'CAFE',
    'КОВОРКИНГ': 'COWORK',
    'ХОЛЛ': 'HALL',
    'АМФИТЕАТР': 'AMPHITHEATER',
    'ОБЕДЕННЫЙ ЗАЛ': 'DINING',
    'КУХНЯ': 'KITCHEN',
    'ВЫХОД': 'EXIT',
    'б/н': 'n/a',
  };
  return m[s] ?? _latR(s);
}

// ============================================================================
// СКВОЗНОЙ ГРАФ ЗДАНИЯ (маршруты между этажами)
// ============================================================================

/// «Стоимость» подъёма/спуска на один этаж по лестнице (в единицах плана).
const double kStairsCost = 220;

/// Участок маршрута на одном этаже.
class RouteSeg {
  final int floor;
  final List<Offset> pts;
  final bool first, last;
  final int? fromFloor, toFloor; // с какого этажа пришли / на какой уходим
  const RouteSeg(this.floor, this.pts, this.first, this.last, this.fromFloor, this.toFloor);
}

class BuildingGraph {
  final List<FloorData> floors;
  final Map<String, List<MapEdge>> adj = {};
  static String key(int f, String id) => '$f|$id';

  BuildingGraph(this.floors) {
    for (int i = 0; i < floors.length; i++) {
      floors[i].graph.adj.forEach((k, es) {
        adj[key(i, k)] = [
          for (final e in es) MapEdge(key(i, e.startId), key(i, e.endId), e.weight)
        ];
      });
    }
    // Лестницы соседних этажей соединяются по расположению: каждая лестница связана
    // с ближайшей лестницей выше и ниже (ids и количество лестниц на этажах могут
    // различаться). Маршрут сам выберет самую близкую по длине пути.
    const maxShift = 160.0; // дальше этого лестницы считаются разными шахтами
    final linked = <String>{};
    void link(int fa, Place p, int fb, Place q) {
      final a = key(fa, p.id), b = key(fb, q.id);
      if (!linked.add(fa < fb ? '$a>$b' : '$b>$a')) return;
      adj[a]!.add(MapEdge(a, b, kStairsCost));
      adj[b]!.add(MapEdge(b, a, kStairsCost));
    }

    Place? nearest(Place p, int f) {
      Place? best;
      var bd = maxShift;
      for (final q in floors[f].places) {
        if (q.kind != PlaceKind.stairs || q.rect == null) continue;
        final d = (q.rect!.center - p.rect!.center).distance;
        if (d < bd) {
          bd = d;
          best = q;
        }
      }
      return best;
    }

    for (int i = 0; i + 1 < floors.length; i++) {
      for (final p in floors[i].places) {
        if (p.kind != PlaceKind.stairs || p.rect == null) continue;
        final q = nearest(p, i + 1);
        if (q != null) link(i, p, i + 1, q);
      }
      for (final q in floors[i + 1].places) {
        if (q.kind != PlaceKind.stairs || q.rect == null) continue;
        final p = nearest(q, i);
        if (p != null) link(i, p, i + 1, q);
      }
    }
  }

  List<String> route(String from, String to) {
    if (!adj.containsKey(from) || !adj.containsKey(to)) return [];
    final dist = <String, double>{for (final k in adj.keys) k: double.infinity};
    final prev = <String, String>{};
    final open = <String>{...adj.keys};
    dist[from] = 0;
    while (open.isNotEmpty) {
      String? cur;
      for (final id in open) {
        if (cur == null || dist[id]! < dist[cur]!) cur = id;
      }
      if (cur == null || dist[cur]!.isInfinite) break;
      open.remove(cur);
      if (cur == to) break;
      for (final e in adj[cur]!) {
        final alt = dist[cur]! + e.weight;
        if (alt < dist[e.endId]!) {
          dist[e.endId] = alt;
          prev[e.endId] = cur;
        }
      }
    }
    if (dist[to]!.isInfinite) return [];
    final path = <String>[];
    String? c = to;
    while (c != null) {
      path.add(c);
      c = prev[c];
    }
    return path.reversed.toList();
  }
}

// ============================================================================
// ЭКРАН
// ============================================================================

IconData _iconOf(Place p) {
  switch (p.kind) {
    case PlaceKind.stairs:
      return Icons.stairs_rounded;
    case PlaceKind.wc:
      return Icons.wc_rounded;
    case PlaceKind.service:
      return Icons.storefront_rounded;
    case PlaceKind.exit:
      return Icons.exit_to_app_rounded;
    case PlaceKind.marker:
      return Icons.qr_code_2_rounded;
    case PlaceKind.room:
      return p.unnumbered ? Icons.help_outline_rounded : Icons.meeting_room_rounded;
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  /// Метров в одной единице плана (0 — не показывать расстояние).
  static const double metersPerUnit = 0;

  late final List<FloorData> floors = buildFloors();
  int floorIdx = 0;
  FloorData get floor => floors[floorIdx];
  List<Place> get places => floor.places;
  FloorGraph get graph => floor.graph;
  late final BuildingGraph building = BuildingGraph(floors);
  late final AnimationController _anim =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))..repeat();

  // Начало и конец маршрута: этаж (0 = 1 этаж) + id помещения.
  int startFloor = 0, endFloor = 0;
  String? startNodeId; // null — пока не выбрано (при запуске маршрута нет)
  String? endNodeId;
  List<String> currentPath = [];
  List<RouteSeg> segs = [];
  double routeLength = 0;

  // Камера: наклон (0 = вид сверху), поворот, масштаб, сдвиг.
  bool is3DMode = false;
  double tiltAngle = 0.0, rotationAngle = 0.0, zoomScale = 1.0;
  double _pref3dTilt = -0.85;
  Offset pan = Offset.zero;
  double _baseZoom = 1.0, _baseRot = 0.0;

  late final AnimationController _viewCtrl =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 380));
  VoidCallback? _viewTick;

  /// Плавный переход камеры к новым параметрам (как в навигаторах).
  void _animateTo({double? tilt, double? rot, double? zoom, Offset? pan, VoidCallback? onDone}) {
    final t0 = tiltAngle, r0 = rotationAngle, z0 = zoomScale, p0 = this.pan;
    final t1 = tilt ?? t0, r1 = rot ?? r0, z1 = zoom ?? z0, p1 = pan ?? p0;
    if (_viewTick != null) _viewCtrl.removeListener(_viewTick!);
    _viewCtrl
      ..stop()
      ..reset();
    final curve = CurvedAnimation(parent: _viewCtrl, curve: Curves.easeOutCubic);
    _viewTick = () => setState(() {
          final v = curve.value;
          tiltAngle = lerpDouble(t0, t1, v)!;
          rotationAngle = lerpDouble(r0, r1, v)!;
          zoomScale = lerpDouble(z0, z1, v)!;
          this.pan = _clampPan(Offset.lerp(p0, p1, v)!);
        });
    _viewCtrl.addListener(_viewTick!);
    _viewCtrl.forward().whenComplete(() {
      if (mounted) onDone?.call();
    });
  }

  /// Не даёт «потерять» карту: сдвиг ограничен границами плана
  /// (с небольшим запасом по краям) с учётом масштаба и поворота.
  Offset _clampPan(Offset p) {
    final size = MediaQuery.of(context).size;
    final a = kAspect;
    final mw = math.min(size.width, size.height * a);
    final mh = mw / a;
    final c = math.cos(rotationAngle).abs(), sn = math.sin(rotationAngle).abs();
    final hx = (mw * c + mh * sn) / 2 * zoomScale;
    final hy = (mw * sn + mh * c) / 2 * zoomScale;
    final lx = math.max(0.0, hx - size.width / 2) + size.width * 0.15;
    final ly = math.max(0.0, hy - size.height / 2) + size.height * 0.15;
    return Offset(p.dx.clamp(-lx, lx).toDouble(), p.dy.clamp(-ly, ly).toDouble());
  }

  void _toggle3D() {
    if (!is3DMode) {
      setState(() => is3DMode = true);
      _animateTo(tilt: _pref3dTilt);
    } else {
      if (tiltAngle < -0.1) _pref3dTilt = tiltAngle;
      _animateTo(tilt: 0, onDone: () => setState(() => is3DMode = false));
    }
  }

  // --- Подгонка карты под экран -------------------------------------------
  // На узком (портретном) экране карта поворачивается вдоль экрана и
  // увеличивается так, чтобы целиком помещаться между панелями.
  bool? _portrait;
  double _fitRot = 0.0, _fitZoom = 1.0;
  Offset _fitPan = Offset.zero;

  void _computeFit(Size size, EdgeInsets pad) {
    const topUi = 240.0, bottomUi = 85.0; // высота верхней и нижней панелей
    final aspect = kAspect;
    final portrait = size.height > size.width * 1.15;
    if (!portrait) {
      _fitRot = 0.0;
      _fitZoom = 1.0;
      _fitPan = Offset.zero;
      return;
    }
    final availH = size.height - pad.top - pad.bottom - topUi - bottomUi;
    _fitRot = math.pi / 2;
    _fitZoom = math.min(availH * 0.88 / size.width, aspect * 0.88).clamp(0.6, 6.0).toDouble();
    _fitPan = Offset(0, (topUi + pad.top - bottomUi - pad.bottom) / 2);
  }

  /// Компас: возвращает карту в исходную ориентацию кратчайшим поворотом.
  void _resetNorth() {
    final diff = ((rotationAngle - _fitRot + math.pi) % (2 * math.pi)) - math.pi;
    setState(() => rotationAngle = _fitRot + diff);
    _animateTo(rot: _fitRot);
  }

  void _onSignal(PointerSignalEvent e) {
    if (e is PointerScrollEvent) {
      setState(() {
        zoomScale = (zoomScale * math.exp(-e.scrollDelta.dy / 400)).clamp(0.7, 6.0);
        pan = _clampPan(pan);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _anim.dispose();
    _viewCtrl.dispose();
    super.dispose();
  }

  void _calculateRoute() {
    final sId = startNodeId, eId = endNodeId;
    if (sId == null || eId == null) {
      setState(() {
        currentPath = [];
        segs = [];
        routeLength = 0;
      });
      return;
    }
    final path = building.route(
        BuildingGraph.key(startFloor, sId), BuildingGraph.key(endFloor, eId));
    // делим путь на участки по этажам
    final groups = <MapEntry<int, List<String>>>[];
    for (final k in path) {
      final sep = k.indexOf('|');
      final f = int.parse(k.substring(0, sep));
      final id = k.substring(sep + 1);
      if (groups.isEmpty || groups.last.key != f) groups.add(MapEntry(f, <String>[]));
      groups.last.value.add(id);
    }
    final out = <RouteSeg>[];
    double len = 0;
    for (int i = 0; i < groups.length; i++) {
      final f = groups[i].key, ids = groups[i].value;
      final g = floors[f].graph;
      final first = i == 0, last = i == groups.length - 1;
      final pts = <Offset>[
        first ? g.centerOf(sId) : g.centerOf(ids.first),
        ...ids.map((id) => g.pos[id]!),
        last ? g.centerOf(eId) : g.centerOf(ids.last),
      ];
      for (int j = 0; j < pts.length - 1; j++) {
        len += (pts[j + 1] - pts[j]).distance;
      }
      out.add(RouteSeg(f, pts, first, last, first ? null : groups[i - 1].key,
          last ? null : groups[i + 1].key));
    }
    setState(() {
      currentPath = path;
      segs = out;
      routeLength = len;
    });
  }

  Future<void> _pick(bool start) async {
    final key = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Pal.of(context).sheet,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (_) => _PlacePicker(
          floors: floors, floorIdx: floorIdx, title: tx(start ? 'Откуда' : 'Куда')),
    );
    if (key == null) return;
    final sep = key.indexOf('|');
    final f = int.parse(key.substring(0, sep));
    final id = key.substring(sep + 1);
    if (start) {
      startFloor = f;
      startNodeId = id;
    } else {
      endFloor = f;
      endNodeId = id;
    }
    floorIdx = f;
    _calculateRoute();
  }

  Future<void> _openQRScanner() async {
    final raw = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const QrScanScreen()),
    );
    if (raw == null || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final hit = _resolveCode(raw);
    if (hit == null) {
      messenger.showSnackBar(SnackBar(
        content: Text('${tx('Этот QR-код не относится к карте')}: «$raw»'),
        backgroundColor: const Color(0xFFB3261E),
      ));
      return;
    }
    // QR может быть с другого этажа: переключаем карту на него
    floorIdx = hit.key;
    startFloor = hit.key;
    startNodeId = hit.value;
    _calculateRoute();
    messenger.showSnackBar(SnackBar(
      content: Text('${tx('Вы здесь')}: ${placeName(floors[hit.key].graph.places[hit.value]!)}'),
      backgroundColor: kMaiBlue,
    ));
  }

  /// Ищет id на этаже без учёта регистра; понимает и старые коды (qr_west, qr2_east…).
  String? _findId(int i, String c) {
    const legacy = {
      'qr_west': 'Запад-1',
      'qr_entrance': 'Вход-1',
      'qr_east': 'Восток-1',
      'qr2_west': 'Запад-2', 'qr2_center': 'Центр-2', 'qr2_east': 'Восток-2',
      'qr3_west': 'Запад-3', 'qr3_center': 'Центр-3', 'qr3_east': 'Восток-3',
      'qr4_west': 'Запад-4', 'qr4_center': 'Центр-4', 'qr4_east': 'Восток-4',
    };
    final want = (legacy[c.toLowerCase()] ?? c).toLowerCase();
    for (final k in floors[i].graph.places.keys) {
      if (k.toLowerCase() == want) return k;
    }
    return null;
  }

  /// Понимает «Запад-1», а также ссылки и значения вида …/qr_west или id=qr_west.
  MapEntry<int, String>? _resolveCode(String raw) {
    final v = raw.trim();
    final tail = v.split(RegExp(r'[/#=?&:]')).where((e) => e.isNotEmpty).toList();
    final cands = <String>[
      v,
      v.toLowerCase(),
      if (tail.isNotEmpty) tail.last,
      if (tail.isNotEmpty) tail.last.toLowerCase(),
    ];
    for (final c in cands) {
      // сначала текущий этаж, затем остальные
      for (int k = 0; k < floors.length; k++) {
        final i = (floorIdx + k) % floors.length;
        final id = _findId(i, c);
        if (id != null) return MapEntry(i, id);
      }
    }
    return null;
  }

  void _resetView() {
    final mq = MediaQuery.of(context);
    _computeFit(mq.size, mq.padding);
    _animateTo(tilt: is3DMode ? -0.85 : 0.0, rot: _fitRot, zoom: _fitZoom, pan: _fitPan);
  }

  FloorPainter _painter(FloorData floor, Pal pal, int layer) => FloorPainter(
        places: places,
        corridors: floor.corridors,
        blocks: floor.blocks,
        footprints: floor.footprints,
        outline: floor.outline,
        routes: layer == 1 ? segs.where((s) => s.floor == floorIdx).toList() : const [],
        startId: startNodeId != null && startFloor == floorIdx ? startNodeId! : '',
        endId: endNodeId != null && endFloor == floorIdx ? endNodeId! : '',
        pal: pal,
        is3D: is3DMode,
        viewRotation: rotationAngle,
        viewZoom: zoomScale,
        anim: _anim,
        layer: layer,
      );

  /// Нажатие по карте: выбор «отсюда / сюда» для любой аудитории
  /// (у кофейни и обеденного зала — вместе с меню).
  void _onMapTap(Offset p, Size size) {
    final w = Offset(kWorld.left + p.dx / size.width * kWorld.width,
        kWorld.top + p.dy / size.height * kWorld.height);
    Place? hit;
    double best = double.infinity;
    for (final pl in places) {
      final r = pl.rect;
      if (r == null || pl.kind == PlaceKind.marker || !r.contains(w)) continue;
      final a = r.width * r.height;
      if (a < best) {
        best = a;
        hit = pl;
      }
    }
    if (hit != null) _showPlace(hit);
  }

  Future<void> _showPlace(Place pl) async {
    final pal = Pal.of(context);
    final menu = kMenuPhotos[pl.id];
    final choice = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: menu != null,
      backgroundColor: pal.sheet,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (_) => menu != null
          ? _MenuSheet(title: placeName(pl), photos: menu)
          : _PlaceSheet(title: placeName(pl), floor: floorIdx),
    );
    if (choice == 'from') {
      startFloor = floorIdx;
      startNodeId = pl.id;
    } else if (choice == 'to') {
      endFloor = floorIdx;
      endNodeId = pl.id;
    } else {
      return;
    }
    _calculateRoute();
  }

  void _setFloor(int i) {
    if (i == floorIdx) return;
    setState(() => floorIdx = i);
  }

  /// Цепочка этажей маршрута: нажатие переключает карту на нужный этаж.
  Widget _routeChips(Pal pal) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          for (int i = 0; i < segs.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                    segs[i].floor > segs[i - 1].floor
                        ? Icons.north_east_rounded
                        : Icons.south_east_rounded,
                    size: 15,
                    color: pal.faint),
              ),
            InkWell(
              borderRadius: BorderRadius.circular(9),
              onTap: () => setState(() => floorIdx = segs[i].floor),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: segs[i].floor == floorIdx ? pal.accent.withValues(alpha: 0.2) : pal.field,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                      color: segs[i].floor == floorIdx ? pal.accent : pal.glassBorder),
                ),
                child: Text(floorTitle(segs[i].floor + 1),
                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ]),
      ),
    );
  }

  Widget _floorBar(Pal pal) {
    return Row(children: [
      for (int i = 0; i < floors.length; i++)
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == floors.length - 1 ? 0 : 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => _setFloor(i),
              child: Container(
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: i == floorIdx ? pal.accent : pal.field,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: i == floorIdx ? pal.accent : pal.glassBorder),
                ),
                child: Text(floorTitle(floors[i].number),
                    style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: i == floorIdx ? Colors.white : pal.text)),
              ),
            ),
          ),
        ),
    ]);
  }

  Widget _glass({required Widget child, EdgeInsets padding = const EdgeInsets.all(12)}) {
    final pal = Pal.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: pal.glass,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: pal.glassBorder),
        boxShadow: [BoxShadow(color: pal.shadow, blurRadius: 24, offset: const Offset(0, 10))],
      ),
      child: child,
    );
  }

  Widget _pill(String label, int f, String? id, Color dot, VoidCallback onTap) {
    final p = id == null ? null : floors[f].graph.places[id]!;
    final pal = Pal.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: pal.field,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: dot.withValues(alpha: 0.55)),
        ),
        child: Row(children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle, boxShadow: [
              BoxShadow(color: dot.withValues(alpha: 0.7), blurRadius: 8),
            ]),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: TextStyle(fontSize: 9, color: pal.dim, letterSpacing: .6)),
              Text(p == null ? tx('Выберите помещение…') : '${placeName(p)} · ${f + 1} ${tx('эт.')}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: p == null ? pal.faint : null)),
            ]),
          ),
          Icon(Icons.expand_more_rounded, size: 20, color: pal.faint),
        ]),
      ),
    );
  }

  Widget _circleBtn(String tag, Widget child, VoidCallback onTap) {
    final pal = Pal.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: pal.glass,
        elevation: pal.isDark ? 0 : 3,
        shadowColor: pal.shadow,
        shape: CircleBorder(side: BorderSide(color: pal.glassBorder)),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(width: 44, height: 44, child: Center(child: child)),
        ),
      ),
    );
  }

  Widget _legendDot(Color c, String t) => Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 5),
          Text(t, style: TextStyle(fontSize: 9.5, color: Pal.of(context).dim)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final portraitNow = mq.size.height > mq.size.width * 1.15;
    if (_portrait != portraitNow) {
      final first = _portrait == null;
      _portrait = portraitNow;
      _computeFit(mq.size, mq.padding);
      if (first) {
        rotationAngle = _fitRot;
        zoomScale = _fitZoom;
        pan = _fitPan;
      } else {
        WidgetsBinding.instance.addPostFrameCallback(
            (_) => _animateTo(rot: _fitRot, zoom: _fitZoom, pan: _fitPan));
      }
    }
    final pal = Pal.of(context);
    final from = startNodeId == null ? '' : placeName(floors[startFloor].graph.places[startNodeId!]!);
    final to = endNodeId == null ? '' : placeName(floors[endFloor].graph.places[endNodeId!]!);
    final both = startNodeId != null && endNodeId != null;
    final found = currentPath.isNotEmpty;
    final meters = (routeLength * metersPerUnit).round();

    return Scaffold(
      body: Stack(children: [
        // Фон
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.2),
                radius: 1.2,
                colors: pal.bg,
              ),
            ),
          ),
        ),
        Listener(
          onPointerSignal: _onSignal,
          child: GestureDetector(
          // 1 палец — двигать карту; 2 пальца — масштаб и поворот,
          // в 3D вертикальный свайп двумя пальцами — наклон; двойной тап — приблизить.
          onScaleStart: (d) {
            _viewCtrl.stop();
            _baseZoom = zoomScale;
            _baseRot = rotationAngle;
          },
          onDoubleTap: () => _animateTo(zoom: (zoomScale * 1.6).clamp(0.7, 6.0).toDouble()),
          onScaleUpdate: (d) => setState(() {
            if (d.pointerCount >= 2) {
              zoomScale = (_baseZoom * d.scale).clamp(0.7, 6.0);
              // небольшая «мёртвая зона», чтобы щипок не вращал карту случайно
              const dead = 0.1;
              final r = d.rotation.abs() < dead ? 0.0 : d.rotation - dead * d.rotation.sign;
              rotationAngle = _baseRot + r;
              if (is3DMode) {
                tiltAngle = (tiltAngle + d.focalPointDelta.dy * 0.005).clamp(-1.25, -0.1);
              }
            } else {
              pan += d.focalPointDelta;
            }
            pan = _clampPan(pan);
          }),
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, tiltAngle.abs() > 0.001 ? 0.0012 : 0.0)
                  ..translateByDouble(pan.dx, pan.dy, 0, 1)
                  ..rotateX(tiltAngle)
                  ..rotateZ(rotationAngle)
                  ..scaleByDouble(zoomScale, zoomScale, zoomScale, 1.0),
                child: AspectRatio(
                  aspectRatio: kAspect,
                  child: LayoutBuilder(builder: (ctx, bc) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: (d) => _onMapTap(d.localPosition, bc.biggest),
                    child: Stack(fit: StackFit.expand, children: [
                      RepaintBoundary(
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: _painter(floor, pal, 0),
                        ),
                      ),
                      CustomPaint(
                        size: Size.infinite,
                        painter: _painter(floor, pal, 1),
                      ),
                    ]),
                  )),
                ),
              ),
            ),
          ),
        )),

        // Верхняя панель
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              child: _glass(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [kMaiBlue, Color(0xFF4DA3FF)]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.navigation_rounded, size: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                          isEn.value
                              ? 'MAI · Building 3 · Floor ${floor.number}'
                              : 'МАИ · 3 корпус · ${floor.number} этаж',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Язык / Language',
                      icon: Text(isEn.value ? 'RU' : 'EN',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5)),
                      onPressed: () => setState(() => isEn.value = !isEn.value),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: pal.isDark ? tx('Светлая тема') : tx('Тёмная тема'),
                      icon: Icon(pal.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                      onPressed: () => themeMode.value = pal.isDark ? ThemeMode.light : ThemeMode.dark,
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.qr_code_scanner_rounded),
                      tooltip: tx('Сканировать QR'),
                      onPressed: _openQRScanner,
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _floorBar(pal),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: Column(children: [
                        _pill(tx('ОТКУДА'), startFloor, startNodeId, pal.start, () => _pick(true)),
                        const SizedBox(height: 6),
                        _pill(tx('КУДА'), endFloor, endNodeId, pal.end, () => _pick(false)),
                      ]),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filledTonal(
                      tooltip: tx('Поменять местами'),
                      icon: const Icon(Icons.swap_vert_rounded),
                      onPressed: () {
                        final t = startNodeId, tf = startFloor;
                        startNodeId = endNodeId;
                        startFloor = endFloor;
                        endNodeId = t;
                        endFloor = tf;
                        floorIdx = startFloor;
                        _calculateRoute();
                      },
                    ),
                  ]),
                ]),
              ),
            ),
          ),
        ),

        // Нижняя карточка
        Positioned(
          left: 14,
          right: 74,
          bottom: 18,
          child: SafeArea(
            top: false,
            child: _glass(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(
                      found
                          ? Icons.alt_route_rounded
                          : both
                              ? Icons.error_outline_rounded
                              : Icons.touch_app_rounded,
                      size: 18,
                      color: found ? pal.start : (both ? pal.end : pal.dim)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      found
                          ? '$from → $to'
                          : tx(both ? 'Маршрут не найден' : 'Выберите начало и конец маршрута'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (found && metersPerUnit > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: pal.accent.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('≈ $meters м', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)),
                    ),
                ]),
                if (segs.length > 1) _routeChips(pal),
                if (is3DMode)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      tx('1 палец — двигать · 2 пальца — масштаб и поворот · свайп двумя пальцами вверх/вниз — наклон'),
                      style: TextStyle(fontSize: 9.5, color: pal.dim),
                    ),
                  ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    _legendDot(pal.room.edge, tx('Аудитория')),
                    _legendDot(pal.stairs.edge, tx('Лестница')),
                    _legendDot(pal.wc.edge, tx('Санузел')),
                    _legendDot(pal.service.edge, tx('Сервис')),
                    _legendDot(pal.exit, tx('Выход')),
                  ]),
                ),
              ]),
            ),
          ),
        ),

        // Кнопки управления
        Positioned(
          right: 14,
          bottom: 22,
          child: SafeArea(
            top: false,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _circleBtn(
                'compass',
                Transform.rotate(
                  angle: rotationAngle,
                  child: Icon(Icons.navigation_rounded, size: 22, color: pal.end),
                ),
                _resetNorth,
              ),
              _circleBtn(
                'mode',
                Text(is3DMode ? '3D' : '2D',
                    style: TextStyle(color: pal.accentSoft, fontWeight: FontWeight.w800, fontSize: 13)),
                _toggle3D,
              ),
              _circleBtn('in', const Icon(Icons.add_rounded),
                  () => _animateTo(zoom: (zoomScale * 1.4).clamp(0.7, 6.0).toDouble())),
              _circleBtn('out', const Icon(Icons.remove_rounded),
                  () => _animateTo(zoom: (zoomScale / 1.4).clamp(0.7, 6.0).toDouble())),
              _circleBtn('reset', const Icon(Icons.my_location_rounded, size: 20), _resetView),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ============================================================================
// СКАНЕР QR
// ============================================================================

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});
  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _ctrl;
  bool _done = false; // защита от повторных срабатываний (иначе закроется лишний экран)
  bool _torchOn = false;
  bool _noPermission = false;

  @override
  void dispose() {
    // QRViewController освобождается сам при удалении QRView
    super.dispose();
  }

  void _onCreated(QRViewController c) {
    _ctrl = c;
    c.scannedDataStream.listen((scan) {
      final v = scan.code;
      if (v != null && v.trim().isNotEmpty) _finish(v);
    });
  }

  void _finish(String value) {
    if (_done || !mounted) return;
    _done = true;
    Navigator.of(context).pop(value);
  }

  Future<void> _manual() async {
    final c = TextEditingController();
    final v = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tx('Ввести код вручную'), style: const TextStyle(fontSize: 16)),
        content: TextField(
          controller: c,
          autofocus: true,
          decoration: InputDecoration(hintText: tx('например, Запад-1')),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(tx('Отмена'))),
          FilledButton(onPressed: () => Navigator.pop(ctx, c.text), child: const Text('OK')),
        ],
      ),
    );
    if (v != null && v.trim().isNotEmpty) _finish(v);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(tx('Сканирование QR'), style: const TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            tooltip: tx('Фонарик'),
            icon: Icon(_torchOn ? Icons.flashlight_off_rounded : Icons.flashlight_on_rounded),
            onPressed: () async {
              await _ctrl?.toggleFlash();
              if (mounted) setState(() => _torchOn = !_torchOn);
            },
          ),
          IconButton(
            tooltip: tx('Ввести код вручную'),
            icon: const Icon(Icons.keyboard_alt_outlined),
            onPressed: _manual,
          ),
        ],
      ),
      body: Stack(fit: StackFit.expand, children: [
        QRView(
          key: _qrKey,
          onQRViewCreated: _onCreated,
          formatsAllowed: const [BarcodeFormat.qrcode],
          overlay: QrScannerOverlayShape(
            borderColor: const Color(0xFF4DA3FF),
            borderRadius: 16,
            borderLength: 32,
            borderWidth: 8,
            cutOutSize: 250,
            overlayColor: const Color(0x99000000),
          ),
          onPermissionSet: (ctrl, granted) {
            if (!granted && mounted) setState(() => _noPermission = true);
          },
        ),
        if (_noPermission)
          Container(
            color: Colors.black87,
            padding: const EdgeInsets.all(28),
            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.no_photography_rounded, size: 44, color: Colors.white54),
              const SizedBox(height: 12),
              Text(
                tx('Нет доступа к камере.\nНастройки → Приложения → МАИ Навигатор → Разрешения → Камера.'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
              const SizedBox(height: 14),
              FilledButton.tonal(onPressed: _manual, child: Text(tx('Ввести код'))),
            ]),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 40,
          child: Text(
            tx('Наведите камеру на QR-код на стене'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
        ),
      ]),
    );
  }
}

// ============================================================================
// МЕНЮ (ФОТО)
// ============================================================================

class _MenuSheet extends StatefulWidget {
  final String title;
  final List<String> photos;
  const _MenuSheet({required this.title, required this.photos});
  @override
  State<_MenuSheet> createState() => _MenuSheetState();
}

class _MenuSheetState extends State<_MenuSheet> {
  final PageController _pc = PageController();
  int page = 0;

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  Widget _noPhoto(Pal pal, String path) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.image_not_supported_outlined, size: 44, color: pal.faint),
            const SizedBox(height: 10),
            Text(tx('Фото меню пока не добавлено'),
                textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: pal.dim)),
            const SizedBox(height: 4),
            Text(path, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: pal.faint)),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final pal = Pal.of(context);
    return FractionallySizedBox(
      heightFactor: 0.88,
      child: Column(children: [
        const SizedBox(height: 10),
        Container(width: 40, height: 4, decoration: BoxDecoration(color: pal.faint, borderRadius: BorderRadius.circular(2))),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 12, 6),
          child: Row(children: [
            Icon(Icons.restaurant_menu_rounded, color: pal.accentSoft),
            const SizedBox(width: 10),
            Expanded(
              child: Text('${widget.title} · ${tx('Меню')}',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            ),
            IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
          ]),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pc,
            itemCount: widget.photos.length,
            onPageChanged: (i) => setState(() => page = i),
            itemBuilder: (_, i) => InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    widget.photos[i],
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => _noPhoto(pal, widget.photos[i]),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.photos.length > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (int i = 0; i < widget.photos.length; i++)
                Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == page ? pal.accent : pal.faint,
                  ),
                ),
            ]),
          ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: const _FromToButtons(),
          ),
        ),
      ]),
    );
  }
}

class _FromToButtons extends StatelessWidget {
  const _FromToButtons();
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: FilledButton.tonalIcon(
          onPressed: () => Navigator.pop(context, 'from'),
          icon: const Icon(Icons.trip_origin_rounded),
          label: Text(tx('Отсюда')),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: FilledButton.icon(
          onPressed: () => Navigator.pop(context, 'to'),
          icon: const Icon(Icons.flag_rounded),
          label: Text(tx('Сюда')),
        ),
      ),
    ]);
  }
}

/// Небольшая панель при нажатии на аудиторию: построить маршрут отсюда или сюда.
class _PlaceSheet extends StatelessWidget {
  final String title;
  final int floor;
  const _PlaceSheet({required this.title, required this.floor});
  @override
  Widget build(BuildContext context) {
    final pal = Pal.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: pal.faint, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 14),
              child: Text(floorTitle(floor + 1), style: TextStyle(fontSize: 12, color: pal.dim)),
            ),
          ),
          const _FromToButtons(),
        ]),
      ),
    );
  }
}

// ============================================================================
// ВЫБОР ПОМЕЩЕНИЯ
// ============================================================================

class _PlacePicker extends StatefulWidget {
  final List<FloorData> floors;
  final int floorIdx;
  final String title;
  const _PlacePicker({required this.floors, required this.floorIdx, required this.title});
  @override
  State<_PlacePicker> createState() => _PlacePickerState();
}

class _PlacePickerState extends State<_PlacePicker> {
  String q = '';
  late int f = widget.floorIdx;

  String _norm(String s) => _latR(s.toLowerCase());

  @override
  Widget build(BuildContext context) {
    final nq = _norm(q);
    bool match(Place p) =>
        nq.isEmpty ||
        _norm(p.name).contains(nq) ||
        _norm(placeName(p)).contains(nq) ||
        _norm(p.label ?? '').contains(nq);
    final pal = Pal.of(context);
    final items = <Widget>[];
    // без запроса — выбранный этаж; с запросом — поиск по всем этажам
    final fl = q.isEmpty ? [f] : [for (int i = 0; i < widget.floors.length; i++) i];
    for (final fi in fl) {
      final all = widget.floors[fi].places.where(match).toList();
      final groups = <String, List<Place>>{
        tx('QR-точки'): all.where((p) => p.kind == PlaceKind.marker).toList(),
        tx('Выходы, лестницы, сервисы'):
            all.where((p) => p.kind != PlaceKind.room && p.kind != PlaceKind.marker).toList(),
        tx('Аудитории'): (all.where((p) => p.kind == PlaceKind.room && !p.unnumbered && !p.provisional).toList()
          ..sort((a, b) => a.name.compareTo(b.name))),
        tx('Номер условный (на плане не указан)'):
            (all.where((p) => p.provisional).toList()..sort((a, b) => a.name.compareTo(b.name))),
        tx('Без номера на плане'): all.where((p) => p.unnumbered).toList(),
      };
      groups.forEach((title, list) {
        if (list.isEmpty) return;
        items.add(Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
          child: Text((q.isEmpty ? title : '${floorTitle(fi + 1)} · $title').toUpperCase(),
              style: TextStyle(fontSize: 9.5, letterSpacing: 1, color: pal.faint, fontWeight: FontWeight.w700)),
        ));
        for (final p in list) {
          items.add(ListTile(
            dense: true,
            leading: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: pal.field, borderRadius: BorderRadius.circular(10)),
              child: Icon(_iconOf(p), size: 18, color: pal.accentSoft),
            ),
            title: Text(placeName(p), style: const TextStyle(fontSize: 13)),
            onTap: () => Navigator.of(context).pop('$fi|${p.id}'),
          ));
        }
      });
    }

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: FractionallySizedBox(
        heightFactor: 0.82,
        child: Column(children: [
          const SizedBox(height: 10),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: pal.faint, borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              autofocus: false,
              onChanged: (v) => setState(() => q = v.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: tx('Номер или название…'),
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: pal.field,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                isDense: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(children: [
              for (int i = 0; i < widget.floors.length; i++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i == widget.floors.length - 1 ? 0 : 6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => setState(() => f = i),
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: i == f && q.isEmpty ? pal.accent : pal.field,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(floorTitle(i + 1),
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: i == f && q.isEmpty ? Colors.white : pal.text)),
                      ),
                    ),
                  ),
                ),
            ]),
          ),
          Expanded(child: ListView(children: items)),
        ]),
      ),
    );
  }
}

// ============================================================================
// ОТРИСОВКА
// ============================================================================


class FloorPainter extends CustomPainter {
  final List<Place> places;
  final List<Corridor> corridors;
  final List<Block> blocks;
  final List<Rect> footprints;
  final Path outline;
  final List<RouteSeg> routes;
  final String startId, endId;
  final Pal pal;
  final bool is3D;
  final double viewRotation; // поворот карты: подписи компенсируют его
  final double viewZoom; // масштаб: мелкие подписи показываются только при приближении
  final Animation<double> anim;
  final int layer; // 0 — статичная карта (кэшируется), 1 — маршрут и анимации

  FloorPainter({
    required this.places,
    required this.corridors,
    required this.blocks,
    required this.footprints,
    required this.outline,
    required this.routes,
    required this.startId,
    required this.endId,
    required this.pal,
    required this.is3D,
    required this.viewRotation,
    required this.viewZoom,
    required this.anim,
    this.layer = 0,
  }) : super(repaint: layer == 1 ? anim : null);

  _Style _styleOf(Place p) {
    if (p.id == startId) return pal.startS;
    if (p.id == endId) return pal.endS;
    switch (p.id) {
      case 'hall':
        return pal.hall;
      case 'hall_big':
        return pal.big;
      case 'cowork':
        return pal.cowork;
    }
    switch (p.kind) {
      case PlaceKind.stairs:
        return pal.stairs;
      case PlaceKind.wc:
        return pal.wc;
      case PlaceKind.service:
        return pal.service;
      default:
        return p.unnumbered ? pal.unn : pal.room;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Разные масштабы по осям: план растянут по вертикали на kYStretch.
    final sx = size.width / kWorld.width;
    final sy = size.height / kWorld.height;
    final ox = -kWorld.left * sx;
    final oy = -kWorld.top * sy;
    Offset t(Offset o) => Offset(o.dx * sx + ox, o.dy * sy + oy);
    Rect tr(Rect r) => Rect.fromPoints(t(r.topLeft), t(r.bottomRight));
    final phase = anim.value;

    // Объём в 3D: комната остаётся ровно на своём месте, а объём передаётся
    // затемнёнными гранями внутри её контура (со стороны зрителя) и светлой кромкой
    // с дальней стороны. Никаких лишних фигур за пределами комнаты.
    final sinR = math.sin(viewRotation), cosR = math.cos(viewRotation);

    final labelJobs = <void Function()>[];

    void box(Rect w, _Style st,
        {String? label, bool bold = false, bool glow = false, double minFs = 7.0, double h = 0}) {
      final r = tr(w);
      final rr = RRect.fromRectAndRadius(r, const Radius.circular(2.5));
      if (glow) {
        canvas.drawRRect(
          rr.inflate(1.5),
          Paint()
            ..color = st.edge.withValues(alpha: 0.5)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
        );
      }
      canvas.drawRRect(
        rr,
        Paint()..shader = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [st.c1, st.c2]).createShader(r),
      );
      if (is3D && h > 0) {
        final thk = math.min(h * 0.45, math.min(r.width, r.height) * 0.3);
        final cs = [r.topLeft, r.topRight, r.bottomRight, r.bottomLeft];
        const ns = [Offset(0, -1), Offset(1, 0), Offset(0, 1), Offset(-1, 0)];
        final u = Offset(sinR, cosR); // «вниз по экрану» в координатах плана
        canvas.save();
        canvas.clipRRect(rr);
        for (int i = 0; i < 4; i++) {
          final n = ns[i];
          final nu = n.dx * u.dx + n.dy * u.dy;
          if (nu.abs() <= 0.02) continue;
          final p = cs[i], q = cs[(i + 1) % 4];
          final inward = Offset(-n.dx, -n.dy) * (nu > 0 ? thk * nu : thk * 0.35);
          final strip = Path()
            ..moveTo(p.dx, p.dy)
            ..lineTo(q.dx, q.dy)
            ..lineTo(q.dx + inward.dx, q.dy + inward.dy)
            ..lineTo(p.dx + inward.dx, p.dy + inward.dy)
            ..close();
          canvas.drawPath(
              strip,
              Paint()
                ..color = nu > 0
                    ? Color.lerp(st.c2, Colors.black, 0.22 + 0.2 * (1 - nu))!.withValues(alpha: 0.85)
                    : Colors.white.withValues(alpha: 0.1));
        }
        canvas.restore();
      }
      canvas.drawRRect(rr, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = glow ? 1.6 : 1.0
        ..color = st.edge);
      if (label != null) {
        labelJobs.add(() => _label(canvas, r, label, st.text, bold: bold, minScreenFs: minFs, force: glow));
      }
    }

    if (layer == 0) {
    // Контуры зданий (пол)
    // (подложки-контуры зданий не рисуем: они давали тёмные полосы вокруг комнат)

    // Коридоры + пунктир по центру
    for (final c in corridors) {
      final r = tr(c.rect);
      canvas.drawRRect(
        RRect.fromRectAndRadius(r, const Radius.circular(2)),
        Paint()..shader = LinearGradient(colors: [pal.corr1, pal.corr2]).createShader(r),
      );
      final a = t(c.at(c.from)), b = t(c.at(c.to));
      _dashed(canvas, a, b, Paint()
        ..color = pal.corrDash
        ..strokeWidth = 1.2, 7, 7);
    }

    // Помещения и блоки. В 3D рисуем от дальних к ближним, чтобы
    // передние объёмы перекрывали задние.
    final jobs = <MapEntry<double, void Function()>>[];
    void add(Rect w, void Function() draw) {
      final c = tr(w).center;
      jobs.add(MapEntry(c.dx * sinR + c.dy * cosR, draw));
    }

    for (final b in blocks) {
      final big = b.label == 'АМФИТЕАТР';
      add(b.rect, () => box(b.rect, b.label == 'ЛЕСТН.' ? pal.stairs : (b.label == null ? pal.room : pal.unn),
          label: b.label == null ? null : locLabel(b.label!), h: big ? 14 : 9));
    }
    for (final p in places) {
      if (p.rect == null) continue;
      final sel = p.id == startId || p.id == endId;
      add(p.rect!, () => box(p.rect!, _styleOf(p),
          label: p.label == null ? null : locLabel(p.label!),
          bold: sel || p.kind != PlaceKind.room,
          glow: sel,
          minFs: p.unnumbered ? 9.0 : 7.0,
          h: sel ? 13 : (p.id == 'hall_big' ? 14 : 9)));
    }
    if (is3D) jobs.sort((a, b) => a.key.compareTo(b.key));
    for (final j in jobs) {
      j.value();
    }
    // подписи поверх всех помещений, чтобы соседи их не перекрывали
    for (final l in labelJobs) {
      l();
    }

    // Контур корпуса по периметру аудиторий
    final op = outline.transform((Matrix4.identity()
          ..translateByDouble(ox, oy, 0, 1)
          ..scaleByDouble(sx, sy, 1, 1))
        .storage);
    canvas.drawPath(op, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeJoin = StrokeJoin.round
      ..color = pal.accent.withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
    canvas.drawPath(op, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeJoin = StrokeJoin.round
      ..color = pal.isDark ? pal.accentSoft.withValues(alpha: 0.75) : pal.accent.withValues(alpha: 0.8));

    // Значок «есть меню» (нажмите на помещение)
    for (final p in places) {
      if (p.rect == null || !kMenuPhotos.containsKey(p.id)) continue;
      final r = tr(p.rect!);
      _menuGlyph(canvas, r.topRight + const Offset(-7, 7), 9,
          p.id == startId || p.id == endId ? Colors.white : pal.service.text);
    }

    // QR-точки
    for (final p in places.where((p) => p.kind == PlaceKind.marker)) {
      final c = t(p.door!);
      final sel = p.id == startId;
      canvas.drawCircle(c, 11, Paint()
        ..color = pal.accent.withValues(alpha: sel ? 0.7 : 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
      canvas.drawCircle(c, 8.5, Paint()..color = pal.markerFill);
      canvas.drawCircle(c, 8.5, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = pal.accent);
      _qrGlyph(canvas, c, 11, pal.isDark ? Colors.white : kMaiBlue);
    }

    }
    if (layer == 1) {
    // Выходы
    for (final p in places.where((p) => p.kind == PlaceKind.exit)) {
      final c = t(p.door!);
      canvas.drawCircle(c, 5 + 7 * phase, Paint()..color = pal.exit.withValues(alpha: 0.35 * (1 - phase)));
      canvas.drawCircle(c, 5, Paint()..color = pal.exit);
      canvas.drawCircle(c, 2, Paint()..color = Colors.white);
      _label(canvas, Rect.fromCenter(center: c + Offset(13 * math.sin(viewRotation), 13 * math.cos(viewRotation)), width: 44, height: 9), locLabel('ВЫХОД'),
          pal.exit, bold: true, free: true);
    }

    // Маршрут (на этом этаже может быть один или несколько участков)
    for (final seg in routes) {
      if (seg.pts.length < 2) continue;
      final pts = seg.pts.map(t).toList();
      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final p in pts.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      final bounds = Rect.fromPoints(pts.first, pts.last).inflate(1);
      final grad = LinearGradient(colors: pal.route).createShader(bounds);

      canvas.drawPath(path, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = pal.routeGlow.withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
      canvas.drawPath(path, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..shader = grad);

      final dash = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round
        ..color = Colors.white.withValues(alpha: 0.9);
      for (final m in path.computeMetrics()) {
        for (double x = -24 + phase * 24; x < m.length; x += 24) {
          final a = x.clamp(0.0, m.length).toDouble();
          final b = (x + 8).clamp(0.0, m.length).toDouble();
          if (b > a) canvas.drawPath(m.extractPath(a, b), dash);
        }
      }

      void dot(Offset c, Color col) {
        canvas.drawCircle(c, 7 + 9 * phase, Paint()..color = col.withValues(alpha: 0.4 * (1 - phase)));
        canvas.drawCircle(c, 7, Paint()..color = col);
        canvas.drawCircle(c, 3, Paint()..color = Colors.white);
      }

      // переход между этажами: стрелка вверх/вниз и номер этажа
      // стрелка всегда смотрит по направлению движения маршрута
      void stairs(Offset c, String text, bool up, Offset dir) {
        canvas.drawCircle(c, 10 + 6 * phase, Paint()..color = pal.accent.withValues(alpha: 0.35 * (1 - phase)));
        canvas.drawCircle(c, 9, Paint()..color = pal.accent);
        canvas.save();
        canvas.translate(c.dx, c.dy);
        canvas.rotate(math.atan2(dir.dx, -dir.dy));
        final ar = Path()
          ..moveTo(0, -6)
          ..lineTo(5, 1)
          ..lineTo(1.7, 1)
          ..lineTo(1.7, 6)
          ..lineTo(-1.7, 6)
          ..lineTo(-1.7, 1)
          ..lineTo(-5, 1)
          ..close();
        canvas.drawPath(ar, Paint()..color = Colors.white);
        canvas.restore();
        _label(
            canvas,
            Rect.fromCenter(
                center: c + Offset(17 * math.sin(viewRotation), 17 * math.cos(viewRotation)),
                width: 44,
                height: 9),
            text,
            pal.isDark ? pal.accentSoft : pal.accent,
            bold: true,
            free: true);
      }

      if (seg.first) dot(pts.first, pal.start);
      if (seg.last) dot(pts.last, pal.end);
      Offset dirAt(bool start) {
        final o = start ? pts.first : pts.last;
        for (int i = 1; i < pts.length; i++) {
          final q = start ? pts[i] : pts[pts.length - 1 - i];
          final d = start ? q - o : o - q;
          if (d.distance > 1.5) return d;
        }
        return const Offset(0, -1);
      }

      if (seg.fromFloor != null) {
        stairs(pts.first, '${seg.fromFloor! + 1}\u2192', seg.fromFloor! > seg.floor, dirAt(true));
      }
      if (seg.toFloor != null) {
        stairs(pts.last, '${seg.toFloor! > seg.floor ? '\u2191' : '\u2193'}${seg.toFloor! + 1}',
            seg.toFloor! > seg.floor, dirAt(false));
      }
    }
      }
  }

  // Значки нарисованы векторно, а не шрифтом иконок: на web шрифт может
  // загрузиться уже после первой отрисовки, и значки пропадали.
  void _qrGlyph(Canvas canvas, Offset c, double size, Color color) {
    final u = size / 7;
    final p = Paint()..color = color;
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(-viewRotation);
    canvas.translate(-size / 2, -size / 2);
    void sq(double gx, double gy, double n) =>
        canvas.drawRect(Rect.fromLTWH(gx * u, gy * u, n * u, n * u), p);
    for (final g in const [Offset(0, 0), Offset(4, 0), Offset(0, 4)]) {
      sq(g.dx, g.dy, 3);
    }
    sq(4, 4, 1.5);
    sq(5.5, 5.5, 1.5);
    canvas.restore();
  }

  void _menuGlyph(Canvas canvas, Offset c, double size, Color color) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.14
      ..strokeCap = StrokeCap.round;
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(-viewRotation);
    final h = size * 0.5;
    // вилка
    canvas.drawLine(Offset(-size * 0.28, -h), Offset(-size * 0.28, h), p);
    canvas.drawLine(Offset(-size * 0.42, -h), Offset(-size * 0.42, -h * 0.2), p);
    canvas.drawLine(Offset(-size * 0.14, -h), Offset(-size * 0.14, -h * 0.2), p);
    // нож
    canvas.drawLine(Offset(size * 0.28, -h), Offset(size * 0.28, h), p);
    canvas.drawLine(Offset(size * 0.38, -h), Offset(size * 0.38, 0), p);
    canvas.restore();
  }

  void icon(Canvas canvas, IconData icon, Offset center, double size, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(fontSize: size, fontFamily: icon.fontFamily, package: icon.fontPackage, color: color),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-viewRotation);
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  void _dashed(Canvas c, Offset a, Offset b, Paint p, double dash, double gap) {
    final len = (b - a).distance;
    if (len == 0) return;
    final dir = (b - a) / len;
    for (double d = 0; d < len; d += dash + gap) {
      c.drawLine(a + dir * d, a + dir * math.min(d + dash, len), p);
    }
  }

  /// Подпись комнаты. Видна всегда: размер шрифта просто подбирается под
  /// комнату (чем меньше комната, тем мельче текст), а при приближении
  /// карты текст увеличивается вместе с ней.
  void _label(Canvas canvas, Rect r, String text, Color color,
      {bool bold = false,
      double maxFs = 8.0,
      bool free = false,
      bool force = false,
      double minScreenFs = 0}) {
    TextPainter lay(double f) => TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(color: color, fontSize: f, fontWeight: bold ? FontWeight.w800 : FontWeight.w600, letterSpacing: 0.1),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

    // Размеры комнаты так, как их видит пользователь (с учётом поворота карты).
    final cs = math.cos(viewRotation).abs(), sn = math.sin(viewRotation).abs();
    final ew = cs * r.width + sn * r.height;
    final eh = sn * r.width + cs * r.height;

    var f = free ? 7.5 : maxFs;
    var vertical = false;
    if (!free) {
      final w0 = lay(maxFs).width;
      // горизонтально или вдоль длинной стороны; высота букв не больше ~75% размера по другой оси
      final fH = math.min(math.min(maxFs, maxFs * ew * 0.94 / w0), eh * 0.75);
      final fV = math.min(math.min(maxFs, maxFs * eh * 0.94 / w0), ew * 0.75);
      vertical = fV > fH * 1.25;
      f = math.max(2.6, vertical ? fV : fH);
    }
    final tp = lay(f);
    canvas.save();
    canvas.translate(r.center.dx, r.center.dy);
    canvas.rotate(-viewRotation + (vertical ? -math.pi / 2 : 0));
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant FloorPainter old) {
    if (layer == 1) return true;
    return old.places != places ||
        old.blocks != blocks ||
        old.outline != outline ||
        old.startId != startId ||
        old.endId != endId ||
        old.pal != pal ||
        old.is3D != is3D ||
        old.viewRotation != viewRotation ||
        old.viewZoom != viewZoom;
  }
}
