# WorldOfPAYBACK App Assessment Test

### Description

This app is built using SwiftUI and follows the MVVM architectural pattern. It utilizes the Combine framework for reactive programming and Swift Concurrency for handling asynchronous operations. Developed in Xcode 15.2, the project is compatible with Swift version 5.9.2 and does not rely on third-party dependencies.

### General Information

The app successfully implements all user stories outlined in the assessment, showcasing a comprehensive understanding and application of the specified requirements.

### Architecture

* **ViewModels**: Crafted to be agnostic of specific service implementations, ViewModels rely on protocols to abstract away implementation details. This design choice facilitates isolated logic handling for each app screen and enhances testability, ensuring ViewModels become the primary unit testing targets.

* **Transactions Service**: The mechanism for fetching transactions is abstracted behind a protocol, concealing the intricacies from the ViewModel. The TransactionsService leverages a protocol-oriented PBTApi to fetch and parse transactions, currently employing a PBTApiLocalMock for sourcing mock JSON data. Host resolution for TEST or PRODUCTION environments is managed by HostResolver, ensuring appropriate API endpoints are utilized.
  
* **Screen Factory**: To promote modularity and facilitate parallel development across teams, each screen's instantiation is managed by a factory, ensuring screen views remain decoupled.

* **Localization and Formatting**: The app supports string localization through Apple's native approach using string catalogs. Additionally, dates and numbers are formatted based on the current locale, adhering to regional preferences.
  
* **Transactions Storage**: Anticipating future feature requirements, transactions are persisted in memory within TransactionsStorage, ready for aggregate operations like sum calculations.

* **Unit Testing**: As a demonstration of the testing strategy, TransactionsViewModel is thoroughly unit-tested in isolation, showcasing the application's robustness and reliability.
As an example of Unit Tests TransactionsViewModel is fully tested in isolation from other implemenation details.

### Set Up

* **Installation**: To start, unzip the provided archive and open the project in Xcode 15.2. The project is configured to compile without issues.
* **Support**: In case of any compilation issues or questions, please feel free to reach out to me at `lebedac@gmail.com`.