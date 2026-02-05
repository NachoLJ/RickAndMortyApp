# Rick & Morty App

SwiftUI app displaying Rick & Morty characters with search, filters, and infinite scrolling.

## Architecture

Built with **Clean Architecture** and **MVVM** for maintainability and testability.

### Data Layer
- Connects to [Rick & Morty API](https://rickandmortyapi.com/)
- HTTP client with async/await
- Two-level caching for performance (network + images)

### Domain Layer
- Business logic separated from UI and API
- Fetch character lists with pagination
- Fetch individual character details

### Presentation Layer
- ViewModels manage state and business logic
- SwiftUI views for the interface
- Infinite scrolling (loads more when near the end)
- Filter sheet with cancel/apply buttons

## Features
- Character grid layout
- Search by name
- Filter by status (Alive, Dead, Unknown) and gender
- Character detail page
- Image caching for better performance
- Automatic retry when API rate limit is reached
- Error and empty state handling

## Key Highlights
- **Two-tier caching**: URLCache (50MB/200MB) for HTTP responses + NSCache for decoded images
- **Rate limit handling**: Exponential backoff retry strategy for 429 errors
- **Smart pagination**: Threshold-based prefetching (loads next page 6 items before end)
- **Empty state logic**: 404 with active filters shows empty state instead of error

## Testing
Unit tests covering:
- Character loading and error handling
- Pagination behavior
- Filter functionality
- Navigation flow

## Tech Stack
- SwiftUI for UI
- Async/Await for network calls
- Protocol-based design for easy testing
- Dependency injection for flexibility

