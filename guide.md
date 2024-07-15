# How to write tests in Motoko

- Using the test mops package
- Using bash

## Use test mops packae

- installation
- usage
    - normal tests
    - async tests
    - test suites
    - others

## Using bash
    - configuration


## End









```motoko
# sample code for normal tests
public func add(x : Nat, y : Nat) : Nat {
		return x + y;
	};
	public func sub(x : Nat, y : Nat) : Nat {
		return x - y;
	

```

```bash
#sample code for async tests
  let carsInStock = [
    ("Buick", 2020, 23),
    ("Toyota", 2019, 17),
    ("Audi", 2020, 34),
  ];

  public func asyncFunc() : async Nat {
    var inventory : Nat = 0;
    for ((model, year, price) in carsInStock.vals()) {
      inventory += price;
    };
    return inventory
  };
```

```bash
#sample code for test suites
- Patients
- Doctors
- Nurses
```

```bash
#sample code for bash tests





```

