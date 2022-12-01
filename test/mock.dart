import 'package:postgrest_crud/postgrest_crud.dart';

class MockClass {
  int? id;
  MockClass({this.id});
}

class MockClassModel extends Model<MockClass> {
  @override
  String get modelName => "mock_class";

  @override
  String get primaryKey => "id";

  MockClassModel({required super.database});

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
