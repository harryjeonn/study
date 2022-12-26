import Foundation

let numbers = [1, 2, 3, 4, 5]

// MARK: - Map

// for-in
var forInNumbers: [Int] = []
for number in numbers {
    forInNumbers.append(number * 2)
}
// map
let mapNumbers = numbers.map { $0 * 2 }

// MARK: - Filter

numbers.filter { number in
    return number % 2 == 0
}

let filterNumbers = numbers.filter { $0 % 2 == 0 }

let filterMapNumbers = numbers
    .filter { $0 % 2 == 0 }
    .map { $0 * 2 }

// MARK: - Reduce

// reduce(_:_:)
//let reduceNumbers = numbers.reduce(0) { partialResult, element in
//    return partialResult + element
//}

//let reduceNumbers = numbers.reduce(0) { $0 + $1 }

let reduceNumbers = numbers.reduce(0, +)

// reduce(into:_:)
let reduceIntoNumbers = numbers.reduce(into: 0) { partialResult, number in
    partialResult += number
}

let names = ["harry", "lily"]

let uppercaseNames = names.reduce(into: [], {
    $0.append($1.uppercased())
})

//let uppercaseNames = names.map { $0.uppercased() }

// MARK: - All

let result = numbers
    .filter { $0 % 2 == 0 } // 짝수 걸러내기
    .map { $0 * 5 } // 5 곱하기
    .reduce(0, +) // 모든 값 더하기
