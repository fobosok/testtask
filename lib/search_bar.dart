// ignore_for_file: use_super_parameters, prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';

class SearchImageBar extends StatefulWidget {
  final Function(String) onSearch;

  const SearchImageBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  SearchImageBarState createState() => SearchImageBarState();

  void clearSearch() {}
}

class SearchImageBarState extends State<SearchImageBar> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    widget.onSearch(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        onSubmitted: widget.onSearch,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Search...',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ),
    );
  }

  void clearSearch() {
    _searchController.clear();
  }
}
