# checkpoint

Checkpoint is a mobile application developed with Flutter.

## What is Checkpoint

Checkpoint's main goal is sharing challanges. Challange posts need to be location based. Everyone can share a checkpoint. Users view the shared checkpoints and complete the challenge at the specified location. They can take pictures and share while completing the challenge.

## State Management

This project developed with flutter. As you know when developing projects with flutter you need to manage states really meticulously for better performans and cleaner app structor.

### Watch_It and Flutter_Command

Checkpoint uses watch_it and flutter_command for state management and app architecture. Watch_It provides a dependincy injection based state management solution. It is using get_it basically. It has not much boilerplate or complicated data transfers scenarios between your widgets. Also it is working so well with flutter_command
watch_it: https://github.com/escamoteur/watch_it
flutter_command: https://github.com/escamoteur/flutter_command

## Firebase Extensions

Firebase extesions are providing a really easy way for adding some spicy stuffs to your project.

### Translate Text in Firestore

It is using for automaticly translates for data provided by Firestore Database. Checkpoint is using it for translating Checkpoint title's and descriptions which is provided in English to German, Spanish, French and Turkish.

### Search Firestore with Algolia

This extension handle almost all of your Algolia settings. You can integrate really useful search feature to your application. You can try it out while searching checkpoints.

### Label Images with Cloud Vision AI

With this extension you can label your images automaticly right after Firebase Storage upload. It writes all labels to determined collection with file path. Checkpoint is using it enhancing the Algolia Search.
