import 'package:fight_gym/config/app_config.dart';
import 'package:fight_gym/data/local_storage/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fight_gym/model/models.dart';

part 'configurations_provider.g.dart';

@Riverpod(keepAlive: true)
class AsyncConfigs extends _$AsyncConfigs {
    @override
    FutureOr<Configs> build() async {
        return _fetchData();
    }

    Future<Configs> _fetchData() async {
        SecureStorage secureStorage = SecureStorage();
        String themeMode = await secureStorage.readSecureData("themeMode");
        if (themeMode.isEmpty){
            themeMode = "dark";
            await secureStorage.writeSecureData("themeMode", "dark");
        }
        return Configs(theme: themeMode);
    }

    Function? setLocale;
    Function? getLocale;

    Future<void> setsetLocale(func) async {
        setLocale = func;
    }
    Future<void> setgetLocale(func) async {
        getLocale = func;
    }

    Future<void> updateInitialIndexLocaly(index) async {
        var theme = state.value?.theme;
        if (theme == null){
            AppConfig.logger.d("why theme is null inside updateInitialIndexLocaly????");
            theme = "dark";
        }
        state = AsyncValue.data(Configs(theme: theme));
    }
}
