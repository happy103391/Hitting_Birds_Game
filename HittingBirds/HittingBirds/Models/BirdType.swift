

import Foundation

struct BirdType: Equatable {
    let name: String
    let score: Int
    let appearTime: Float
}

struct Bird: Equatable {
    static let bluebird = BirdType(name: "blue_bird", score: 1, appearTime: Float.random(in: 3...5))
    static let brownbird = BirdType(name: "brown_bird", score: 3,  appearTime: Float.random(in: 2 ... 4))
    static let blackbird = BirdType(name: "black_bird", score: 5,  appearTime: 1)
}


