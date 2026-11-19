import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/services.dart' show TextInput;
import 'package:material_ui/material_ui.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/google_logo.dart';
import '../widgets/nordland_logo.dart';

enum _ModoAcceso { login, registro }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final FocusNode _nombreFocus = FocusNode();
  final FocusNode _correoFocus = FocusNode();
  final FocusNode _contrasenaFocus = FocusNode();

  late final StreamSubscription<User?> _suscripcionSesion;

  _ModoAcceso _modo = _ModoAcceso.login;
  bool _cargando = false;
  bool _verContrasena = false;
  bool _saliendo = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _suscripcionSesion = AuthService.instance.cambiosDeSesion.listen((
      User? usuario,
    ) {
      if (usuario != null) _volverAlInicio();
    });
  }

  @override
  void dispose() {
    _suscripcionSesion.cancel();
    _nombreController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    _nombreFocus.dispose();
    _correoFocus.dispose();
    _contrasenaFocus.dispose();
    super.dispose();
  }

  void _cambiarModo(_ModoAcceso modo) {
    if (_modo == modo || _cargando) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _modo = modo;
      _error = null;
    });
  }

  void _volverAlInicio() {
    if (!mounted || _saliendo) return;
    _saliendo = true;
    Navigator.of(context).popUntil((Route<dynamic> route) => route.isFirst);
  }

  Future<void> _enviar() async {
    if (_cargando) return;
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      if (_modo == _ModoAcceso.login) {
        await AuthService.instance.iniciarSesion(
          correo: _correoController.text,
          contrasena: _contrasenaController.text,
        );
      } else {
        await AuthService.instance.registrar(
          nombre: _nombreController.text,
          correo: _correoController.text,
          contrasena: _contrasenaController.text,
        );
      }
      TextInput.finishAutofillContext();
      _volverAlInicio();
    } on AuthServiceException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.mensaje);
    } finally {
      if (mounted && !_saliendo) {
        setState(() => _cargando = false);
      }
    }
  }

  Future<void> _continuarConGoogle() async {
    if (_cargando) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final bool inicio = await AuthService.instance.iniciarSesionConGoogle();
      if (inicio) _volverAlInicio();
    } on AuthServiceException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.mensaje);
    } finally {
      if (mounted && !_saliendo) {
        setState(() => _cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool esRegistro = _modo == _ModoAcceso.registro;
    final double teclado = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: NorlandColors.fondo,
      appBar: AppBar(
        backgroundColor: NorlandColors.fondo,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const NordlandLogo(height: 27),
        actions: const <Widget>[SizedBox(width: 48)],
      ),
      body: Stack(
        children: <Widget>[
          const Positioned(top: -150, right: -130, child: _HaloAcceso()),
          SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 28 + teclado),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        esRegistro ? 'Crea tu cuenta' : 'Bienvenido de nuevo',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        esRegistro
                            ? 'Compra para ti o surte tu negocio con Nordland.'
                            : 'Ingresa para comprar, revender y seguir tus pedidos.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: NorlandColors.textoSecundario),
                      ),
                      const SizedBox(height: 22),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: NorlandColors.blanco,
                          borderRadius: BorderRadius.circular(NorlandRadius.xl),
                          border: Border.all(color: NorlandColors.borde),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: NorlandColors.azulRey.withValues(
                                alpha: 0.07,
                              ),
                              blurRadius: 26,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: AutofillGroup(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                _SelectorModo(
                                  modo: _modo,
                                  onCambiar: _cambiarModo,
                                ),
                                const SizedBox(height: 18),
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 180),
                                  alignment: Alignment.topCenter,
                                  child: esRegistro
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: TextFormField(
                                            controller: _nombreController,
                                            focusNode: _nombreFocus,
                                            enabled: !_cargando,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            textInputAction:
                                                TextInputAction.next,
                                            autofillHints: const <String>[
                                              AutofillHints.name,
                                            ],
                                            decoration: const InputDecoration(
                                              labelText: 'Nombre completo',
                                              prefixIcon: Icon(
                                                Icons.person_outline_rounded,
                                              ),
                                            ),
                                            validator: validarNombre,
                                            onFieldSubmitted: (_) =>
                                                _correoFocus.requestFocus(),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                                TextFormField(
                                  controller: _correoController,
                                  focusNode: _correoFocus,
                                  enabled: !_cargando,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autocorrect: false,
                                  autofillHints: const <String>[
                                    AutofillHints.email,
                                  ],
                                  decoration: const InputDecoration(
                                    labelText: 'Correo electrónico',
                                    prefixIcon: Icon(
                                      Icons.mail_outline_rounded,
                                    ),
                                  ),
                                  validator: validarCorreo,
                                  onFieldSubmitted: (_) =>
                                      _contrasenaFocus.requestFocus(),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _contrasenaController,
                                  focusNode: _contrasenaFocus,
                                  enabled: !_cargando,
                                  obscureText: !_verContrasena,
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  autofillHints: <String>[
                                    esRegistro
                                        ? AutofillHints.newPassword
                                        : AutofillHints.password,
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Contraseña',
                                    prefixIcon: const Icon(
                                      Icons.lock_outline_rounded,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: _cargando
                                          ? null
                                          : () => setState(
                                              () => _verContrasena =
                                                  !_verContrasena,
                                            ),
                                      tooltip: _verContrasena
                                          ? 'Ocultar contraseña'
                                          : 'Mostrar contraseña',
                                      icon: Icon(
                                        _verContrasena
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                      ),
                                    ),
                                  ),
                                  validator: validarContrasena,
                                  onFieldSubmitted: (_) => _enviar(),
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 180),
                                  child: _error == null
                                      ? const SizedBox.shrink()
                                      : Padding(
                                          key: ValueKey<String>(_error!),
                                          padding: const EdgeInsets.only(
                                            top: 14,
                                          ),
                                          child: _MensajeError(
                                            mensaje: _error!,
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 18),
                                FilledButton(
                                  onPressed: _cargando ? null : _enviar,
                                  style: FilledButton.styleFrom(
                                    minimumSize: const Size.fromHeight(54),
                                    backgroundColor: NorlandColors.azulRey,
                                    foregroundColor: NorlandColors.blanco,
                                  ),
                                  child: _cargando
                                      ? const SizedBox(
                                          width: 21,
                                          height: 21,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.3,
                                            color: NorlandColors.blanco,
                                          ),
                                        )
                                      : Text(
                                          esRegistro
                                              ? 'Registrarse'
                                              : 'Iniciar sesión',
                                        ),
                                ),
                                const SizedBox(height: 18),
                                const _Separador(),
                                const SizedBox(height: 18),
                                OutlinedButton.icon(
                                  onPressed: _cargando
                                      ? null
                                      : _continuarConGoogle,
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(54),
                                    backgroundColor: NorlandColors.blanco,
                                    foregroundColor: NorlandColors.azulRey,
                                    side: const BorderSide(
                                      color: NorlandColors.borde,
                                    ),
                                  ),
                                  icon: const GoogleLogo(size: 20),
                                  label: const Text('Continuar con Google'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tus datos se usan únicamente para gestionar tu cuenta '
                        'y tus pedidos Nordland.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectorModo extends StatelessWidget {
  const _SelectorModo({required this.modo, required this.onCambiar});

  final _ModoAcceso modo;
  final ValueChanged<_ModoAcceso> onCambiar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: NorlandColors.fondo,
        borderRadius: BorderRadius.circular(NorlandRadius.md),
        border: Border.all(color: NorlandColors.borde),
      ),
      child: Row(
        children: <Widget>[
          _OpcionModo(
            texto: 'Iniciar sesión',
            seleccionado: modo == _ModoAcceso.login,
            onTap: () => onCambiar(_ModoAcceso.login),
          ),
          _OpcionModo(
            texto: 'Registrarse',
            seleccionado: modo == _ModoAcceso.registro,
            onTap: () => onCambiar(_ModoAcceso.registro),
          ),
        ],
      ),
    );
  }
}

class _OpcionModo extends StatelessWidget {
  const _OpcionModo({
    required this.texto,
    required this.seleccionado,
    required this.onTap,
  });

  final String texto;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: seleccionado ? NorlandColors.azulRey : Colors.transparent,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Text(
              texto,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: seleccionado
                    ? NorlandColors.blanco
                    : NorlandColors.textoSecundario,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MensajeError extends StatelessWidget {
  const _MensajeError({required this.mensaje});

  final String mensaje;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: NorlandColors.naranjaSuave,
          borderRadius: BorderRadius.circular(NorlandRadius.sm),
          border: Border.all(
            color: NorlandColors.naranja.withValues(alpha: 0.28),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Icon(
              Icons.error_outline_rounded,
              size: 18,
              color: NorlandColors.naranja,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                mensaje,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: NorlandColors.naranja,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Separador extends StatelessWidget {
  const _Separador();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'o',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: NorlandColors.textoSecundario,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _HaloAcceso extends StatelessWidget {
  const _HaloAcceso();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 330,
        height: 330,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[
              NorlandColors.celesteSuave,
              NorlandColors.celesteSuave.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
