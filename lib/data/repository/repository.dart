import 'package:flutter/cupertino.dart';
import 'package:todo_list/data/source/source.dart';

class Repository<T> with ChangeNotifier implements DataSource<T> {
  ///Dependency Injection by Named Constructor
  final DataSource<T> localDataSource;

  Repository({required this.localDataSource});

  ///Override All Of Functions in Abstract DataSource Class
  @override
  Future<T> createOrUpdate({T? data}) async {
    final T result = await localDataSource.createOrUpdate(data: data as T);
    notifyListeners();
    return result;
  }

  @override
  Future<void> delete({T? data}) async {
    await localDataSource.delete(data: data as T);
    notifyListeners();
  }

  @override
  Future<void> deleteAll() async {
    await localDataSource.deleteAll();
    notifyListeners();
  }

  @override
  Future<void> deleteById({id}) async {
    await localDataSource.deleteById(id: id);
    notifyListeners();
  }

  @override
  Future<T> findById({id}) async {
    final result = await localDataSource.findById(id: id);
    notifyListeners();
    return result;
  }

  @override
  Future<List<T>> getAll({String searchByKeyword = ""}) async {
    final result =
        await localDataSource.getAll(searchByKeyword: searchByKeyword);
    return result;
  }
}
