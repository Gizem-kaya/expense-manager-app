import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<String> getLanguages(BuildContext context) {
  return [
    AppLocalizations.of(context)!.turkish,
    AppLocalizations.of(context)!.english
  ];
}
