import 'dart:convert';
import 'package:http/http.dart' as http;

// class BookService {
//   static const String baseUrl = 'http:/localhost:5000/all'; // Flask API endpoint

//   Future<List<Book>> fetchBooks() async {
//     final response = await http.get(Uri.parse(baseUrl));

//     if (response.statusCode == 200) {
//       final List booksJson = json.decode(response.body);

//       return booksJson.map((json) => Book.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load books');
//     }
//   }
// // }
// class BookService {
//   static const String baseUrl = 'http://localhost:5000/all'; // Ensure this URL is correct

//   Future<List<Book>> fetchBooks() async {
//     try {
//       final response = await http.get(Uri.parse(baseUrl));

//       if (response.statusCode == 200) {
//         // Assuming the response body is a valid JSON
//         final Map<String, dynamic> data = json.decode(response.body);

//         // Map the response data to your model
//         final booksJson = data['book_name']; // Adjust this based on your response structure
//         return booksJson.map((json) => Book.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load books');
//       }
//     } catch (e) {
//       print("Error: $e");
//       throw Exception('Failed to load books');
//     }
//   }
// }


// class Book {
//   final String title;
//   final String author;
//   final String image;
//   final int votes;
//   final double rating;

//   Book({required this.title, required this.author, required this.image, required this.votes, required this.rating});

//   factory Book.fromJson(Map<String, dynamic> json) {
//     return Book(
//       title: json['book_name'],
//       author: json['author'],
//       image: json['image'],
//       votes: json['votes'],
//       rating: json['rating'].toDouble(),
//     );
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

class BookService {
  static const String baseUrl = 'http://localhost:5000/all'; // Ensure this URL is correct

  Future<List<Book>> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        // Assuming the response body is a valid JSON
        final Map<String, dynamic> data = json.decode(response.body);

        // Extracting lists from the response data
        List<dynamic> bookNames = data['book_name'];
        List<dynamic> authors = data['author'];
        List<dynamic> images = data['image'];
        List<dynamic> votes = data['votes'];
        List<dynamic> ratings = data['rating'];

        // Mapping the data to a list of Book objects
        return List.generate(bookNames.length, (index) {
          return Book(
            title: bookNames[index],
            author: authors[index],
            image: images[index],
            votes: votes[index].toInt(),  // Ensure it's an integer
            rating: ratings[index].toDouble(), // Ensure it's a double
          );
        });
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Failed to load books');
    }
  }
}

class Book {
  final String title;
  final String author;
  final String image;
  final int votes;
  final double rating;

  // Constructor
  Book({
    required this.title,
    required this.author,
    required this.image,
    required this.votes,
    required this.rating,
  });

  // A factory constructor for creating a Book object from JSON data
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'],  // Adjust based on the response structure
      author: json['author'],  // Adjust based on the response structure
      image: json['image'],  // Adjust based on the response structure
      votes: json['votes'],  // Ensure this is the correct type
      rating: json['rating'].toDouble(),  // Ensure this is a double
    );
  }
}
