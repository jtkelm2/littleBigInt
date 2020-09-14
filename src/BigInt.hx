package;

import LittleIntChunks;
import haxe.io.Bytes;

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
	inline function set(i:Int, v:LittleInt) this.set(i,v);
	inline function push(v:LittleInt) this.push(v);
	inline function unshift(v:LittleInt) this.unshift(v);

	inline function splitHigh(e:Int):BigInt return this.splitHigh(e);
	inline function splitLow(e:Int):BigInt return this.splitLow(e);

	inline function truncateZeroChunks(remove:Bool) this.truncateZeroChunks(remove);
	
	inline function setNegative():BigInt { this.isNegative = true; return this;}
	inline function setPositive():BigInt { this.isNegative = false; return this;}
	
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
		return LittleIntChunks.createFromBaseString(s);
	}
	
	@:to public function toString():String {
		if (this == null) return "0";
		return this.toBaseString(10);	
	}
	

	static public function fromBinaryString(s:String):BigInt {
		return LittleIntChunks.createFromBaseString(s, 2);
	}
	
	static public function fromHexString(s:String):BigInt {
		return LittleIntChunks.createFromBaseString(s, 16);
	}
	
	static public function fromOctalString(s:String):BigInt {
		return LittleIntChunks.createFromBaseString(s, 8);
	}
	
	static public function fromBaseString(s:String, base:Int = 10):BigInt {
		return LittleIntChunks.createFromBaseString(s, base);
	}
	
	
	public function toBinaryString(spacing:Int = 0, leadingZeros:Bool = true):String {
		if (this == null) return (leadingZeros && spacing > 0) ? LittleIntChunks.getStringOfZeros(spacing) : "0";
		return this.toBinaryString(spacing, leadingZeros);	
	}	
	
	public function toOctalString(spacing:Int = 0, leadingZeros:Bool = true):String {
		if (this == null) return (leadingZeros && spacing > 0) ? LittleIntChunks.getStringOfZeros(spacing) : "0";
		return this.toBaseString(8, spacing, leadingZeros);	
	}	
	
	public function toHexString(spacing:Int = 0, leadingZeros:Bool = true):String {
		if (this == null) return (leadingZeros && spacing > 0) ? LittleIntChunks.getStringOfZeros(spacing) : "0";
		return this.toHexString(spacing, leadingZeros);	
	}
	
	public function toBaseString(base:Int = 10, spacing:Int = 0, leadingZeros:Bool = false):String {
		if (this == null) return (leadingZeros && spacing > 0) ? LittleIntChunks.getStringOfZeros(spacing) : "0";
		return this.toBaseString(base, spacing, leadingZeros);	
	}
	
	
	static public function fromBytes(b:Bytes):BigInt {
		return LittleIntChunks.fromBytes(b);
	}

	public function toBytes():Bytes {
		if (this == null) {
			var b = Bytes.alloc(1);
			b.set(0, 0);
			return b;
		}
		else return this.toBytes();	
	}
	
	
	// --------------------------------------------------------------------
	// -------------------- abs -------------------------------------------
	// --------------------------------------------------------------------	
	
	public function abs():BigInt {
		if (this == null) return null;
		else if (isNegative) return negCopy();
		else return copy();
	}
	

	// --------------------------------------------------------------------
	// -------------------- addition --------------------------------------
	// --------------------------------------------------------------------	
	
	@:op(A + B) function opAdd(b:BigInt):BigInt return _add(this, b);
	
/*	@:op(A += B) 
	public inline function add(b:BigInt):BigInt {
		return this;
	}
*/	
	static inline function _add(a:BigInt, b:BigInt):BigInt {
		if (a == null) return (b == null) ? null : b.copy();
		else if (b == null) return a.copy();
		else if (a.isNegative) {
			if (b.isNegative) return __add(a, b).setNegative(); // -3 + -2
			else return __subtract(b, a.negClone()); // -3 + 2
		}
		else {
			if (b.isNegative) return __subtract(a, b.negClone()); // 3 + -2
			else return __add(a, b); // 3 + 2
		}
	}
	
	static inline function __add(a:BigInt, b:BigInt):BigInt {
		if (a.length > b.length) {
			return addLong(a.copy(), b);
		}
		else return addLong(b.copy(), a);
	}
	
	static inline function addLong(a:BigInt, b:BigInt):BigInt {
		for (position in 0...b.length) {
			addLittle(a, b.get(position), position);
		}
		return a;
	}
	
	static inline function addLittle(a:BigInt, v:LittleInt, position:Int):Void {
		var x:Int;
		for (i in position...a.length) {
			x = a.get(i) + v;
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
	
	// --------------------------------------------------------------------
	// -------------------- subtraction -----------------------------------
	// --------------------------------------------------------------------	
	
	@:op(A - B) function opSubtract(b:BigInt):BigInt return _subtract(this, b);

/*	@:op(A -= B) public inline function subtract(b:BigInt):BigInt {
		return this = _subtract(this, b);
	}
*/	
	static inline function _subtract(a:BigInt, b:BigInt):BigInt {
		if (a == null) return (b == null) ? null : b.negCopy();
		else if (b == null) return a.copy();
		else if (a.isNegative) {
			if (b.isNegative) return __subtract(b.negClone(), a.negClone());// -3 - -2
			else return __add(a, b).setNegative(); // -3 - 2
		}
		else {
			if (b.isNegative) return __add(a, b.negClone()); // 3 - -2
			else return __subtract(a, b);  // 3 - 2
		}
	}

	static inline function __subtract(a:BigInt, b:BigInt):BigInt {
		var v:BigInt;
		if (a > b) {
			v = subtractLong(a.copy(), b);
			v.truncateZeroChunks(false);
			return v;
		}
		else {
			v = subtractLong(b.copy(), a);
			v.truncateZeroChunks(false);
			if (v.length == 0) return null else return v.setNegative();
		}
	}

	static inline function subtractLong(a:BigInt, b:BigInt):BigInt {
		for (position in 0...b.length) {
			subtractLittle(a, b.get(position), position);
		}
		return a;
	}

	static inline function subtractLittle(a:BigInt, v:LittleInt, position:Int):Void {		
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
	
	
	// --------------------------------------------------------------------
	// -------------------- multiplication --------------------------------
	// --------------------------------------------------------------------	
	// (katatsuba: https://en.wikipedia.org/wiki/Karatsuba_algorithm) -----
	
	@:op(A * B)
	function opMulticplicate(b:BigInt):BigInt {
		if (this == null || b == null) return null;
		if (isNegative != b.isNegative) return mul(this, b).setNegative();
		else return mul(this, b);
	}
	
	static inline function mulLittle(a:BigInt, v:LittleInt):BigInt {		
		if (v == 1) return a.copy();
		if (v < 0) v = -v;
		var x:Int = 0;
		var b = new BigInt(new LittleIntChunks());
		for (i in 0...a.length) {
			x = a.get(i) * v + x;
			b.push(x & LittleIntChunks.BITMASK);
			x = x >>> LittleIntChunks.BITSIZE;
		}
		if (x > 0) b.push(x);
		return(b);
	}
	
	static function mul(a:BigInt, b:BigInt):BigInt {		
		if (a == null || b == null) return null;
		if (a.length == 1) {
			if (b.length == 1) return fromInt(a.get(0) * b.get(0));
			return mulLittle(b, a.get(0));
		}
		if (b.length == 1) return mulLittle(a, b.get(0));
		
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
	
	
	// --------------------------------------------------------------------
	// ---------------- division and modulo -------------------------------
	// --------------------------------------------------------------------	
	
	@:op(A / B)
	function opDivMod(b:BigInt):BigInt {
		return divMod(this, b).quotient;
	}
	
	@:op(A % B)
	function opModulo(b:BigInt):BigInt {
		return divMod(this, b).remainder;
	}
	
	// ------- division with remainder -----

	static public function divMod(a:BigInt, b:BigInt):{quotient:BigInt, remainder:BigInt} {			
		if (b == null) throw ("Error '/', divisor can't be 0");
		else if (a == null) return { quotient:null, remainder:null }; // handle null
		else if (b == 1) return { quotient:a.copy(), remainder:null }; // handle /1
		else if (a == b) return { quotient:1, remainder:null }; // handle equal
		else {
			// handle signs
			var ret:{quotient:BigInt, remainder:BigInt};
			
			if (a.isNegative) {
				if (b.isNegative) {
					ret = _divMod(a.negClone(), b.negClone());
					if (ret.remainder != null) ret.remainder.setNegative();
				}
				else {
					ret = _divMod(a.negClone(), b);
					if (ret.quotient != null) ret.quotient.setNegative();
					if (ret.remainder != null) ret.remainder.setNegative();
				}
			}
			else {
				if (b.isNegative) {
					ret = _divMod(a, b.negClone());
					if (ret.quotient != null) ret.quotient.setNegative();
				}
				else return _divMod(a, b);
			}
			
			return ret;
		}
	}
	
	static inline function _divMod(a:BigInt, b:BigInt):{quotient:BigInt, remainder:BigInt} {		
		if (b.length <= 2) {
			if (a.length <= 2) return {
				quotient: fromInt( Std.int(a.toInt() / b.toInt() )), // optimize!
				remainder:fromInt( Std.int(a.toInt() % b.toInt() ))
			}
			else if (b.length == 1) {
				if (b.get(0) == 1) return { quotient:a, remainder:null };
				return divModLittle(a, b.toInt());
			}
			else return divModLong(a, b);
		}
		else return divModLong(a, b);
	}
	
	static inline function divModLittle(a:BigInt, v:LittleInt):{quotient:BigInt, remainder:BigInt} {		
		var i = a.length - 1;
		var x:LittleInt = (a.get(i) << LittleIntChunks.BITSIZE) | a.get(--i);
		var q:BigInt = Std.int( x / v );
		var r:LittleInt = Std.int( x % v );
		var c:Int;
		do {
			x = (r << LittleIntChunks.BITSIZE) | a.get(--i);
			
			c = Std.int( x / v ); // <- can be 2 chunks
			if (c >= LittleIntChunks.UPPESTBIT) {
				q.unshift(c >>> LittleIntChunks.BITSIZE);
				q.unshift(c & LittleIntChunks.BITMASK);
			}
			else q.unshift(c);
			
			r = Std.int( x % v );
		}
		while (i > 0);
		return { quotient:q, remainder:r };
	}
	
	
	static inline function divFast(a:BigInt, v:LittleInt):BigInt {		
		if (a == null) return null; // handle null
		else if (a == v) return 1; // handle equal
		else {
			//return _divMod(a, v).quotient;
			
			// optimized to faster fetch only quotient and do without sign-check
			if (a.length <= 2) return Std.int(a.toInt() / v );
			else  {
				if (v == 1) return null;
				else return divModLittle(a, v).quotient;
			}
		}
	}
	
	static function divModLong(a:BigInt, b:BigInt):{quotient:BigInt, remainder:BigInt} {		
		var e = b.length - 1;
		var r:BigInt;
		var x:LittleInt = b.get(e);
		var q:BigInt = divFast(a.splitHigh(e) , x);
		do {
			r = a - (q * b); //trace("r = " + r);
			if (r != null) {
				q.shiftOneBitLeft();
				q = q - divFast(r.splitHigh(e), x);
				q.shiftOneBitRight();
				r.setPositive();
			}
		}
		while (r >= b);
		
		if (r != null) {
			r = a - (q * b );
			if (r.isNegative) {
				//q = q - 1;
				subtractLittle(q, 1, 0);
				r = r + b;
			}
		}
		return { quotient:q, remainder:r };
	}
	
	// --------------------------------------------------------------------
	// ---------------------- pow and powMod ------------------------------
	// --------------------------------------------------------------------
	public function pow(exponent:BigInt):BigInt {
		if (exponent < 0) throw ("Error 'powMod', exponent can't be negative");
		if (exponent == null) return 1;
		if (this == null) return null;
		
		if (length == 1 && get(0) == 1) return 1;
		if (exponent.length == 1 && exponent.get(0) == 1) return this.copy();
		
		var bit:Int;
		var e:Int;
		var maxBits:Int;

		var result:BigInt = 1;
		var base:BigInt = this; // need .copy() here?
		
		for (i in 0...exponent.length) {
			e = exponent.get(i);
			bit = 1;
			if (i == exponent.length - 1) maxBits = 1 << IntUtil.bitsize(e);
			else maxBits = LittleIntChunks.UPPESTBIT;
			while (bit < maxBits) {
				if (bit & e != 0) result = result * base;
				base = base * base;
				bit = bit << 1;
			}
		}
		return result;
	}
	
	public function powMod(exponent:BigInt, modulus:BigInt):BigInt {
		if (exponent < 0) throw ("Error 'powMod', exponent can't be negative");
		if (modulus == null) throw ("Error 'powMod', modulus can't be 0");
		if (modulus == 1) return null;
		
		if (exponent == null) return 1;
		if (this == null) return null;
		
		if (length == 1 && get(0) == 1) return 1;
		if (exponent.length == 1 && exponent.get(0) == 1) return divMod(this, modulus).remainder;
		
		var bit:Int;
		var e:Int;
		var maxBits:Int;

		var result:BigInt = 1;
		var base:BigInt = divMod(this, modulus).remainder;
		
		for (i in 0...exponent.length) {
			e = exponent.get(i);
			bit = 1;
			if (i == exponent.length - 1) maxBits = 1 << IntUtil.bitsize(e);
			else maxBits = LittleIntChunks.UPPESTBIT;
			while (bit < maxBits) {
				if (bit & e != 0) result = divMod(result * base, modulus).remainder;
				base = divMod(base * base, modulus).remainder;
				bit = bit << 1;
			}
		}
		return result;
	}
	
	// --------------------------------------------------------------------
	// -------------------- binary operations -----------------------------
	// --------------------------------------------------------------------
	
	public function shiftOneBitRight() {
		if (this != null) {
			var i:Int = length - 1;
			var v = get(i);
			var restBit:Bool = ((v & 1) > 0);
			v = v >>> 1;
			if (v != 0) set(i, v) else this.pop();
			while (i-- > 0) {
				v = get(i);
				if (restBit) v |= LittleIntChunks.UPPESTBIT;
				restBit = ((v & 1) > 0);
				set(i, v >>> 1);
			}
		}
	}
	
	public function shiftOneBitLeft() {
		if (this != null) {
			var v:LittleInt = 0;
			for (i in 0...length) {
				v = (get(i) << 1) | ((v & LittleIntChunks.UPPESTBIT > 0) ? 1 : 0) ;
				set(i, v & LittleIntChunks.BITMASK);
			}
			if (v & LittleIntChunks.UPPESTBIT > 0) push(1);
		}
	}
	
	@:op(A >>> B)
	function opShiftRightUnsigned(b:Int):BigInt {
		return opShiftRight(b);
	}
	
	@:op(A >> B)
	function opShiftRight(b:Int):BigInt {
		if (this == null) return null;
		if (b == 0) return this.copy();
		if (b < 0) return opShiftLeft(-b);

		var result:BigInt = new BigInt(new LittleIntChunks());
		var l:Int = Std.int(b / LittleIntChunks.BITSIZE);
		var r:Int = b - l * LittleIntChunks.BITSIZE;
		
		if (r == 0)
			for (i in l...length) result.push(get(i));
		else {
			var v:Int;
			var restBits:Int = 0;
			var i = length;
			while (i-- > l) {
				v = get(i);
				if (result.length > 0 || ((v >>> r) | restBits) > 0)
					result.unshift((v >>> r) | restBits);
				restBits = (v << (LittleIntChunks.BITSIZE - r)) & LittleIntChunks.BITMASK;
			}
		}
		
		if (result.length == 0) return null;
		else {
			if (isNegative) result.setNegative();
			return result;
		}
	}
	
	@:op(A << B)
	inline function opShiftLeft(b:Int):BigInt {
		if (this == null) return null;
		if (b == 0) return this.copy();
		if (b < 0) return opShiftRight(-b);
		
		var result:BigInt = new BigInt(new LittleIntChunks());
		var l:Int = Std.int(b / LittleIntChunks.BITSIZE);
		var r:Int = b - l * LittleIntChunks.BITSIZE;
		for (i in 0...l) result.push(0);
		if (r == 0)
			for (i in 0...length) result.push(get(i));
		else {
			var v:Int;
			var restBits:Int = 0;
			for (i in 0...length) {
				v = get(i);
				result.push( ((v << r) & LittleIntChunks.BITMASK) | restBits);
				restBits = v >>> (LittleIntChunks.BITSIZE - r);
			}
			if (restBits > 0) result.push(restBits);
		}
		if (isNegative) result.setNegative();
		return result;
	}
	
	@:op(A & B)
	function opAND(b:BigInt):BigInt {
		if (this == null || b == null) return null;

		var result:BigInt = null;
		var r:LittleInt;
		var i = (length < b.length) ? length : b.length;
		while (i-- > 0) {
			r = this.get(i) & b.get(i);
			if (result != null)
				result.unshift(r);
			else if (r != 0) {
				result = new BigInt(new LittleIntChunks());
				result.unshift(r);
			} 
		}
		if (this.isNegative && b.isNegative) result.setNegative();
		return result;
	}
	
	@:op(A | B)
	function opOR(b:BigInt):BigInt {
		if (this == null || b == null) return null;
		
		var result:BigInt = new BigInt(new LittleIntChunks());
		var l = (length < b.length) ? length : b.length;
		for (i in 0...l) {
			result.push(this.get(i) | b.get(i));
		}
		if (length < b.length)
			for (i in l...b.length) result.push(b.get(i));
		else if (length > b.length)
			for (i in l...length) result.push(this.get(i));
		
		if (this.isNegative || b.isNegative) result.setNegative();
		return result;
	}
	
	@:op(A ^ B)
	function opXOR(b:BigInt):BigInt {
		if (this == null || b == null) return null;
		
		var result:BigInt = new BigInt(new LittleIntChunks());
		var l = (length < b.length) ? length : b.length;
		for (i in 0...l) {
			result.push(this.get(i) ^ b.get(i));
		}
		if (length < b.length)
			for (i in l...b.length) result.push(b.get(i));
		else if (length > b.length)
			for (i in l...length) result.push(this.get(i));
		
		if (this.isNegative != b.isNegative) result.setNegative();
		return result;
	}
	
	// --------------------------------------------------------------------
	// -------------------- comparing -------------------------------------
	// --------------------------------------------------------------------

	@:op(A > B)
	function greater(b:BigInt):Bool {
		if (this == null) {
			if (b == null) return false;
			else return (b.isNegative) ? true : false;
		}
		if (b == null) return (isNegative) ? false : true;
		if (isNegative != b.isNegative) return (isNegative) ? false : true;
		if (length > b.length) return (isNegative) ? false : true;
		if (length < b.length) return (isNegative) ? true : false;

		var i = length;
		while (i-- > 0) {
			if (get(i) > b.get(i)) return (isNegative) ? false : true;
			if (get(i) < b.get(i)) return (isNegative) ? true : false;
		}
		return false;
	}
	
	@:op(A >= B)
	function greaterOrEqual(b:BigInt):Bool {
		if (this == null) {
			if (b == null) return true;
			return (b.isNegative) ? true : false;
		}
		if (b == null) return (isNegative) ? false : true;
		if (isNegative != b.isNegative) return (isNegative) ? false : true;
		if (length > b.length) return (isNegative) ? false : true;
		if (length < b.length) return (isNegative) ? true : false;

		var i = length;
		while (i-- > 0) {
			if (get(i) > b.get(i)) return (isNegative) ? false : true;
			if (get(i) < b.get(i)) return (isNegative) ? true : false;
		}
		return true;		
	}
	
	@:op(A < B)
	function lesser(b:BigInt):Bool {
		if (this == null) {
			if (b == null) return false;
			else return (b.isNegative) ? false : true;
		}
		if (b == null) return (isNegative) ? true : false;
		if (isNegative != b.isNegative) return (isNegative) ? true : false;
		if (length < b.length) return (isNegative) ? false : true;
		if (length > b.length) return (isNegative) ? true : false;

		var i = length;
		while (i-- > 0) {
			if (get(i) < b.get(i)) return (isNegative) ? false : true;
			if (get(i) > b.get(i)) return (isNegative) ? true : false;
		}
		return false;
	}
	
	@:op(A <= B)
	function lesserOrEqual(b:BigInt):Bool {
		if (this == null) {
			if (b == null) return true;
			else return (b.isNegative) ? false : true;
		}
		if (b == null) return (isNegative) ? true : false;
		if (isNegative != b.isNegative) return (isNegative) ? true : false;
		if (length < b.length) return (isNegative) ? false : true;
		if (length > b.length) return (isNegative) ? true : false;

		var i = length;
		while (i-- > 0) {
			if (get(i) < b.get(i)) return (isNegative) ? false : true;
			if (get(i) > b.get(i)) return (isNegative) ? true : false;
		}
		return true;
	}
	
	@:op(A == B)
	function equal(b:BigInt):Bool {
		if (this == null) return (b == null) ? true : false;
		if (b == null) return false;
		if (isNegative != b.isNegative) return false;
		if (length != b.length) return false;
		
		var i = length;
		while (i-- > 0) {
			if (get(i) != b.get(i)) return false;
		}
		return true;
	}
	
	@:op(A != B)
	function notEqual(b:BigInt):Bool {
		if (this == null) return (b == null) ? false : true;
		if (b == null) return true;
		if (isNegative != b.isNegative) return true;
		if (length != b.length) return true;
		
		var i = length;
		while (i-- > 0) {
			if (get(i) != b.get(i)) return true;
		}
		return false;
	}
	
	
}
