# Flutter Currency Converter App

This project is a Flutter-based mobile app for converting currencies and analyzing historical currency valuation changes. It allows users to select currencies, input amounts, and view conversion results in real-time. Additionally, it offers insights into how currency valuations have changed between two selected dates.

## Architecture

The app follows Clean Architecture principles to ensure that the codebase is scalable, maintainable, and decoupled. The architecture is organized into feature folders, making it easy to navigate and extend the app. Despite the current app's modest size, this approach lays a solid foundation for future development and showcases best practices in app architecture.

## Getting Started

To run this app, you will need Flutter installed on your machine. Follow the instructions below to set up and run the app on iOS and Android devices.

### Prerequisites

- Flutter (latest version)
- Dart (latest version)
- Android Studio or VS Code
- Xcode (for iOS development)
- An Android or iOS device or emulator

### Installation

1. Clone the repository to your local machine:
    ```
    git clone https://github.com/yourgithubusername/flutter-currency-converter-app.git
    ```
2. Navigate to the project directory:
    ```
    cd flutter-currency-converter-app
    ```
3. Install the required packages:
    ```
    flutter pub get
    ```

### Running the App

#### Android

1. Open an Android emulator or connect an Android device to your computer.
2. Run the app:
    ```
    flutter run
    ```

#### iOS

1. Open an iOS simulator or connect an iOS device to your computer.
2. Navigate to the iOS folder within the project and install CocoaPods dependencies:
    ```
    cd ios
    pod install
    cd ..
    ```
3. Run the app:
    ```
    flutter run
    ```

## Features

- Real-time currency conversion
- Historical currency valuation analysis
- Clean architecture with feature folders
- Scalable and maintainable codebase

## API Note

The application relies on external APIs from [xe.com](https://www.xe.com/) for currency conversion and obtaining historical rates. Due to limitations with the free API versions, specific API calls to xe.com are used to fetch the necessary data.

**Important:** The API URLs and cookies used in this project may expire or change over time. If you encounter any issues with the API calls, you can manually retrieve updated calls by inspecting network requests made by xe.com's tools. Here's how to update the API calls:

### Retrieving Updated API Calls

1. Visit [xe.com's currency tables](https://www.xe.com/currencytables/?from=SEK&date=2023-09-07#table-section) or the [currency converter](https://www.xe.com/currencyconverter/convert/?Amount=1&From=SEK&To=EUR) page.
2. Open your browser's Developer Tools (right-click the page and select "Inspect" or press `F12`/`Ctrl+Shift+I`).
3. Go to the "Network" tab and trigger the API call by performing the relevant action on the page (e.g., requesting a currency conversion).
4. Find the API request in the list of network activities, right-click it, and choose "Copy as cURL (bash)".

### Updating API Calls Using Postman

After copying the API request as a cURL command:

1. Open Postman and click on the "Import" button at the top left.
2. In the Import window, select "Raw text" and paste the cURL command.
3. Click "Continue" and then "Import" to load the request.
4. With the request loaded, find and click the "Code" button near the "Send" button.
5. In the "Generate code snippets" window, select your preferred language or tool from the list.
6. Copy the generated code snippet, which includes the necessary URL, headers, and other request details.
7. Update your application's repository with the new API call information based on the copied code snippet.

This manual process allows you to maintain the application's functionality by ensuring that the API interactions are up-to-date with xe.com's current endpoints and requirements.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
