import 'package:flutter/material.dart';
import 'package:houszscore/Utils/tagCategory.dart';

class NoteWithTagsModal extends StatefulWidget {
  final String section;
  final List<String> initialSelectedTags;
  final Function(String note, List<String> tags) onSave;

  const NoteWithTagsModal({
    Key? key,
    required this.section,
    required this.initialSelectedTags,
    required this.onSave,
  }) : super(key: key);

  @override
  _NoteWithTagsModalState createState() => _NoteWithTagsModalState();
}

class _NoteWithTagsModalState extends State<NoteWithTagsModal> {
  late TextEditingController _noteController;
  late List<String> _selectedTags;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _selectedTags = List.from(widget.initialSelectedTags);
  }

  void _toggleTag(String tagName) {
    setState(() {
      _selectedTags.contains(tagName)
          ? _selectedTags.remove(tagName)
          : _selectedTags.add(tagName);
    });
  }

  void _showTagsSelector() {
    final sectionData = sectionTags[widget.section];
    if (sectionData == null) return;

    final allTags = [
      ...sectionData.positive.tags,
      ...sectionData.negative.tags,
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildModalHeader(),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: allTags.length,
                  itemBuilder: (context, index) {
                    final tagName = allTags[index];
                    final isSelected = _selectedTags.contains(tagName);
                    final tagColor = sectionData.positive.tags.contains(tagName)
                        ? sectionData.positive.color
                        : sectionData.negative.color;

                    return ListTile(
                      title: Text(tagName),
                      trailing: Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? Colors.blue : Colors.grey,
                      ),
                      onTap: () => _toggleTag(tagName),
                      tileColor: tagColor.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        Text(
          "${widget.section} Tags",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Done",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final sectionData = sectionTags[widget.section];

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
                const Text(
                  "My Notes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    widget.onSave(_noteController.text, _selectedTags);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (sectionData == null)
              Center(
                child: Text(
                  'No tags available for ${widget.section}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            else
              Wrap(
                spacing: 8,
                children: _selectedTags
                    .map(
                      (tag) => Chip(
                        label: Text(tag),
                        backgroundColor: sectionData.positive.tags.contains(tag)
                            ? sectionData.positive.color
                            : sectionData.negative.color,
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          setState(() {
                            _selectedTags.remove(tag);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showTagsSelector,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[50],
                foregroundColor: Colors.blue,
                elevation: 0,
              ),
              child: const Text("Set Tags"),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _noteController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Write your note here...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
