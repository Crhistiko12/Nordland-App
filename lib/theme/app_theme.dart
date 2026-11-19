import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

/// Paleta cromática oficial de Nordland.
///
/// La proporción recomendada por el manual de marca es:
/// 50% blancos y neutros, 25% azul/celeste, 15% verde y 10% acentos.
abstract final class NorlandColors {
  static const Color azulRey = Color(0xFF1A3E8C);
  static const Color celeste = Color(0xFF2998D5);
  static const Color verde = Color(0xFF58A944);
  static const Color naranja = Color(0xFFF27121);
  static const Color amarillo = Color(0xFFF8C629);
  static const Color rojo = Color(0xFFE53935);
  static const Color blanco = Color(0xFFFFFFFF);

  static const Color fondo = Color(0xFFF6F8FC);
  static const Color texto = Color(0xFF262C36);
  static const Color textoSecundario = Color(0xFF6D7685);
  static const Color borde = Color(0xFFE4EAF3);

  static const Color celesteSuave = Color(0xFFEAF5FC);
  static const Color verdeSuave = Color(0xFFEFF8EA);
  static const Color naranjaSuave = Color(0xFFFFF1E8);
  static const Color amarilloSuave = Color(0xFFFFF8E1);

  static const Color sombra = Color(0x1A1A3E8C);
}

/// Tokens de forma y espaciado reutilizados en toda la app.
abstract final class NorlandRadius {
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 22;
  static const double xl = 28;
  static const double pill = 100;
}

abstract final class AppTheme {
  static ThemeData get light {
    final ColorScheme colorScheme = const ColorScheme.light(
      primary: NorlandColors.azulRey,
      onPrimary: NorlandColors.blanco,
      primaryContainer: NorlandColors.celesteSuave,
      onPrimaryContainer: NorlandColors.azulRey,
      secondary: NorlandColors.celeste,
      onSecondary: NorlandColors.blanco,
      secondaryContainer: NorlandColors.celesteSuave,
      onSecondaryContainer: NorlandColors.azulRey,
      tertiary: NorlandColors.verde,
      onTertiary: NorlandColors.blanco,
      tertiaryContainer: NorlandColors.verdeSuave,
      onTertiaryContainer: NorlandColors.verde,
      error: NorlandColors.naranja,
      onError: NorlandColors.blanco,
      surface: NorlandColors.blanco,
      onSurface: NorlandColors.texto,
      onSurfaceVariant: NorlandColors.textoSecundario,
      outline: NorlandColors.borde,
      outlineVariant: NorlandColors.borde,
      shadow: NorlandColors.sombra,
      surfaceContainerHighest: NorlandColors.fondo,
    );

    final TextTheme base = GoogleFonts.nunitoTextTheme(
      ThemeData.light().textTheme,
    );

    final TextTheme textTheme = base.copyWith(
      displayLarge: GoogleFonts.fredoka(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: NorlandColors.azulRey,
        height: 1.08,
      ),
      displayMedium: GoogleFonts.fredoka(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: NorlandColors.azulRey,
        height: 1.1,
      ),
      headlineLarge: GoogleFonts.fredoka(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: NorlandColors.azulRey,
        height: 1.15,
      ),
      headlineMedium: GoogleFonts.fredoka(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: NorlandColors.azulRey,
        height: 1.18,
      ),
      headlineSmall: GoogleFonts.fredoka(
        fontSize: 21,
        fontWeight: FontWeight.w600,
        color: NorlandColors.azulRey,
        height: 1.2,
      ),
      titleLarge: GoogleFonts.fredoka(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: NorlandColors.azulRey,
        height: 1.2,
      ),
      titleMedium: GoogleFonts.fredoka(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: NorlandColors.azulRey,
        height: 1.25,
      ),
      titleSmall: GoogleFonts.fredoka(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: NorlandColors.azulRey,
        height: 1.25,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: NorlandColors.texto,
        height: 1.45,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: NorlandColors.texto,
        height: 1.45,
      ),
      bodySmall: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: NorlandColors.textoSecundario,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: NorlandColors.azulRey,
      ),
      labelMedium: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: NorlandColors.textoSecundario,
      ),
      labelSmall: GoogleFonts.nunito(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: NorlandColors.textoSecundario,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: NorlandColors.blanco,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: NorlandColors.blanco,
        foregroundColor: NorlandColors.azulRey,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: const IconThemeData(color: NorlandColors.azulRey),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(0, 52)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          elevation: const WidgetStatePropertyAll(0),
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(NorlandRadius.md),
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(0, 52)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          side: const WidgetStatePropertyAll(
            BorderSide(color: NorlandColors.celeste, width: 1.5),
          ),
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(NorlandRadius.md),
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800),
          ),
          foregroundColor: const WidgetStatePropertyAll(NorlandColors.celeste),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(NorlandRadius.sm),
            ),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(NorlandRadius.sm),
            ),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NorlandColors.fondo,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: GoogleFonts.nunito(
          fontSize: 14,
          color: NorlandColors.textoSecundario,
        ),
        labelStyle: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: NorlandColors.textoSecundario,
        ),
        prefixIconColor: NorlandColors.celeste,
        suffixIconColor: NorlandColors.celeste,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NorlandRadius.md),
          borderSide: const BorderSide(color: NorlandColors.borde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NorlandRadius.md),
          borderSide: const BorderSide(color: NorlandColors.borde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NorlandRadius.md),
          borderSide: const BorderSide(color: NorlandColors.verde, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NorlandRadius.md),
          borderSide: const BorderSide(color: NorlandColors.naranja),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NorlandRadius.md),
          borderSide: const BorderSide(
            color: NorlandColors.naranja,
            width: 1.6,
          ),
        ),
        errorStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: NorlandColors.naranja,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: NorlandColors.azulRey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NorlandRadius.md),
        ),
        contentTextStyle: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: NorlandColors.blanco,
        ),
        insetPadding: const EdgeInsets.all(16),
      ),
      cardTheme: CardThemeData(
        color: NorlandColors.blanco,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NorlandRadius.lg),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: NorlandColors.blanco,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: NorlandColors.blanco,
        modalBarrierColor: Color(0x66101828),
        showDragHandle: false,
      ),
      dividerTheme: const DividerThemeData(
        color: NorlandColors.borde,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: NorlandColors.verde,
      ),
    );
  }
}
