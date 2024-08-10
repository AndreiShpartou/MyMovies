//
//  APIEndpoint.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 05/08/2024.
//

import Foundation

enum APIEndpoint {
    // thetvdb
    static let baseURL = "https://api4.thetvdb.com/v4"
    static let thetvdbAPIKey = "bae799e2-d0b4-420a-926c-45e3eb50c6eb"
    // Will expire in one month, you have to make additional managers for getting access token // login endpoint with APIKey
    static let readAccessToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZ2UiOiIiLCJhcGlrZXkiOiJiYWU3OTllMi1kMGI0LTQyMGEtOTI2Yy00NWUzZWI1MGM2ZWIiLCJjb21tdW5pdHlfc3VwcG9ydGVkIjpmYWxzZSwiZXhwIjoxNzI1OTIzNTA1LCJnZW5kZXIiOiIiLCJoaXRzX3Blcl9kYXkiOjEwMDAwMDAwMCwiaGl0c19wZXJfbW9udGgiOjEwMDAwMDAwMCwiaWQiOiIyNDcyNzU4IiwiaXNfbW9kIjpmYWxzZSwiaXNfc3lzdGVtX2tleSI6ZmFsc2UsImlzX3RydXN0ZWQiOmZhbHNlLCJwaW4iOm51bGwsInJvbGVzIjpbXSwidGVuYW50IjoidHZkYiIsInV1aWQiOiIifQ.ZZU7HfKsk7npbCzPjW_M3VVwsJLF6_gAGlaAFTrnpWnMTX7koJGMRaeBteJ_ep4KtNDVvLk-s2x56weEobtYgylKf6rn7lgDXYBtecpuPcfxfOyo6qkWoKz_h6tnKyg-IjqKWV3_gbQKzNy7QAPczNnaR-yM4ij0xcqtV0y4j_qzLPchLOkFJ5Pm9Rooh7eOyKs0O4vuAQfYK4bHNIzNtH2HJlnvCYJy6W_KclWtELrFAf7aFpUFAz2kT2-x7IXDTqT586fBW3GOP6t-pa-AruRvd2e2Yfy3rt0ojMQL_jQllLadUsE9nENhMXcbj67ohi0LWpDvZC6V-LiyizPACH7QcaZ5wrOntIZKMWm8s_LRQ1yTQm8XOlBh_xf0cVsdSg1g0U0KIAoqiOqxD0mL6u2583Xu_xRo_jOKiBv0DaIQQBzGaKGMyEftlqU_lj1PHiEUDW5gfSB1SX9aQFKTEKvISZy3Rp-QEthUjyTLP3Khj2fkyJuJzHja3N4VhWtay_OASOBTEjhQfYXHwlS6Ca4fVWd-k5fnoYYZ4R4RuC-hlGShwcb7zdFTNwphToADez5k9-6Fk98nVm2YmMLka3R64EVQPdybc0GtZXVVOUDniZ0eTB8b5sg1Q4yTwoB4uvZNGGVIIgpDIxNkkQf9hE-e-B3cOBHLlbCVQk8Uq38"
    // themoviedb
    // static let baseURL = "https://api.themoviedb.org"
    // static let readAccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1Y2M2MWUzNDBkMjY5MDNhZWU0ZjY0ZGE3ZTVjNGI5NSIsIm5iZiI6MTcyMzE5MjU3Ny41NjEzODUsInN1YiI6IjY2YjRjZGFhODE1NGZiNDUyODQyMjg4YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.k53MZ15xdf7y_pELfdqvAE4HYXbsiODWKiTWF-fW-JM"

    case genres
    case movieLists
    case popularMovies

    var urlString: String {
        switch self {
        case .movieLists:
            return "\(APIEndpoint.baseURL)/3/search/collection"
        case .genres:
            return "\(APIEndpoint.baseURL)/genres"
        case .popularMovies:
            return "\(APIEndpoint.baseURL)/v1.4/movie?lists=popular-films"
        }
    }

    var url: URL? {
        return URL(string: urlString)
    }
}
