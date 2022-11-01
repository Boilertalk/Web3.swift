import Foundation
#if canImport(Dispatch)
    import Dispatch
#endif

public final class SynchronizedDictionary<KeyType: Hashable, ValueType>: Sequence, ExpressibleByDictionaryLiteral {

    private var internalDictionary: [KeyType: ValueType]
    private let accessQueue = DispatchQueue(label: "SynchronizedDictionaryAccess", attributes: .concurrent)

    public var count: Int {
        var count = 0

        accessQueue.sync {
            count = self.internalDictionary.count
        }

        return count
    }

    public var isEmpty: Bool {
        var e: Bool!

        accessQueue.sync {
            e = self.internalDictionary.isEmpty
        }

        return e
    }

    public var dictionary: [KeyType: ValueType] {
        get {
            var dictionaryCopy: [KeyType: ValueType]?

            accessQueue.sync {
                dictionaryCopy = self.internalDictionary
            }

            return dictionaryCopy!
        }

        set {
            let dictionaryCopy = newValue

            accessQueue.async(flags: .barrier) {
                self.internalDictionary = dictionaryCopy
            }
        }
    }

    public convenience init() {
        self.init(dictionary: [KeyType: ValueType]())
    }

    public convenience required init(dictionaryLiteral elements: (KeyType, ValueType)...) {
        var dictionary = [KeyType: ValueType]()

        for (key, value) in elements {
            dictionary[key] = value
        }

        self.init(dictionary: dictionary)
    }

    public init( dictionary: [KeyType: ValueType] ) {
        self.internalDictionary = dictionary
    }

    public subscript(key: KeyType) -> ValueType? {
        get {
            var value: ValueType?

            accessQueue.sync {
                value = self.internalDictionary[key]
            }

            return value
        }

        set {
            setValue(value: newValue, forKey: key)
        }
    }

    public func getValueAsync(key: KeyType, response: @escaping (_ value: ValueType?) -> Void) {
        accessQueue.async {
            response(self.internalDictionary[key])
        }
    }

    private func setValue(value: ValueType?, forKey key: KeyType) {
        accessQueue.async(flags: .barrier) {
            self.internalDictionary[key] = value
        }
    }

    public func removeValue(key: KeyType) -> ValueType? {
        var oldValue: ValueType? = nil

        accessQueue.async(flags: .barrier) {
            oldValue = self.internalDictionary.removeValue(forKey: key)
        }

        return oldValue
    }

    public func makeIterator() -> Dictionary<KeyType, ValueType>.Iterator {
        var iterator: Dictionary<KeyType, ValueType>.Iterator!

        accessQueue.sync {
            iterator = self.internalDictionary.makeIterator()
        }

        return iterator
    }
}
