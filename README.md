# Shopping

## 1. Goal of the application

The goal of the application was to make a simple and minimalistic app that implements all the
features required for the assignment, with a focus on functionality and testability. I didn't go
very deep into the design so it's very basic looking in that regard.

With this app the user is able to create several different shopping lists, each with different
titles and list items. After creating a user can click the shopping list to edit the list of items (
add, delete, change the check status).

## 2. How to compile and run the application

Before running the app make sure you
run `flutter run build_runner build --delete-conflicting-outputs` in the terminal to generate all
the code necessary to compile the app.

## 3. How to run tests for the application

To run the widget and unit tests you can run the command `flutter test` in the terminal. To run the
integration tests make sure you connect an emulator or device and
run `flutter test integration_test`.

## 4. A few sentences about the overall architecture of the application

For the app architecture I decided to separate the app in 4 different layers, which are the
following:

- Infrastructure
- Domain
- Application
- Presentation

The Infrastructure layer contains the repository classes which are responsible of handling the
backend data transfers and returning either a success or a failure back to the layer below.

The domain layer is the glue between the state management and the repository, it contains all the
necessary data entities (domain objects, data transfer objects, etc), the object mappers, as well as
the necessary interfaces to connect to the repositories.

The application layer is responsible for the app state management, it calls the domain interfaces
and changes the state depending on the results received from the repositories. My state management
solution of choice is Bloc as I think it's one of the best in terms of documentation, testability
and usability.

The presentation layer is responsible for all the UI related code (Screens, widgets etc).

With this architecture the separate layers are independent from each other and it's very easy to
replace a layer without breaking the whole app. Another great advantage of this architecture is it
makes it very easy to test every layer to make sure the app never breaks in the future.

## Any other instructions and notes you have

To delete a shopping list or a list item you have to swipe right.

This app wasn't written using test driven development, first I wrote the whole app and then added
the tests at the end to save time, but I wanted to mention I'm experience with test driven
development and have no problems with it.

For this app I didn't use any CI/CD tools but I'm very experienced with Codemagic for that purpose,
I've also used Bitrise before but not as experienced with that.
