import Foundation

protocol SomeProtocol {
//    var mustBeSettable: Int { get set }
//    var doesNotNeedToBeSettable: Int { get }
    
//    static func somTypeMethod()
    
//    init(someParameter: Int)
    
    init()
}

protocol FirstProtocol {
    
}

protocol AnotherProtocol {
    static var somTypePropery: Int { get set }
}

protocol FullyNamed {
    var fullName: String { get }
}

protocol RandomNumberGenerator {
    func random() -> Double
}

//struct SomeStructure: FirstProtocol, AnotherProtocol {
//    // structure definition goes here
//}

class SomeSuperClass {
    init() {
        // initalizer inplementation goes here
    }
}

//class SomeClass: SomeSuperClass, FirstProtocol, AnotherProtocol {
//    // class definition goes here
//}

struct Person: FullyNamed {
    var fullName: String
}

let harry = Person(fullName: "Harry Jeon")

class Starship: FullyNamed {
    var prefix: String?
    var name: String
    
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
    
    let ncc1701 = Starship(name: "Enterprise", prefix: "USS")
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    
    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy: m))
        return lastRandom / m
    }
}

let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
print("And another one: \(generator.random())")

protocol Togglable {
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}

var lightSwitch = OnOffSwitch.off
print(lightSwitch) // off
lightSwitch.toggle()
print(lightSwitch) // on

//class SomeClass: SomeProtocol {
//    required init(someParameter: Int) {
//        // initializer implementation goes here
//    }
//}

class SomeSubClass: SomeSuperClass, SomeProtocol {
    // "required" from SomeProtocol conformance; "override" from SomeSuperClass
    required override init() {
        // initializer implementation goes here
    }
}

class Dice {
    let sides: Int
    let generator: RandomNumberGenerator
    
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}

var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
for _ in 1...5 {
    print("Random dice roll is \(d6.roll())")
}
