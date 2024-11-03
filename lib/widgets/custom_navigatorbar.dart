import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';

class CustomNavigatorBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;

    return BottomNavigationBar(
      onTap: (int i) => uiProvider.selectedMenuOpt = i,
      currentIndex: currentIndex,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Mapa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.web),
          label: 'Direcciones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_library_outlined),
          label: 'YouTube',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.photo_camera),
          label: 'Posts',
        ),
      ],
    );
  }
}