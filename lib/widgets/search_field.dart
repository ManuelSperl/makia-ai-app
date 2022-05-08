import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as flutterSettings;

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/models/camera.dart';
import 'package:makia_ai/providers/camera_list.dart';
import 'package:makia_ai/screens/cameras/camera_detail_screen.dart';
import 'package:makia_ai/screens/settings/settings_screen.dart';

/*
    Renders the Search-Field Widget
 */
class SearchField extends StatefulWidget {
  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final isDarkMode = flutterSettings.Settings.getValue(SettingsScreen.keyDarkMode, true);
  static List<Camera> _cameras;
  static List<String> _camerasTitleList;
  static List<String> _recentCamerasClicked;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          hintText: "Search Camera",
          fillColor: isDarkMode ? darkModeSecondaryColor : lightModeSecondaryColor,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: const BorderRadius.all(Radius.circular(defaultRadius),),
          ),
          suffixIcon: InkWell(
            child: Container(
              padding: const EdgeInsets.all(defaultPadding * 0.5),
              margin: const EdgeInsets.all(defaultPadding / 2),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(defaultRadius),),
              ),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            onTap: () async {
              _cameras = await Provider.of<CameraList>(context, listen: false).cameras;
              _camerasTitleList = _setCamerasTitleList();
              _recentCamerasClicked = await Provider.of<CameraSearch>(context, listen: false).recentCamerasClicked;

              showSearch(
                context: context,
                delegate: CameraSearch(
                  cameras: _cameras,
                  camerasTitleList: _camerasTitleList,
                  recentCamerasClickedFromConstructor: _recentCamerasClicked,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<String> _setCamerasTitleList() {
    List<String> titleList = [];

    if (_cameras.isNotEmpty) {
      _cameras.forEach((camera) {
        titleList.add(camera.deviceName);
      });
    } else {
      print('No Data in cameras-List');

      titleList = ['No Data available yet!'];
    }

    return titleList;
  }
}

/*
    Renders the Camera-Search Widget
 */
class CameraSearch extends SearchDelegate<String> with ChangeNotifier {
  final isDarkMode = flutterSettings.Settings.getValue(SettingsScreen.keyDarkMode, true);
  final List<Camera> cameras;
  final List<String> camerasTitleList;
  final List<String> recentCamerasClickedFromConstructor;
  List<String> _recentCamerasClicked = [];

  CameraSearch({
    this.cameras,
    this.camerasTitleList,
    this.recentCamerasClickedFromConstructor,
  });

  List<String> get recentCamerasClicked {
    return _recentCamerasClicked;
  }

  void _setRecentCamerasClicked(List<String> recentCamerasClickedNew) {
    _recentCamerasClicked = recentCamerasClickedNew;
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
              showSuggestions(context);
            }
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _setRecentCamerasClicked(recentCamerasClickedFromConstructor);

    final suggestions = query.isEmpty
        ? recentCamerasClicked
        : camerasTitleList.where((camera) {
            final cameraLower = camera.toLowerCase();
            final queryLower = query.toLowerCase();

            return cameraLower.startsWith(queryLower);
          }).toList();

    final iconBoolRecentList = query.isEmpty ? true : false;

    return _buildSuggestionsSuccess(suggestions, iconBoolRecentList);
  }

  Widget _buildSuggestionsSuccess(List<String> suggestions, bool iconBoolRecentList) {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        final queryText = suggestion.substring(0, query.length);
        final remainingText = suggestion.substring(query.length);

        return ListTile(
          leading: iconBoolRecentList == true ? const Icon(Icons.history) : const Icon(Icons.videocam),
          title: RichText(
            text: TextSpan(
              text: queryText,
              style: TextStyle(
                color: isDarkMode ? darkModeTextColor : lightModeTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: [
                TextSpan(
                  text: remainingText,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            query = suggestion;

            _openClickedCamera(context, suggestion);
          },
        );
      },
    );
  }

  void _addToRecentClickedList(String suggestion) {
    if (!_recentCamerasClicked.contains(suggestion)) {
      _recentCamerasClicked.insert(0, suggestion);
    } else {
      _recentCamerasClicked.remove(suggestion);
      _recentCamerasClicked.insert(0, suggestion);
    }
  }

  void _openClickedCamera(BuildContext context, String suggestion) {
    if (cameras.isNotEmpty) {
      cameras.forEach((camera) {
        if (camera.deviceName == suggestion) {
          _addToRecentClickedList(suggestion);

          Navigator.of(context).pushReplacementNamed(
            CameraDetailScreen.routeName,
            arguments: {
              'selectedCamera': camera,
              'returnToHomeScreen': true,
            },
          );
        }
      });

    } else {
      close(context, suggestion);
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }
}
