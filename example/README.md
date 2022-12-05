## Example Setup

### Create a configuration file

Copy config.sample.yaml to config.yaml and update as needed. (The defaults provided will work with the Mock Server setup.)

Then use either the [Mock Server Setup](#mock-server-setup) or the
[Database Setup](#database-setup).

### Mock Server Setup

The simple example provided uses [node-mock-server](https://www.npmjs.com/package/node-mock-server) to provide a mock service. Run `node mock` from this directory
to start the mock server.

```
$ npm install
$ node mock
```

-   Only a single GET endpoint is configured to return two records.

### Database Setup

The migrations under `database/` can be used to create a Postgresql schema to be used with this example. See [yoyo-migrations](https://pypi.org/project/yoyo-migrations/) for configuration. A sample configuration is provided `database/yoyo.sample.ini`.

```
$ cd database
$ python3 -m pip install virtualenv
$ python3 -m venv .env
$ source ./env/bin/activate
$ pip install -U pip
$ pip install -r requirements.txt
$ yoyo apply
```

-   `yoyo apply` Assumes correct configuration has been created.

### Run Application

```
$ dart run example.dart
```

-   All relative paths assume from `pkg-root/example` unless otherwise specified.
