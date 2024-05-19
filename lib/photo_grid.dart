// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/image_view_screen.dart';
import 'package:flutter_application_2/search_bar.dart';
import 'package:http/http.dart' as http;

class PhotoGrid extends StatefulWidget {
  const PhotoGrid({Key? key}) : super(key: key);

  @override
  _PhotoGridState createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
  List<String> _thumbnailUrls = [];
  List<String> _fullUrls = [];
  List<String> _searchThumbnailUrls = [];
  List<String> _searchFullUrls = [];
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;
  final GlobalKey<SearchImageBarState> _searchBarKey = GlobalKey();
  String _currentSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchPhotosRefresh();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_loading) {
        if (_currentSearchQuery.isEmpty) {
          _fetchPhotosAdd();
        } else {
          _fetchMoreSearchResults();
        }
      }
    }
  }

  Future<void> _fetchPhotosRefresh() async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    try {
      const String apiKey = 'gYL9j_iP1Xj8y1Y4fHHkID654x7iV7fOxaYvN5CHUHo';
      const String apiUrl =
          'https://api.unsplash.com/photos/random?count=10&client_id=$apiKey';

      final http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final List<String> newThumbnailUrls = [];
        final List<String> newFullUrls = [];

        for (var image in data) {
          newThumbnailUrls.add(image['urls']['small']);
          newFullUrls.add(image['urls']['full']);
        }

        setState(() {
          _thumbnailUrls = newThumbnailUrls;
          _fullUrls = newFullUrls;
          _searchThumbnailUrls.clear();
          _searchFullUrls.clear();
          _currentSearchQuery = '';
        });

        _searchBarKey.currentState?.clearSearch();
      } else {
        throw Exception('Failed to load images');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _fetchPhotosAdd() async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    try {
      const String apiKey = 'gYL9j_iP1Xj8y1Y4fHHkID654x7iV7fOxaYvN5CHUHo';
      const String apiUrl =
          'https://api.unsplash.com/photos/random?count=10&client_id=$apiKey';

      final http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final List<String> newThumbnailUrls = [];
        final List<String> newFullUrls = [];

        for (var image in data) {
          newThumbnailUrls.add(image['urls']['small']);
          newFullUrls.add(image['urls']['full']);
        }

        setState(() {
          _thumbnailUrls.addAll(newThumbnailUrls);
          _fullUrls.addAll(newFullUrls);
        });
      } else {
        throw Exception('Failed to load images');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _searchPhotos(String query) async {
    if (_loading) return;

    setState(() {
      _loading = true;
      _currentSearchQuery = query;
    });

    try {
      const String apiKey = 'gYL9j_iP1Xj8y1Y4fHHkID654x7iV7fOxaYvN5CHUHo';
      final String apiUrl =
          'https://api.unsplash.com/search/photos?query=$query&per_page=10&client_id=$apiKey';

      final http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body)['results'];

        final List<String> newThumbnailUrls = [];
        final List<String> newFullUrls = [];

        for (var image in data) {
          newThumbnailUrls.add(image['urls']['small']);
          newFullUrls.add(image['urls']['full']);
        }

        setState(() {
          _searchThumbnailUrls = newThumbnailUrls;
          _searchFullUrls = newFullUrls;
        });
      } else {
        throw Exception('Failed to search images');
      }
    } catch (error) {
      // Error handling
      if (kDebugMode) {
        print('Error: $error');
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _fetchMoreSearchResults() async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    try {
      const String apiKey = 'gYL9j_iP1Xj8y1Y4fHHkID654x7iV7fOxaYvN5CHUHo';
      final String apiUrl =
          'https://api.unsplash.com/search/photos?query=$_currentSearchQuery&per_page=10&client_id=$apiKey&page=${(_searchThumbnailUrls.length ~/ 10) + 1}';

      final http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body)['results'];

        final List<String> newThumbnailUrls = [];
        final List<String> newFullUrls = [];

        for (var image in data) {
          newThumbnailUrls.add(image['urls']['small']);
          newFullUrls.add(image['urls']['full']);
        }

        setState(() {
          _searchThumbnailUrls.addAll(newThumbnailUrls);
          _searchFullUrls.addAll(newFullUrls);
        });
      } else {
        throw Exception('Failed to search images');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearching = _currentSearchQuery.isNotEmpty;
    final List<String> displayedThumbnailUrls =
        isSearching ? _searchThumbnailUrls : _thumbnailUrls;
    final List<String> displayedFullUrls =
        isSearching ? _searchFullUrls : _fullUrls;

    return Column(
      children: [
        SearchImageBar(
          key: _searchBarKey,
          onSearch: _searchPhotos,
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _fetchPhotosRefresh,
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: displayedThumbnailUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ImageViewScreen(imageUrl: displayedFullUrls[index]),
                    ));
                  },
                  child: Hero(
                    tag: displayedFullUrls[index],
                    child: Image.network(
                      displayedThumbnailUrls[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
