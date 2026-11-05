// أجندة — Flutter theme v1
// pubspec: google_fonts (Readex Pro). App: MaterialApp(locale: Locale('ar'), theme: AgendaTheme.light, darkTheme: AgendaTheme.dark)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AgendaColors extends ThemeExtension<AgendaColors> {
  final Color bg, surface, line, ink, ink2, accent, accentSoft, late, now, onNow, onNow2;
  const AgendaColors({
    required this.bg, required this.surface, required this.line, required this.ink, required this.ink2,
    required this.accent, required this.accentSoft, required this.late, required this.now,
    required this.onNow, required this.onNow2,
  });

  static const light = AgendaColors(
    bg: Color(0xFFEEEFF2), surface: Color(0xFFFFFFFF), line: Color(0xFFE6E8EC),
    ink: Color(0xFF111111), ink2: Color(0xFF7A808B), accent: Color(0xFFFF6A1F),
    accentSoft: Color(0xFFFFE6D9), late: Color(0xFFE2560F), now: Color(0xFF111111),
    onNow: Color(0xFFFFFFFF), onNow2: Color(0xFF9DA2AC),
  );
  static const dark = AgendaColors(
    bg: Color(0xFF0E0F12), surface: Color(0xFF1A1C21), line: Color(0xFF26292F),
    ink: Color(0xFFF2F3F5), ink2: Color(0xFF8E939C), accent: Color(0xFFFF7A33),
    accentSoft: Color(0xFF3A2216), late: Color(0xFFFF9A63), now: Color(0xFF1F2127),
    onNow: Color(0xFFF2F3F5), onNow2: Color(0xFF8E939C),
  );

  @override
  AgendaColors copyWith() => this;
  @override
  AgendaColors lerp(ThemeExtension<AgendaColors>? other, double t) => t < .5 ? this : (other as AgendaColors);
}

class AgendaRadius {
  static const card = 28.0, row = 24.0, sheet = 40.0, tile = 18.0, button = 14.0, seg = 14.0, segItem = 10.0;
  // 999 (كبسولة) للشريط العايم والمفاتيح بس. الزراير مستطيلة.
}

class AgendaSize {
  static const button = 52.0, segItem = 36.0, touchMin = 44.0, iconGlyph = 21.0, dock = 66.0;
  // أيكون لوحدها: IconButton(style: IconButton.styleFrom(backgroundColor: Colors.transparent)) — من غير إطار
}

class AgendaTheme {
  static TextTheme _text(Color ink) {
    final base = GoogleFonts.readexProTextTheme();
    const tab = [FontFeature.tabularFigures()];
    return base.copyWith(
      displayLarge: base.displayLarge!.copyWith(fontSize: 46, fontWeight: FontWeight.w300, height: 1.0, color: ink, fontFeatures: tab), // num-xl
      headlineLarge: base.headlineLarge!.copyWith(fontSize: 34, fontWeight: FontWeight.w500, height: 1.2, color: ink),  // title
      titleLarge: base.titleLarge!.copyWith(fontSize: 22, fontWeight: FontWeight.w500, height: 1.3, color: ink),         // heading
      bodyLarge: base.bodyLarge!.copyWith(fontSize: 15, fontWeight: FontWeight.w400, height: 1.6, color: ink),           // body
      bodySmall: base.bodySmall!.copyWith(fontSize: 12.5, fontWeight: FontWeight.w400, height: 1.5),                    // caption
    );
  }

  static ThemeData _build(AgendaColors c, Brightness b) => ThemeData(
        brightness: b,
        scaffoldBackgroundColor: c.bg,
        colorScheme: ColorScheme.fromSeed(seedColor: c.accent, brightness: b).copyWith(
          primary: c.accent, onPrimary: Colors.white, surface: c.surface, onSurface: c.ink, outline: c.line,
        ),
        textTheme: _text(c.ink),
        extensions: [c],
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, AgendaSize.button),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            // البرتقالي/الأسود: Ink(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFF7D36), Color(0xFFF45F15)]), boxShadow: [BoxShadow(color: Color(0xB3F25E14), blurRadius: 18, offset: Offset(0, 8), spreadRadius: -10)]))
            textStyle: GoogleFonts.readexPro(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: c.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AgendaRadius.sheet))),
        ),
        switchTheme: SwitchThemeData(
          trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.now : c.line),
          thumbColor: const WidgetStatePropertyAll(Colors.white),
        ),
      );

  static final light = _build(AgendaColors.light, Brightness.light);
  static final dark = _build(AgendaColors.dark, Brightness.dark);
}

/// الحلقة: برتقالي = محدش كلّمه لسه. تختفي أول ما يتكلّم.
class RingAvatar extends StatelessWidget {
  final ImageProvider image;
  final double size;
  final bool uncontacted;
  const RingAvatar({super.key, required this.image, this.size = 58, this.uncontacted = true});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AgendaColors>()!;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(shape: BoxShape.circle, color: uncontacted ? c.accent : Colors.transparent),
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: c.bg, width: 2.5)),
        child: CircleAvatar(radius: (size - 10) / 2, backgroundImage: image),
      ),
    );
  }
}

/// الحالة كلمة مش بادج: «متأخر / من يومين»، «السبت / 12:00»
class StatusWord extends StatelessWidget {
  final String word, meta;
  final bool late;
  const StatusWord({super.key, required this.word, required this.meta, this.late = false});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AgendaColors>()!;
    // أيكون صغيرة + كلمة في سطر واحد
    final color = late ? c.late : c.ink;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(late ? Icons.schedule : Icons.event_outlined, size: 14, color: color),
      const SizedBox(width: 6),
      Text('$word $meta', style: TextStyle(fontSize: 13, color: color, fontFeatures: const [FontFeature.tabularFigures()])),
    ]);
  }
}
