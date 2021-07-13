

import UIKit
import Algorithms
import Collections
// import Numerics

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collections
        do {
            var d = Deque([1,2,3]) // append, prepend, popFirst, popLast are efficient
            d.append(contentsOf:[4,5])
            d.prepend(contentsOf:[-1,0])
            print(d)
            let i = d.popFirst()
            print(i as Any)
            print(d)
        }
        
        do {
            var s = OrderedSet([1,2,3])
            // does just about everything an array can do, but keeps uniqueness
            // containment test is fast because it works along with a hash table
            s.append(3)
            let result = s.append(4) // tells whether and where
            let result2 = s.insert(4, at:0)
            let ok = s.contains(2)
            let ix = s.firstIndex(of: 2)
            // the array aspect is the elements
            var arr = s.elements
            arr.append(100)
            s.elements.append(100)
            print(arr)
            print(s)
            // the set aspect, good for set algebra if ordering isn't important
            var set = s.unordered // not actually a set, but does set algebra
            set.formIntersection([2,3])
            set.insert(8)
            // oddly, that changes `set` but not `s`
            // I think that's because we assigned it to a variable and then mutated it
            // which gave us copy on write
            // if we wanted to keep the connection, we should not have assigned
            print(result, ok, ix, arr, set, s.elements)
            s.unordered.formIntersection([2,3])
            print(s.elements) // you see?
        }
        
        do { // book
            let pep = OrderedSet(["Manny", "Moe", "Jack"])
            print(pep) // ["Manny", "Moe", "Jack"]
            let first = pep.first! //
            print(first) // Manny
            let ix = pep.firstIndex(of:"Moe") // Optional(1)
            print(ix)
            if pep.contains("Jack") { // yes, fast
                print("yep")
            }
            let ix2 = pep.firstIndex {$0.hasPrefix("J")}
        }
        
        do { // book, cosorting naively
            let model = ["Manny", "Moe", "Jack"]
            let arr = ["Jack", "Manny"]
            let result = arr.sorted { model.firstIndex(of:$0) ?? 0 < model.firstIndex(of:$1) ?? 0}
            print(result)
        }
        
        do { // book, better
            let model = OrderedSet(["Manny", "Moe", "Jack"])
            let arr = ["Jack", "Manny"]
            let result = arr.sorted { model.firstIndex(of:$0) ?? 0 < model.firstIndex(of:$1) ?? 0}
            print(result)
        }
        
        do { // book, even better if arrays are large
            let model = OrderedSet(["Manny", "Moe", "Jack"])
            let arr = ["Jack", "Manny"]
            let result = arr.map { (model.firstIndex(of:$0) ?? 0, $0)}
                .sorted(by:<)
                .map { $0.1 }
            print(result)
        }
        
        do {
            let arr = (1...10000).randomSample(count: 500).shuffled()
            let model = OrderedSet(arr.sorted(by:<))
            let d1 = Date.now
            for _ in 1...100 { // 6 seconds
                let result = arr.sorted { model.firstIndex(of:$0) ?? 0 < model.firstIndex(of:$1) ?? 0}
                //print(result)
            }
            let d2 = Date.now
            print(d2.timeIntervalSince1970-d1.timeIntervalSince1970)
            let d3 = Date.now
            for _ in 1...100 { // 0.5 seconds
                let result = arr.map { (model.firstIndex(of:$0) ?? 0, $0)}
                    .sorted(by:<)
                    .map { $0.1 }
                //print(result)
            }
            let d4 = Date.now
            print(d4.timeIntervalSince1970-d3.timeIntervalSince1970)
        }
        
        do {
            var d = OrderedDictionary<Character,Int>()
            let list = "aaabbcddddee"
            for c in list {
                d[c, default:0] += 1
            }
            print(d)
        }
        
        do {
            struct Planet {
                let distance: UInt64
                let diameter: UInt64
                let gravity: Double
            }
            var d : OrderedDictionary<String,Planet> = [:]
            d["Mercury"] = Planet(distance: 57_900_000, diameter: 4_878, gravity: 0.38)
            d["Venus"] = Planet(distance: 108_160_000, diameter: 12_104, gravity: 0.9)
            d["Earth"] = Planet(distance: 149_600_000, diameter: 12_756, gravity: 1)
            let names = d.keys // OrderedSet
            print(names)
            let thirdPlanet = d.elements[2]
            let name = thirdPlanet.key
            let mercuryGravity = d["Mercury"]?.gravity // Optional
            print(name)
            print(mercuryGravity as Any)
            let planetX = Planet(distance: 100_000_000, diameter: 8_000, gravity: 0.8)
            d.updateValue(planetX, forKey: "PlanetX", insertingAt: 2)
            print(d)
        }
        
        do {
            // Apple's own example: histogram by closure
            var histogram = OrderedDictionary<String, Int>()
            let sentence = "how much wood would a wood chuck chuck"
            let words = sentence.split(separator: " ").map {String($0)}
            for word in words {
                histogram.modifyValue(forKey: word, default: 0) {$0 += 1}
            }
            print(histogram) // [how: 1, much: 1, wood: 2, would: 1, a: 1, chuck: 2]
            histogram.sort {$0.key < $1.key}
            print(histogram)
        }
        
        do {
            let arr = Array(1...10)
            let comb = arr.combinations(ofCount: 8)
            print(comb) // but it doesn't actually provide them that way
            print(Array(comb)) // there they are
            
            let perm = arr[0...2].permutations(ofCount: 2)
            print(perm)
            print(Array(perm)) // this can rapidly take a looong time on a big array
            
            var arr2 = arr
            arr2.rotate(toStartAt: 5)
            print(arr2)
            
            var arr3 = arr
            let result = arr3.stablePartition { $0.isMultiple(of: 3) }
            // result is the index of the first element of the second partition
            // those are the ones for which it is true
            print(result, arr3)
            // in case you didn't capture the index, you can ask for it later
            // faster than firstIndex(where:) because we are already partitioned,
            // so binary search can be used
            let ix = arr3.partitioningIndex { $0.isMultiple(of: 3) }
            print(ix) // better be the same as result!
            
            do { // good enough for the book, I think
                var arr = [1,2,3,4,5,6,7]
                let ix = arr.stablePartition {$0.isMultiple(of: 2)}
                let odds = arr[..<ix] // [1, 3, 5, 7]
                let evens = arr[ix...] // [2, 4, 6]
                print(odds)
                print(evens)
            }
                        
            let chain = chain(arr, 20..<30)
            for i in chain {
                print(i)
            }
            
            let cyc = arr[1...3].cycled(times:3)
            for i in cyc {
                print(i)
            }
            
            // join sequence _of sequences_
            let seqseq = [1...3, 1...4, 1...5]
            let joined = seqseq.joined() // wait, no, that's the normal one!
            print(joined)
            for i in joined {
                print(i)
            }
            do {
                // this is the normal one too!
                let joined = seqseq.joined(separator:[0]) 
            }
            do {
                // aha, yes, this is the hole we are filling: flatten with non-array separator
                let joined = seqseq.joined(by: 0) // there we go!
                print(joined)
                for i in joined {
                    print(i)
                }
            }
            // interesting twist: can execute a closure as we join
            // I wish normal joining had this...
            let joined2 = seqseq.joined { prev, nex in
                Array(prev).reduce(0,+)
            }
            print(joined2)
            
            do { // book
                let arr = [[1,2], [3,4], [5,6]]
                let joined = arr.joined { [$0.last!*10, $1.first!*10] }
                let result = Array(joined)
                // [1, 2, 20, 30, 3, 4, 40, 50, 5, 6]
                print(result)
            }
            
            // product is basically two nested for loops
            let prod = product([1,2,3], [10,20])
            print(prod)
            for pair in prod {
                print(pair)
            }
            
            do {
                let arr = Array.init(repeating: [0,1,2], count: 3)
                for i in 0..<3 {
                    for j in 0..<3 {
                        let item = arr[i][j]
                        print(item)
                    }
                }
                for (i,j) in product(0..<3, 0..<3) {
                    let item = arr[i][j]
                    print(item)
                }
            }
        }

        do {
            // compacted; it is merely `lazy` plus `compactMap {0}`
            // just a clearer way to write that you want unwrapping with nils eliminated
            // beats me why they didn't rename it "unwrapSafely" or something
            
            print("truly random")
            for _ in (1...10) {
                let result = [1,2,3,4].randomSample(count:2)
                print(result)
            }
            print("stable")
            for _ in (1...10) {
                let result2 = [1,2,3,4].randomStableSample(count:2)
                print(result2)
            }
        }
        
        do {
            // striding; basically an alternative to the stride global?
            for i in stride(from: 1, to: 10, by: 2) {
                print(i)
            }
            for i in (1...10).striding(by:2) /*.striding(by:3)*/ {
                print(i)
            }
            let planets = ["Mercury", "Venus", "Earth", "Mars", "Jupiter"]
            for planet in planets.striding(by:2) {
                print(planet) // Mercury, Earth, Jupiter
            }
            // a difference is that the latter results in a StrideCollection object that itself has a `stride` method that results in another, and so on
        }
        
        // suffix(while:), sort of the reverse of prefix(while:)
        
        // trimmingPrefix(while:), trimmingSuffix(while:), and trimming(while:) [both ends]
        // basically extends drop(while:)
        
        // uniqued, uniqued(on:) - basically we know how to write this sort of thing,
        // but it's nice to have it written for us
        // and the second one lets you specify what uniqueness even is
        
        // min(count:), max(count:), min(count:sortedBy:), max(count:sortedBy:), minAndMax(), minAndMax(by:)
        do { // book
            let arr = [3,1,-2]
            let min = arr.min(count: 2) // [-2, 1]
            let min2 = arr.min(count: 2) {abs($0)<abs($1)} // [1, -2]
            print(min)
            print(min2)
        }
        
        // adjacentPairs — rather specialized, it's tuples of two-at-a-time overlapping chunks
        do {
            let pairs = (1...4).adjacentPairs()
            for pair in pairs {
                print(pair)
            }
        }
        // but it's a little hard for me to see why we need that when we also have windows
        do {
            let pairs = (1...4).windows(ofCount: 2)
            for pair in pairs {
                print(Array(pair))
            }
        }
        
        // chunking; these are not very closely related actually
        // badly needed because `split` throws away the separators
        
        // chunks(ofCount:) is the standard ruby chunk,
        // just splits into things of the desired length
        // they are not arrays unless you coerce
        do {
            let chunks = (10...14).chunks(ofCount:2)
            for chunk in chunks {
                print(Array(chunk))
            }
        }
        do { // good enough for the book
            let arr = [1,2,3,4,5,6,7]
            let chunks = arr.chunks(ofCount:3).map (Array.init)
            // [[1, 2, 3], [4, 5, 6], [7]]
            print(chunks)
        }
        // but chunked(by:) effectively partitions every time a predicate is _false_
        // in other words it is making chunks where the predicate is true
        // the predicate is on both sides of the proposed divider
        // be careful, you can get very weird results;
        // think of the rule this way: _start_ a new chunk every time the pred is false
        do {
            print("chunked(by:)")
            let chunks = (10...16).chunked(by: {_,i in i.isMultiple(of: 3)})
            for chunk in chunks {
                print(Array(chunk))
            }
        }
        // for the book, split on evens but keep them
        do {
            let arr = [1,2,3,4,5,6]
            let chunks = arr.chunked {before, after in !after.isMultiple(of: 2)}
            let result = chunks.map (Array.init) // [[1], [2, 3], [4, 5], [6]]
            print(result)
        }
        // chunked(on:), however, makes a tuple: the predicate and the original value
        // it then groups the original values into a slice
        // this should remind you, I think, of the dictionary grouped init
        do {
            let chunks = ["Manny", "Moe", "Jack"].chunked(on: {$0.first!})
            print(chunks.map {($0.0, Array($0.1))}) // turn slices into arrays
        }
        // NB if you omit "by" or "on" you can confuse yourself,
        // but the compiler picks the right one by how many params your closure expects
        
        // firstNonNil applies a transform, stops and returns first result that is not nil
        // might seem silly but try to write it yourself, you'll see it isn't that easy
        do {
            if let result = ["hey", "1", "ho", "2"].firstNonNil(Int.init) {
                print(result)
            }
        }
        
        // indexed() — like enumerated, but true index numbers rather than a mere count
        
        // interspersed(with:), just what you think, adds separators between all elements
        print(Array([1,2,3].interspersed(with:0)))
        
        // reductions, reductions(into:) - these are the reduce intermediates
        // often called "scan" but they decided this was clearer
        
        do {
            let reduct = [1,2,3,4].reductions(0,+) // [0, 1, 3, 6, 10]
            print(reduct)
            
            let reduct2 = [[1], [2], [3]].reductions(into:[Int]()) {$0 += $1}
            print(reduct2)
        }
        
        do {
            // here, a hole is plugged with regard to lazy
            let seq = [1,2,3,4]
            // array of subsequences
            let result = seq.split(whereSeparator: {$0.isMultiple(of: 2)})
            // without Algorithms, this is an array of LazySequence subsequences
            // with Algorithms, it is a LazySplitCollection, so that it is itself lazy
            let resultlazy = seq.lazy.split(whereSeparator: {$0.isMultiple(of: 2)})
        }
        
        // windows are slices (i.e. chunks but they overlap)
        do {
            let arr = [1,2,3,4,5]
            let chunks = arr.chunks(ofCount: 3).map(Array.init)
            // [[1, 2, 3], [4, 5]]
            let windows = arr.windows(ofCount: 3).map(Array.init)
            // [[1, 2, 3], [2, 3, 4], [3, 4, 5]]
            print(chunks)
            print(windows)
        }
    }


}

