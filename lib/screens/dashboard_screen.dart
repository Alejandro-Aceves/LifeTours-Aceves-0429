import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/usuario.dart';
import '../models/tour.dart';
import '../services/auth_service.dart';
import '../services/tour_service.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Usuario usuario;
  final AuthService authService;

  const DashboardScreen({
    super.key,
    required this.usuario,
    required this.authService,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const Color _primary = Color(0xFF0D6E5A);
  static const Color _primaryDark = Color(0xFF094D3F);
  static const Color _accent = Color(0xFF2DC8A0);
  static const Color _bg = Color(0xFFF4F7F5);
  static const Color _surface = Colors.white;
  static const Color _textDark = Color(0xFF0F1F1C);
  static const Color _textMuted = Color(0xFF6B8C84);
  static const Color _danger = Color(0xFFD32F2F);
  static const Color _dangerLight = Color(0xFFFFF0F0);

  final _tourService = TourService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _searchQuery = '';

  // ── BUILD ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      // Drawer disponible en todas las plataformas
      drawer: _buildDrawer(),
      appBar: _buildAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormularioTour(context),
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        tooltip: 'Nuevo Tour',
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          _buildPageHeader(),
          Expanded(child: _buildToursStream()),
        ],
      ),
    );
  }

  // ── APP BAR ───────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _primaryDark,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: Colors.white),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        tooltip: 'Menú',
      ),
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: const Icon(Icons.explore_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            'LifeTours',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        // Botón nuevo tour en la barra (escritorio)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: ElevatedButton.icon(
            onPressed: () => _mostrarFormularioTour(context),
            icon: const Icon(Icons.add_rounded, size: 16),
            label: Text(
              'Nuevo Tour',
              style: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              foregroundColor: _primaryDark,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ── DRAWER ────────────────────────────────────────────────

  Widget _buildDrawer() {
    return Drawer(
      width: 270,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_primaryDark, _primary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header del drawer
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.25)),
                          ),
                          child: const Icon(Icons.explore_rounded,
                              color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'LifeTours',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Panel Administrativo',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.6),
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(color: Colors.white.withOpacity(0.15), height: 1),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'MENÚ PRINCIPAL',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.45),
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Item de navegación
              _drawerItem(
                icon: Icons.explore_rounded,
                label: 'Tours',
                selected: true,
                onTap: () => Navigator.pop(context),
              ),

              const Spacer(),

              Divider(color: Colors.white.withOpacity(0.15), height: 1),

              // Info del usuario y cerrar sesión
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Text(
                            widget.usuario.nombre.isNotEmpty
                                ? widget.usuario.nombre[0].toUpperCase()
                                : 'A',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.usuario.nombre.isNotEmpty
                                    ? widget.usuario.nombre
                                    : 'Administrador',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                widget.usuario.correo,
                                style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.55),
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Botón cerrar sesión
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context); // Cierra el drawer
                          _cerrarSesion();
                        },
                        icon: const Icon(Icons.logout_rounded, size: 16),
                        label: Text(
                          'Cerrar sesión',
                          style: GoogleFonts.inter(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                              color: Colors.white.withOpacity(0.3)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          leading: Icon(
            icon,
            color: selected ? Colors.white : Colors.white.withOpacity(0.6),
            size: 20,
          ),
          title: Text(
            label,
            style: GoogleFonts.inter(
              color:
                  selected ? Colors.white : Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          dense: true,
          onTap: onTap,
        ),
      ),
    );
  }

  // ── BUSCADOR ──────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      color: _surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        style: GoogleFonts.inter(fontSize: 14, color: _textDark),
        decoration: InputDecoration(
          hintText: 'Buscar tours…',
          hintStyle: GoogleFonts.inter(fontSize: 14, color: _textMuted),
          prefixIcon: const Icon(Icons.search_rounded,
              color: _textMuted, size: 20),
          filled: true,
          fillColor: _bg,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  // ── HEADER ────────────────────────────────────────────────

  Widget _buildPageHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gestión de Tours',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Administra el catálogo completo de tours',
            style: GoogleFonts.inter(fontSize: 13, color: _textMuted),
          ),
        ],
      ),
    );
  }

  // ── STREAM DE TOURS ───────────────────────────────────────

  Widget _buildToursStream() {
    return StreamBuilder<List<Tour>>(
      stream: _tourService.obtenerTours(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: _primary));
        }
        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        final tours = (snapshot.data ?? []).where((t) {
          if (_searchQuery.isEmpty) return true;
          final q = _searchQuery.toLowerCase();
          return t.nombre.toLowerCase().contains(q) ||
              t.descripcion.toLowerCase().contains(q);
        }).toList();

        if (tours.isEmpty) return _buildEmptyState();

        return LayoutBuilder(builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          final crossAxisCount = constraints.maxWidth > 1000
              ? 3
              : constraints.maxWidth > 600
                  ? 2
                  : 1;

          if (!isWide) {
            // Lista en móvil
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
              itemCount: tours.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _buildTourCard(tours[i]),
            );
          }

          // Grid en escritorio/tablet
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: crossAxisCount == 1 ? 2.4 : 1.45,
            ),
            itemCount: tours.length,
            itemBuilder: (_, i) => _buildTourCard(tours[i]),
          );
        });
      },
    );
  }

  // ── TARJETA DE TOUR ───────────────────────────────────────

  Widget _buildTourCard(Tour tour) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_primary, _accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(Icons.map_outlined,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tour.nombre,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.schedule_outlined,
                              size: 12, color: _textMuted),
                          const SizedBox(width: 4),
                          Text(
                            tour.duracion,
                            style: GoogleFonts.inter(
                                fontSize: 12, color: _textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                tour.descripcion,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: _textMuted,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '\$${tour.precio.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _primary,
                    ),
                  ),
                ),
                const Spacer(),
                _iconBtn(
                  icon: Icons.edit_outlined,
                  color: _primary,
                  bgColor: _primary.withOpacity(0.08),
                  tooltip: 'Editar',
                  onTap: () => _mostrarFormularioTour(context, tour: tour),
                ),
                const SizedBox(width: 8),
                _iconBtn(
                  icon: Icons.delete_outline_rounded,
                  color: _danger,
                  bgColor: _dangerLight,
                  tooltip: 'Eliminar',
                  onTap: () => _confirmarEliminar(context, tour),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
              color: bgColor, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 17),
        ),
      ),
    );
  }

  // ── ESTADO VACÍO ──────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.explore_off_outlined,
                color: _primary, size: 36),
          ),
          const SizedBox(height: 20),
          Text(
            'No hay tours registrados',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea tu primer tour haciendo clic en el botón +',
            style: GoogleFonts.inter(fontSize: 14, color: _textMuted),
          ),
        ],
      ),
    );
  }

  // ── ESTADO ERROR ──────────────────────────────────────────

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_rounded, color: _danger, size: 48),
          const SizedBox(height: 16),
          Text(
            'Error al cargar los tours',
            style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _textDark),
          ),
          const SizedBox(height: 8),
          Text(
            error.replaceFirst('Exception: ', ''),
            style: GoogleFonts.inter(fontSize: 13, color: _textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── FORMULARIO CREAR / EDITAR ─────────────────────────────

  Future<void> _mostrarFormularioTour(BuildContext context,
      {Tour? tour}) async {
    final nombreCtrl = TextEditingController(text: tour?.nombre ?? '');
    final descCtrl = TextEditingController(text: tour?.descripcion ?? '');
    final precioCtrl = TextEditingController(
        text: tour != null ? tour.precio.toString() : '');
    final duracionCtrl =
        TextEditingController(text: tour?.duracion ?? '');
    final formKey = GlobalKey<FormState>();
    bool saving = false;
    String? errorMsg;

    await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final screenWidth = MediaQuery.of(ctx).size.width;
          final isMobileDialog = screenWidth < 600;

          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            elevation: 0,
            insetPadding: EdgeInsets.symmetric(
              horizontal: isMobileDialog ? 16 : 40,
              vertical: 24,
            ),
            child: SingleChildScrollView(
              child: Container(
                width: isMobileDialog ? double.infinity : 520,
                padding: EdgeInsets.all(isMobileDialog ? 20 : 32),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [_primary, _accent]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              tour == null
                                  ? Icons.add_location_alt_outlined
                                  : Icons.edit_location_alt_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            tour == null ? 'Nuevo Tour' : 'Editar Tour',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: _textDark,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close_rounded,
                                color: _textMuted, size: 20),
                            onPressed: () => Navigator.pop(ctx),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      _dialogLabel('Nombre del tour'),
                      const SizedBox(height: 6),
                      _dialogField(
                        controller: nombreCtrl,
                        hint: 'Ej: Tour por la Ciudad Histórica',
                        icon: Icons.explore_outlined,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'El nombre es requerido'
                                : null,
                      ),
                      const SizedBox(height: 16),

                      _dialogLabel('Descripción'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: descCtrl,
                        maxLines: 3,
                        style: GoogleFonts.inter(
                            fontSize: 14, color: _textDark),
                        decoration: _dialogInputDeco(
                          hint: 'Describe el tour…',
                          icon: Icons.description_outlined,
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'La descripción es requerida'
                                : null,
                      ),
                      const SizedBox(height: 16),

                      // Precio y duración
                      if (isMobileDialog) ...[
                        _dialogLabel('Precio (\$)'),
                        const SizedBox(height: 6),
                        _dialogField(
                          controller: precioCtrl,
                          hint: 'Ej: 150.00',
                          icon: Icons.attach_money_rounded,
                          keyboardType:
                              const TextInputType.numberWithOptions(
                                  decimal: true),
                          validator: _validarPrecio,
                        ),
                        const SizedBox(height: 16),
                        _dialogLabel('Duración'),
                        const SizedBox(height: 6),
                        _dialogField(
                          controller: duracionCtrl,
                          hint: 'Ej: 3 horas',
                          icon: Icons.schedule_outlined,
                          validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Requerido'
                                  : null,
                        ),
                      ] else
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _dialogLabel('Precio (\$)'),
                                  const SizedBox(height: 6),
                                  _dialogField(
                                    controller: precioCtrl,
                                    hint: 'Ej: 150.00',
                                    icon: Icons.attach_money_rounded,
                                    keyboardType: const TextInputType
                                        .numberWithOptions(decimal: true),
                                    validator: _validarPrecio,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _dialogLabel('Duración'),
                                  const SizedBox(height: 6),
                                  _dialogField(
                                    controller: duracionCtrl,
                                    hint: 'Ej: 3 horas',
                                    icon: Icons.schedule_outlined,
                                    validator: (v) =>
                                        (v == null || v.trim().isEmpty)
                                            ? 'Requerido'
                                            : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                      if (errorMsg != null) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: _dangerLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: const Color(0xFFFFCDD2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline,
                                  color: _danger, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(errorMsg!,
                                    style: GoogleFonts.inter(
                                        fontSize: 12, color: _danger)),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: TextButton.styleFrom(
                              foregroundColor: _textMuted,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            child: Text('Cancelar',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: saving
                                ? null
                                : () async {
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    }
                                    setDialogState(() {
                                      saving = true;
                                      errorMsg = null;
                                    });
                                    try {
                                      final nuevoTour = Tour(
                                        id: tour?.id ?? '',
                                        nombre: nombreCtrl.text.trim(),
                                        descripcion: descCtrl.text.trim(),
                                        precio: double.parse(precioCtrl.text),
                                        duracion: duracionCtrl.text.trim(),
                                      );
                                      if (tour == null) {
                                        await _tourService.crearTour(nuevoTour);
                                      } else {
                                        await _tourService.actualizarTour(nuevoTour);
                                      }
                                      if (ctx.mounted) Navigator.pop(ctx);
                                    } catch (e) {
                                      setDialogState(() {
                                        saving = false;
                                        errorMsg = e.toString().replaceFirst('Exception: ', '');
                                      });
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              disabledBackgroundColor:
                                  _primary.withOpacity(0.6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: saving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white),
                                  )
                                : Text(
                                    tour == null
                                        ? 'Crear Tour'
                                        : 'Guardar Cambios',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String? _validarPrecio(String? v) {
    if (v == null || v.trim().isEmpty) return 'Requerido';
    if (double.tryParse(v) == null) return 'Número inválido';
    return null;
  }

  // ── CONFIRMAR ELIMINACIÓN ─────────────────────────────────

  Future<void> _confirmarEliminar(BuildContext context, Tour tour) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                    color: _dangerLight, shape: BoxShape.circle),
                child: const Icon(Icons.delete_outline_rounded,
                    color: _danger, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                '¿Eliminar tour?',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Estás a punto de eliminar "${tour.nombre}". Esta acción no se puede deshacer.',
                style: GoogleFonts.inter(fontSize: 14, color: _textMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _textMuted,
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Cancelar',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _danger,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Eliminar',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmado == true) {
      try {
        await _tourService.eliminarTour(tour.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tour "${tour.nombre}" eliminado',
                  style: GoogleFonts.inter(fontSize: 13)),
              backgroundColor: _primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Error: ${e.toString().replaceFirst("Exception: ", "")}',
                  style: GoogleFonts.inter(fontSize: 13)),
              backgroundColor: _danger,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      }
    }
  }

  // ── CERRAR SESIÓN ─────────────────────────────────────────

  void _cerrarSesion() {
    widget.authService.cerrarSesion();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  // ── HELPERS DE FORMULARIO ─────────────────────────────────

  Widget _dialogLabel(String text) => Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _textDark,
          letterSpacing: 0.3,
        ),
      );

  Widget _dialogField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) =>
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(fontSize: 14, color: _textDark),
        decoration: _dialogInputDeco(hint: hint, icon: icon),
        validator: validator,
      );

  InputDecoration _dialogInputDeco(
          {required String hint, required IconData icon}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
            fontSize: 13, color: _textMuted.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: _textMuted, size: 18),
        filled: true,
        fillColor: _bg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0EBE8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0EBE8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _danger, width: 1.5),
        ),
      );
}