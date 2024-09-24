part of 'init_dependencies.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initNewsFeed();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  getIt.registerLazySingleton(() => supabase.client);

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  getIt.registerFactory(() => InternetConnection());

  // Core
  getIt.registerLazySingleton(
    () => AppUserCubit(),
  );
  getIt.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      getIt(),
    ),
  );
}

void _initAuth() {
  // Datasource
  getIt
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        getIt(),
      ),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        getIt(),
        getIt(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UserSignup(
        getIt(),
      ),
    )
    ..registerFactory(
      () => UserSignin(
        getIt(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        getIt(),
      ),
    )
    ..registerFactory(
      () => UserSignout(
        getIt(),
      ),
    )
    // Bloc
    ..registerFactory(
      () => AuthBloc(
        userSignUp: getIt(),
        userSignin: getIt(),
        currentUser: getIt(),
        appUserBloc: getIt(),
        userSignOut: getIt(),
      ),
    );
}

void _initNewsFeed() {
  // Datasource
  getIt
    ..registerFactory<NewsFeedRemoteDataSource>(
      () => NewsFeedRemoteDataSourceImpl(
        getIt(),
      ),
    )
    ..registerFactory<NewsFeedLocalDataSource>(
      () => NewsFeedLocalDataSourceImpl(
        getIt(),
      ),
    )
    // Repository
    ..registerFactory<NewsFeedRepository>(
      () => NewsFeedRepositoryImpl(
        getIt(),
        getIt(),
        getIt(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UploadPost(
        getIt(),
      ),
    )
    ..registerFactory(
      () => GetAllPosts(
        getIt(),
      ),
    )
    ..registerFactory(
      () => GetAllStories(
        getIt(),
      ),
    )
    ..registerFactory(
      () => GetCommentsForPost(
        getIt(),
      ),
    )
    ..registerFactory(
      () => AddComment(
        getIt(),
      ),
    )
    ..registerFactory(
      () => UpdateComment(
        getIt(),
      ),
    )
    ..registerFactory(
      () => DeleteComment(
        getIt(),
      ),
    )

    // Bloc
    ..registerFactory(
      () => NewsFeedBloc(
        getAllPosts: getIt(),
        getAllStories: getIt(),
      ),
    )
    ..registerFactory(
      () => CommentsBloc(
        getCommentsForPost: getIt(),
        addComment: getIt(),
        updateComment: getIt(),
        deleteComment: getIt(),
      ),
    );
  getIt.registerFactory(
    () => PostUploadBloc(
      uploadPostUseCase: getIt(),
    ),
  );
}
