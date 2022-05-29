import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers.dart';

class SearchBar extends StatelessWidget {
  late TextEditingController _filter;
  late FocusNode _focus;
  
  SearchBar() {
    _filter = TextEditingController();
    _focus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
        child: Focus(
            onFocusChange: (focus) =>
                Provider.of<BarProvider>(context, listen: false)
                    .changeIcon(context, focus),
            child: TextField(
                controller: _filter,
                decoration: new InputDecoration(
                    hintText: 'Search...',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        Provider.of<MangaProvider>(context, listen: false)
                            .search(_filter.text);
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                    )))));
  }
}
