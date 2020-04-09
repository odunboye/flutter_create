For creating custom flutter project from template
A standalone solution to issue https://github.com/flutter/flutter/issues/15279

## Installation

If you want to use flutter_create on the command line,
install it using `pub global activate`:

```console
> pub global activate flutter_create
```

To update flutter_create, use the same `pub global activate` command.

## Usage

```console
> flutter_create -a appname -u template_url
```
or

```console
pub global run flutter_create -a appname -u template_url
```

```console
cd appname
flutter pub get
flutter run
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/odunboye/flutter_create/issues
