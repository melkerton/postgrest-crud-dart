import 'package:postgrest_crud/postgrest_crud.dart';

class MockClass {
  int? id;
  MockClass({this.id});
}

class MockClassClient extends Client<MockClass> {
  @override
  String get modelName => "mock_class";

  @override
  String get primaryKey => "id";

  MockClassClient({required super.connection});

  @override
  MockClass fromJson(JsonObject json) {
    return MockClass(id: json['id']);
  }

  @override
  JsonObject toJson(MockClass model) {
    JsonObject jsonObject = {};
    if (model.id != null) {
      jsonObject['id'] = model.id;
    }
    return jsonObject;
  }
}
