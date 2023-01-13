## Postgrest Crud

A [Postgrest](https://postgrest.org) client that provides create, recall, update, and delete operations with support for batch operations via createBatch, updateBatch, and deleteBatch.

This package is intended to provide a quick and simple way to add connection support for Postgrest to an existing application. The requirements on the class representing a table record are meant to be minimal and mostly agnostic about the details of that class.

## Additional information

Still in early stages and very experimental.

## Motivation

The primary reason for developing this package is to provide a quick way to connect to a Postgrest API server. While there already exists an ORM-like package ([Postgrest Dart](https://pub.dev/packages/postgrest)) that provides this functionality it does not meet the requirements I was looking for in a package like this. This package attempts to abstract some of the repetitive patterns that occur when using an ORM-like approach. e.g.

```
client.from("table").select<PostgrestList>().withConverter(() => {})
```

can be reduced to

```
client.recall()
```

The secondary reason for this package is to abstract the conversion process between concrete class and json representation. While `Postgrest Dart` provides something similar to this via a `withConverter` method I wanted something that was more transparent and contained additional paging related information.

### Roadmap

-   Add support for Compound query operations e.g. ?and=(a.eq.b,or(c.eq.d))
-   Add flexible logging facility.
-   Review bearerToken implementation, possibly add an auth method to Connection.

## Setup

-   Create a class (`Class`) that represents a table in your PostgreSQL database.
    -   The only requirement is that it has at least one property that represents a primary key.
-   Create a class (`ClientClass`) that extends `Client<Class>`.
    -   Override `modelName`, `primaryKey`, `toJson`, and `fromJson`.
    -   The package [json_serializable](https://pub.dev/packages/json_serializable) is useful for building `toJson` and `fromJson` methods from a class.
-   Instantiate a `PostrestConfig` object to connect your database.
-   Instantiate a `Connection` object with a `PostgrestConfig` object.
-   Instantiate `ClientClass` with a `Connection` object.

## Example

```

import 'package:postgrest_crud/postgrest_crud.dart';

// Class
class Widget {
    int id;
    Widget({this.id})
}

// ClientClass
class WidgetClient extends Client<Widget> {
    @override
    String get modelName => "widget";

    @override
    String get primaryKey => "id";

    WidgetClient({required super.connection});

    @override
    Widget fromJson(JsonObject json) {
        return Widget(id: json['id']);
    }

    @override
    JsonObject toJson(Widget model) {
        return {'id': model.id};
    }
}

void main () async {
    // PostgrestConfig
    final postgrestConfig = PostgrestConfig(url: URL, schema: SCHEMA);

    // Connection
    final connection = Connection(postgrestConfig: postgrestConfig);

    // ClientClass
    final client = TodoClient(connection: connection);

    // request records
    final response = await client.recall();

    // do something with response.models

    // ...

    // close connection when finished, closes http.Client
    connection.close();

}

```

See [example/](example) folder for a more detailed example including a mock server and Postgresql migrations for database setup.
