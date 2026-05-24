import 'package:flutter/material.dart';
import 'package:test_demo_app/core/widgets/organisms/my_section_header.dart';

import 'showcases/showcase_atoms.dart';
import 'showcases/showcase_molecules.dart';
import 'showcases/showcase_organisms.dart';
import 'showcases/showcase_forms.dart';

class DevWidgetsList extends StatelessWidget {
  const DevWidgetsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32),
        const MySectionHeader(
          title: 'Catálogo de Componentes (UI Kit)',
          subtitle: 'Visualización de los widgets atómicos, moleculares, organismos y formularios.',
          icon: Icons.widgets_rounded,
        ),
        const SizedBox(height: 24),

        const ShowcaseAtoms(),
        const ShowcaseMolecules(),
        const ShowcaseOrganisms(),
        const ShowcaseForms(),
      ],
    );
  }
}
