package;

import LittleIntChunks;

/**
 * pure Haxe BigInt implementation
 * 
 * by Sylvio Sell, Rostock 2020
 * 
 */

abstract BigInt(LittleIntChunks) from LittleIntChunks {
	
	inline function new(littleIntChunks:LittleIntChunks) {
		this = littleIntChunks;
	}
	
	public var isNegative(get, never):Bool;
	inline function get_isNegative():Bool return this.isNegative;
	
	public var length(get, never):Int;
	inline function get_length():Int return this.length;
	
	//public var isZero(get, never):Bool;
	//inline function get_isZero():Bool return this.isZero;

	inline function get(i:Int):LittleInt return this.get(i);
	inline function set(i:Int, v:Int) this.set(i,v);
	inline function push(v:LittleInt) this.push(v);
	inline function unshift(v:LittleInt) this.unshift(v);

	inline function splitHigh(e:Int):BigInt return this.splitHigh(e);
	inline function splitLow(e:Int):BigInt return this.splitLow(e);

	inline function truncateZeroChunks(remove:Bool = false) this.truncateZeroChunks(remove);
	
	inline function setNegative() { this.isNegative = true; return this;}
	
	inline function copy():BigInt return new BigInt(this.copy());
	inline function negCopy():BigInt return new BigInt(this.negCopy());
	inline function clone():BigInt return new BigInt(this.clone());
	inline function negClone():BigInt return new BigInt(this.negClone());

	
	@:from static public function fromInt(i:LittleInt):BigInt {
		return new BigInt(LittleIntChunks.createFromLittleInt(i));
	}
	
	@:to public function toInt():LittleInt {
		if (this == null) return 0;
		return this.toLittleInt();
	}
	

	@:from static public function fromString(s:String):BigInt {
		return LittleIntChunks.createFromString(s);
	}
	
	@:to public function toString():String {
		if (this == null) return "0";
		return this.toString();	
	}

	
	public function toHexString(spacing:Int = 0):String {
		if (this == null) return (spacing > 0) ? LittleIntChunks.getStringOfZeros(spacing) : "0";
		return this.toHexString(spacing);	
	}
	public function toBinaryString(spacing:Int = 0):String {
		if (this == null) return (spacing > 0) ? LittleIntChunks.getStringOfZeros(spacing) : "0";
		return this.toBinaryString(spacing);	
	}
	
	
	// ------- addition -----------
	
	@:op(A + B) function opAdd(b:BigInt):BigInt return add(this, b);
	
	static inline function add(a:BigInt, b:BigInt):BigInt {
		if (a == null) return (b == null) ? null : b.copy();
		else if (b == null) return a.copy();
		else if (a.isNegative) {
			if (b.isNegative) return _add(a, b).setNegative(); // -3 + -2
			else return _subtract(b, a.negClone()); // -3 + 2
		}
		else {
			if (b.isNegative) return _subtract(a, b.negClone()); // 3 + -2
			else return _add(a, b); // 3 + 2
		}
	}
	
	static inline function _add(a:BigInt, b:BigInt):BigInt {
		if (a.length > b.length) return __add(a.copy(), b);
		else return __add(b.copy(), a);
	}
	
	static inline function __add(a:BigInt, b:BigInt):BigInt {
		for (position in 0...b.length) {
			addAtPosition(a, b.get(position), position);
		}
		return a;
	}
	
	static inline function addAtPosition(a:BigInt, v:LittleInt, position:Int):Void {
		for (i in position...a.length) {
			var x:Int = a.get(i) + v;
			if (x & LittleIntChunks.UPPESTBIT == 0) {
				a.set(i, x);
				v = 0;
				break; 
			}
			a.set(i, x & LittleIntChunks.BITMASK);
			v = 1;
		}
		if (v > 0) a.push(v);
	}
	
	// ------- subtraction -----------
	
	@:op(A - B) function opSubtract(b:BigInt):BigInt return subtract(this, b);

	static inline function subtract(a:BigInt, b:BigInt):BigInt {
		if (a == null) return (b == null) ? null : b.negCopy();
		else if (b == null) return a.copy();
		else if (a.isNegative) {
			if (b.isNegative) return _subtract(b.negClone(), a.negClone());// -3 - -2
			else return _add(a, b).setNegative(); // -3 - 2
		}
		else {
			if (b.isNegative) return _add(a, b.negClone()); // 3 - -2
			else return _subtract(a, b);  // 3 - 2
		}
	}

	static inline function _subtract(a:BigInt, b:BigInt):BigInt {
		var v:BigInt;
		if (a > b) {
			v = __subtract(a.copy(), b);
			v.truncateZeroChunks();
			return v;
		}
		else {
			v = __subtract(b.copy(), a);
			v.truncateZeroChunks();
			if (v.length == 0) return null else return v.setNegative();
		}
	}

	static inline function __subtract(a:BigInt, b:BigInt):BigInt {
		for (position in 0...b.length) {
			subtractAtPosition(a, b.get(position), position);
		}
		return a;
	}

	static inline function subtractAtPosition(a:BigInt, v:LittleInt, position:Int):Void {		
		for (i in position...a.length) {
			var x:Int = a.get(i);
			if (x >= v) {
				a.set(i, x - v);
				v = 0;
				break; 
			}
			a.set(i, x + LittleIntChunks.UPPESTBIT - v);
			v = 1;
		}
	}
	
	// ------- negation -----------

	@:op(- B)
	inline function negation():BigInt {
		if (this == null) return null;
		else return this.negCopy();
	}
	
	
	// ------- multiplication (https://en.wikipedia.org/wiki/Karatsuba_algorithm) -----
	
	@:op(A * B)
	function opMulticplicate(b:BigInt):BigInt {
		if (this == null || b == null) return null;
		if (isNegative != b.isNegative) return mul(this, b).setNegative();
		else return mul(this, b);
	}
	
	static function mul(a:BigInt, b:BigInt):BigInt {
		
		if (a == null || b == null) return null;
		if (a.length == 1 && b.length == 1) return fromInt(a.get(0) * b.get(0));
		
		var e = IntUtil.nextPowerOfTwo((a.length > b.length) ? a.length : b.length) >>> 1;
		
		var aHigh:BigInt = a.splitHigh(e);
		var aLow:BigInt = a.splitLow(e);
		var bHigh:BigInt = b.splitHigh(e);
		var bLow:BigInt = b.splitLow(e);
		
		var p1:BigInt = mul(aHigh, bHigh); 
		var p2:BigInt = mul(aLow , bLow);  
		
		return join(e, p1, mul(aHigh + aLow, bHigh + bLow) - (p1 + p2), p2 );
	}
	
	static inline function join(e:Int, a:BigInt, b:BigInt, c:BigInt):BigInt {
		
		var littleIntChunks = new LittleIntChunks();
		
		if (c == null) for (i in 0...e) littleIntChunks.push(0);
		else
		{	for (i in 0...e) {
				if (i < c.length) littleIntChunks.push(c.get(i));
				else {
					if (b == null && a == null) break;
					littleIntChunks.push(0);
				}
			}
			if (c.length > e) b = b + c.splitHigh(e);
		}
		
		if (b == null) {
			if (a != null) for (i in 0...e) littleIntChunks.push(0);
		}
		else
		{	for (i in 0...e) {
				if (i < b.length) littleIntChunks.push(b.get(i));
				else {
					if (a == null) break;
					littleIntChunks.push(0);
				}
			}
			if (b.length > e) a = a + b.splitHigh(e);
		}
		
		if (a != null) for (i in 0...a.length) littleIntChunks.push(a.get(i));

		return littleIntChunks;
	}
	
	
	// ------- division -----
	
	@:op(A / B)
	function opDivMod(b:BigInt):BigInt {
		if (b == null) throw ("Error '/', divisor can't be 0");
		return divMod(this, b).quotient;
	}
	
	// ------- division with remainder -----

	static public function divMod(a:BigInt, b:BigInt):{quotient:BigInt, remainder:BigInt} {
		
		if (a == null) return { quotient:null, remainder:null };
		
		if (b.length <= 2) {
			if (a.length <= 2) return {
				quotient: fromInt( Std.int(a.toInt() / b.toInt() )), // optimize!
				remainder:fromInt( Std.int(a.toInt() % b.toInt() ))
			}
			else if (b.length == 1)
				return divModLittle(a, b.toInt());
			else
				return divModLong(a, b);
		}
		else return divModLong(a, b);
	}
	
	static public function divModLittle(a:BigInt, v:LittleInt):{quotient:BigInt, remainder:BigInt} {
		
		var i = a.length - 1;
		var x:LittleInt = (a.get(i) << LittleIntChunks.BITSIZE) | a.get(--i);
		var q:BigInt = Std.int( x / v );
		var r:LittleInt = Std.int( x % v );
		do {
			x = (r << LittleIntChunks.BITSIZE) | a.get(--i);
			q.unshift(Std.int( x / v )); //<- can be 2 chunks
			r = Std.int( x % v );
			
		} while (i > 0);
				
		return { quotient:q, remainder:r };
	}
	
	static public function divModLong(a:BigInt, b:BigInt):{quotient:BigInt, remainder:BigInt} {
		// TODO
		
		// ...
		
		return { quotient:null, remainder:null };
	}
	
	
	// ------- comparing -----------

	@:op(A > B)
	function greater(b:BigInt):Bool {
		if (this == null) {
			if (b == null) return false;
			else return (b.isNegative) ? true : false;
		}
		else if (b == null) return (isNegative) ? false : true;
		else if (isNegative != b.isNegative) return (isNegative) ? false : true;
		else if (length > b.length) return (isNegative) ? false : true;
		else if (length < b.length) return (isNegative) ? true : false;
		else {
			for (i in 0...length) {
				if (get(length-i-1) > b.get(length-i-1)) return (isNegative) ? false : true;
				else if (get(length-i-1) < b.get(length-i-1)) return (isNegative) ? true : false;
			}
			return false;
		}
	}
	
	@:op(A >= B)
	function greaterOrEqual(b:BigInt):Bool {
		if (this == null) {
			if (b == null) return true;
			else return (b.isNegative) ? true : false;
		}
		else if (b == null) return (isNegative) ? false : true;
		else if (isNegative != b.isNegative) return (isNegative) ? false : true;
		else if (length > b.length) return (isNegative) ? false : true;
		else if (length < b.length) return (isNegative) ? true : false;
		else {
			for (i in 0...length) {
				if (get(length-i-1) > b.get(length-i-1)) return (isNegative) ? false : true;
				else if (get(length-i-1) < b.get(length-i-1)) return (isNegative) ? true : false;
			}
			return true;
		}
	}
	
	@:op(A < B)
	function lesser(b:BigInt):Bool {
		if (this == null) {
			if (b == null) return false;
			else return (b.isNegative) ? false : true;
		}
		else if (b == null) return (isNegative) ? true : false;
		else if (isNegative != b.isNegative) return (isNegative) ? true : false;
		else if (length < b.length) return (isNegative) ? false : true;
		else if (length > b.length) return (isNegative) ? true : false;
		else {
			for (i in 0...length) {
				if (get(length-i-1) < b.get(length-i-1)) return (isNegative) ? false : true;
				else if (get(length-i-1) > b.get(length-i-1)) return (isNegative) ? true : false;
			}
			return false;
		}
	}
	
	@:op(A <= B)
	function lesserOrEqual(b:BigInt):Bool {
		if (this == null) {
			if (b == null) return true;
			else return (b.isNegative) ? false : true;
		}
		else if (b == null) return (isNegative) ? true : false;
		else if (isNegative != b.isNegative) return (isNegative) ? true : false;
		else if (length < b.length) return (isNegative) ? false : true;
		else if (length > b.length) return (isNegative) ? true : false;
		else {
			for (i in 0...length) {
				if (get(length-i-1) < b.get(length-i-1)) return (isNegative) ? false : true;
				else if (get(length-i-1) > b.get(length-i-1)) return (isNegative) ? true : false;
			}
			return true;
		}
	}
	
	@:op(A == B)
	function equal(b:BigInt):Bool {
		if (this == null) return (b == null) ? true : false;
		else if (b == null) return false;
		else if (isNegative != b.isNegative) return false;
		else if (length != b.length) return false;
		else {
			for (i in 0...length) {
				if (get(length-i-1) != b.get(length-i-1)) return false;
			}
			return true;
		}
	}
	
	@:op(A != B)
	function notEqual(b:BigInt):Bool {
		if (this == null) return (b == null) ? false : true;
		else if (b == null) return true;
		else if (isNegative != b.isNegative) return true;
		else if (length != b.length) return true;
		else {
			for (i in 0...length) {
				if (get(length-i-1) != b.get(length-i-1)) return true;
			}
			return false;
		}
	}
	
	
}
