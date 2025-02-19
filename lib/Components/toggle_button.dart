import 'package:flutter/material.dart';

class ToggleButtonsWidget extends StatelessWidget {
  final List<bool> isSelected;
  final ValueChanged<int> onPressed;

  ToggleButtonsWidget({required this.isSelected, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      height: 30,
      width: MediaQuery.of(context).size.width * 4.5,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: ToggleButtons(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        selectedBorderColor: Colors.transparent,
        selectedColor: Colors.black,
        fillColor: Colors.white,
        color: Colors.black,
        constraints: const BoxConstraints(
          minHeight: 40.0,
          minWidth: 160.0,
        ),
        borderColor: Colors.transparent,
        isSelected: isSelected,
        onPressed: onPressed,
        children: [
          _buildToggleButtonContent(
              'List view', Icons.view_list, isSelected[0]),
          _buildToggleButtonContent(
              'Tile view', Icons.grid_view, isSelected[1]),
        ],
      ),
    );
  }

  Widget _buildToggleButtonContent(
      String label, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
