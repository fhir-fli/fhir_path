// ignore_for_file: avoid_print

import 'dart:collection';

/// ValidatorFetcher
class ValidatorFetcher {
  /// Constructs a new instance of the validator fetcher.
  final HashMap<String, bool> urlCache = HashMap();

  /// Constructs a new instance of the validator fetcher.
  final HashMap<String, String> packageIdCache = HashMap();

  /// Resolves the URL and attempts to find the associated resource.
  void findResource(Object validator, String url) {
    try {
      resolveURL(validator, url);
    } on Exception catch (e) {
      print('Error resolving URL: $e');
    }
  }

  /// Resolves a given URL and determines if it can be processed or not.
  bool resolveURL(Object validator, String url) {
    // Check if the URL is already cached
    if (urlCache.containsKey(url)) {
      return urlCache[url]!;
    }

    // Handle special cases for FHIR-related URLs
    if (url.startsWith('http://hl7.org/fhir') ||
        url.startsWith('http://terminology.hl7.org')) {
      urlCache[url] = false;
      return false;
    }

    // Placeholder logic for handling additional FHIR URL scenarios
    // For example, you could check for package availability or other
    // conditions here
    // Example:
    if (url.contains('|')) {
      final baseUrl = url.substring(0, url.indexOf('|'));
      final version = url.substring(url.indexOf('|') + 1);
      // Load package or perform specific logic for `baseUrl` and `version`
      print('Base URL: $baseUrl, Version: $version');
    }

    // Assume external URLs are valid if no specific handling exists
    urlCache[url] = true;
    return true;
  }
}

/// ValidationContextCarrier provides additional resources or context
/// that may be relevant during validation. It allows resources to be
/// resolved dynamically if they become necessary.
