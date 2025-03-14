package;

import LittleIntChunks;
import haxe.io.Bytes;

/**
 * pure haxe implementation for arbitrary-precision integer
 * 
 * by Sylvio Sell, Rostock 2020
 * 
 */

abstract BigInt(LittleIntChunks) from LittleIntChunks {
	
	inline function new(littleIntChunks:LittleIntChunks) this = littleIntChunks;
	
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
	
    /**
        return true if this BigInt is negative signed
    **/
	public var isNegative(get, never):Bool;
	inline function get_isNegative():Bool return this.isNegative;
	
    /**
        return true if this BigInt is positive signed
    **/
	public var isPositive(get, never):Bool;
	inline function get_isPositive():Bool return !this.isNegative;
	
    /**
        return the number of chunks that is needed to store this BigInt
    **/
	public var chunksLength(get, never):Int;
	inline function get_chunksLength():Int return (this == null) ? 0 : this.length;
	
	var length(get, never):Int;
	inline function get_length():Int return this.length;
	
    /**
        return true if this BigInt is 0 (same as null)
    **/
	public var isZero(get, never):Bool;
	inline function get_isZero():Bool return (this == null);
	
    /**
        Creates a new BigInt from an Integer

        @param  i  the Int value to create BigInt from
    **/
	@:from static public function fromInt(i:LittleInt):BigInt {
		return new BigInt(LittleIntChunks.createFromLittleInt(i));
	}
	
    /**
        Converts this BigInt into an Integer. If it's to long for native Integer-length it will throw an error.
    **/
	@:to public function toInt():LittleInt {
		if (this == null) return 0;
		return this.toLittleInt();
	}
	
    /**
        Creates a new BigInt from a String e.g. from a decimal like "1234567890".
		It also accepts a prefix to define numbers to another base e.g.:
		"0b 11001101" for binary, "0o 12345670" for octal or "0x ffaa 1234" for hexadecimal notation.
		For negative valued the "-" sign has to be written first e.g. "-0x FF".

        @param  s  the String that representing the number
    **/
	@:from static public function fromString(s:String):BigInt {
		return LittleIntChunks.createFromBaseString(s);
	}
	
    /**
        Converts this BigInt into a String (decimal notation).
    **/
	@:to public function toString():String {
		if (this == null) return "0";
		return this.toBaseString(10);	
	}	
	
    /**
        Creates a new BigInt from a String that contains a binary formated number, e.g. "01010111" or "- 1001 1011"

        @param  binaryString  the String that representing the number in binary format
    **/
	static public function fromBinaryString(binaryString:String):BigInt {
		return LittleIntChunks.createFromBaseString(binaryString, 2);
	}
	
    /**
        Creates a new BigInt from a String that contains a hexadecimal formated number, e.g. "FE0504C" or "-ff00 10ab"

        @param  hexString  the String that representing the number in hexadecimal format
    **/
	static public function fromHexString(hexString:String):BigInt {
		return LittleIntChunks.createFromBaseString(hexString, 16);
	}
	
    /**
        Creates a new BigInt from a String that contains a octal formated number, e.g. "070744" or "-77"

        @param  octalString  the String that representing the number in octal format
    **/
	static public function fromOctalString(octalString:String):BigInt {
		return LittleIntChunks.createFromBaseString(octalString, 8);
	}
	
    /**
        Creates a new BigInt from a String of numbers of a specific base

        @param  numberString  the String that representing the number
        @param  base  the base of numberformat (on null it is set to digitChars.length or to 10 instead)
        @param  digitChars  a String of ordered digit chars for number representation (default is "0123456789abcdef")
    **/
	static public function fromBaseString(numberString:String, base:Null<Int> = null, digitChars:Null<String> = null):BigInt {
		if (base == null) {
			if (digitChars == null) base = 10;
			else base = digitChars.length;
		}
		return LittleIntChunks.createFromBaseString(numberString, base, digitChars);
	}
	
	
    /**
        Converts this BigInt into a String (binary notation).
		
        @param  spacing  the amount of summarized digits before the separation by a space-char (default value of 0 disable spacing)
        @param  leadingZeros  fills up the first digits with zeros up to the spacing-amount (default is true)
    **/
	public function toBinaryString(spacing:Int = 0, leadingZeros:Bool = true):String {
		if (this == null) return (leadingZeros && spacing > 0) ? LittleIntChunks.getStringOfZeros(spacing) : "0";
		return this.toBinaryString(spacing, leadingZeros);
	}	
	
    /**
        Converts this BigInt into a String (octal notation).
		
        @param  spacing  the amount of summarized digits before the separation by a space-char (default value of 0 disable spacing)
        @param  leadingZeros  fills up the first digits with zeros up to the spacing-amount (default is true)
    **/
	public function toOctalString(spacing:Int = 0, leadingZeros:Bool = true):String {
		if (this == null) return (leadingZeros && spacing > 0) ? LittleIntChunks.getStringOfZeros(spacing) : "0";
		return this.toBaseString(8, spacing, leadingZeros);
	}	
	
    /**
        Converts this BigInt into a String (hexadecimal notation).
		
        @param  upperCase  output hex number into lowercase letters
        @param  spacing  the amount of summarized digits before the separation by a space-char (default value of 0 disable spacing)
        @param  leadingZeros  fills up the first digits with zeros up to the spacing-amount (default is true)
    **/
	public function toHexString(?upperCase:Bool = true, spacing:Int = 0, leadingZeros:Bool = true):String {
		if (this == null) return (leadingZeros && spacing > 0) ? LittleIntChunks.getStringOfZeros(spacing) : "0";
		return this.toHexString(upperCase, spacing, leadingZeros);	
	}
	
    /**
        Converts this BigInt into a String to a defined base.
		
        @param  base  the base of numberformat (on null it is set to digitChars.length or to 10 instead)
        @param  digitChars  a String of ordered digit chars for number representation (default is "0123456789abcdef")
        @param  spacing  the amount of summarized digits before the separation by a space-char (default value of 0 disable spacing)
        @param  leadingZeros  fills up the first digits with zeros up to the spacing-amount (default is true)
    **/
	public function toBaseString(base:Null<Int> = null, digitChars:Null<String> = null, spacing:Int = 0, leadingZeros:Bool = true):String {
		if (base == null) {
			if (digitChars == null) base = 10;
			else base = digitChars.length;
		}
		if (this == null) {
			var zeroDigitChar = "0";
			if (digitChars != null) {
				if (base < 2)  throw('Error, base $base need to be greater or equal 2');
				if (base > digitChars.length) throw('Error, base $base for string output is to great. Max value can be ${digitChars.length}');
				zeroDigitChar = digitChars.charAt(0);
			}
			return (leadingZeros && spacing > 0) ? LittleIntChunks.getStringOfZeros(spacing, zeroDigitChar) : zeroDigitChar;
		}
		return this.toBaseString(base, digitChars, spacing, leadingZeros);	
	}
	
	
    /**
        Creates a new BigInt from Bytes.

        @param  bytes  the Bytes that was stored by ".toBytes()"
    **/
	static public function fromBytes(bytes:Bytes):BigInt {
		return LittleIntChunks.fromBytes(bytes);
	}
	
    /**
        pack this BigInt into Bytes for efficiently storage.
    **/
	public function toBytes():Bytes {
		if (this == null) {
			var b = Bytes.alloc(1);
			b.set(0, 0);
			return b;
		}
		return this.toBytes();	
	}
	
	
	
	// --------------------------------------------------------------------
	// -------------------- abs -------------------------------------------
	// --------------------------------------------------------------------
	
    /**
        returns a new BigInt of the absolute amount
    **/
	public inline function abs():BigInt {
		if (this == null) return null;
		if (isNegative) return negCopy();
		return copy();
	}
	
	
	
	// --------------------------------------------------------------------
	// -------------------- addition --------------------------------------
	// --------------------------------------------------------------------
	
	/**
		Returns the sum of `a` and `b`.
	**/
	@:op(A + B) function opAdd(b:BigInt):BigInt return _add(this, b);
	//@:op(A + B) @:commutative function opAddInt(b:Int):BigInt return _add(this, b);
	@:op(A + B) static function opAddInt(a:Int, b:BigInt):BigInt return _add(a, b); // haxe 3.4.4 compatible!
	
	@:op(A++) inline function opIncrementAfter():BigInt {
		if (this == null) {
			this = LittleIntChunks.createFromLittleInt(1);
			return null;
		}
		var ret = copy();
		if (isNegative) {
			if (length == 1 && get(0) == 1) this = null;
			else {
				subtractLittle(this, 1, 0);
				truncateZeroChunks(true);
			}
		}
		else addLittle(this, 1, 0);
		return ret;
	}
	
	@:op(++A) inline function opIncrementBefore():BigInt {
		if (this == null) {
			this = LittleIntChunks.createFromLittleInt(1);
			return LittleIntChunks.createFromLittleInt(1);
		}
		if (isNegative) {
			if (length == 1 && get(0) == 1) {
				this = null;
				return null;
			}
			else {
				subtractLittle(this, 1, 0);
				truncateZeroChunks(true);
				return copy();
			}
		}
		else {
			addLittle(this, 1, 0);
			return copy();
		}
	}	
	
	static inline function _add(a:BigInt, b:BigInt):BigInt {
		if (a == null) return (b == null) ? null : b.copy();
		if (b == null) return a.copy();
		if (a.isNegative) {
			if (b.isNegative) return __add(a, b).setNegative(); // -3 + -2
			return __subtract(b, a.negClone()); // -3 + 2
		}
		if (b.isNegative) return __subtract(a, b.negClone()); // 3 + -2
		return __add(a, b); // 3 + 2
	}
	
	static inline function __add(a:BigInt, b:BigInt):BigInt {
		if (a.length > b.length) return addLong(a.copy(), b);
		return addLong(b.copy(), a);
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
	
	/**
		Returns `a` minus `b`.
	**/	
	@:op(A - B) function opSubtract(b:BigInt):BigInt return _subtract(this, b);
	//@:op(A - B) static function opSubtractInt(a:BigInt, b:Int):BigInt return _subtract(a, b);
	@:op(A - B) static function opIntSubtract(a:Int, b:BigInt):BigInt return _subtract(a, b);
	
	@:op(A--) inline function opDecrementAfter():BigInt {
		if (this == null) {
			this = LittleIntChunks.createFromLittleInt(-1);
			return null;
		}
		var ret = copy();
		if (isNegative) addLittle(this, 1, 0);
		else {
			if (length == 1 && get(0) == 1) this = null;
			else {
				subtractLittle(this, 1, 0);
				truncateZeroChunks(true);
			}
		}
		return ret;
	}
	
	@:op(--A) inline function opDecrementBefore():BigInt {
		if (this == null) {
			this = LittleIntChunks.createFromLittleInt(-1);
			return LittleIntChunks.createFromLittleInt(-1);
		}
		if (isNegative) {
			addLittle(this, 1, 0);
			return copy();
		}
		else {
			if (length == 1 && get(0) == 1) {
				this = null;
				return null;
			}
			else {
				subtractLittle(this, 1, 0);
				truncateZeroChunks(true);
				return copy();
			}
		}		
	}	
	
	static inline function _subtract(a:BigInt, b:BigInt):BigInt {
		if (a == null) return (b == null) ? null : b.negCopy();
		if (b == null) return a.copy();
		if (a.isNegative) {
			if (b.isNegative) return __subtract(b.negClone(), a.negClone());// -3 - -2
			return __add(a, b).setNegative(); // -3 - 2
		}
		if (b.isNegative) return __add(a, b.negClone()); // 3 - -2
		return __subtract(a, b);  // 3 - 2
	}
	
	static inline function __subtract(a:BigInt, b:BigInt):BigInt {
		var v:BigInt;
		if (a > b) {
			v = subtractLong(a.copy(), b);
			v.truncateZeroChunks(true);
			return v;
		}
		
		v = subtractLong(b.copy(), a);
		v.truncateZeroChunks(true);
		return (v.length == 0) ? null : v.setNegative();
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
	
	/**
		Returns the negative.
	**/
	@:op(-B)
	inline function negation():BigInt {
		if (this == null) return null;
		return this.negCopy();
	}
	
	
	
	// --------------------------------------------------------------------
	// -------------------- multiplication --------------------------------
	// --------------------------------------------------------------------
	// (katatsuba: https://en.wikipedia.org/wiki/Karatsuba_algorithm) -----
	
	/**
		Returns the product of `a` and `b`.
	**/
	@:op(A * B)
	function opMulticplicate(b:BigInt):BigInt {
		if (this == null || b == null) return null;
		if (isNegative != b.isNegative) return mul(this, b).setNegative();
		return mul(this, b).setPositive();
	}
	//@:op(A * B) @:commutative function opMulticplicateInt(b:Int):BigInt return opMulticplicate(b);
	@:op(A * B) static inline function opMulticplicateInt(a:Int, b:BigInt):BigInt return b.opMulticplicate(a); // haxe 3.4.4 compatible!
	
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
		
		//return join(e, p1, mul(aHigh + aLow, bHigh + bLow) - (p1 + p2), p2 );
		return join(e, p1, mul(_add(aHigh, aLow), _add(bHigh, bLow)) - _add(p1, p2), p2 );
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
			//if (c.length > e) b = b + c.splitHigh(e);
			if (c.length > e) b = _add(b, c.splitHigh(e));
/*			if (c.length > e) {
				var ch = c.splitHigh(e);
				if (ch != null) {
					if (b == null) b = ch;
					else if (b.length > ch.length) addLong(b, ch);
					//else b = addLong(ch.copy(), b);
					else b = addLong(ch, b);
				}
			}
*/		
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
			//if (b.length > e) a += b.splitHigh(e);
			if (b.length > e) a = _add(a, b.splitHigh(e));
/*			if (b.length > e) {
				var bh = b.splitHigh(e);
				if (bh != null) {
					if (a == null) a = bh;
					else if (a.length > bh.length) addLong(a, bh);
					else a = addLong(bh.copy(), a);
				}
			}
*/		
		}
		
		if (a != null) for (i in 0...a.length) littleIntChunks.push(a.get(i));

		// to fix this: https://github.com/maitag/littleBigInt/issues/1
		littleIntChunks.truncateZeroChunks(true);

		return littleIntChunks;
	}
	
	
	
	// --------------------------------------------------------------------
	// ---------------- division and modulo -------------------------------
	// --------------------------------------------------------------------
	
	/**
		Returns the quotient of `a` divided by `b`.
	**/
	@:op(A / B)
	function opDiv(b:BigInt):BigInt {
		return divMod(this, b).quotient;
	}
	//@:op(A / B) static function opDivInt(a:BigInt, b:Int):BigInt return divMod(a, b).quotient;
	@:op(A / B) static function opIntDiv(a:Int, b:BigInt):BigInt return divMod(a, b).quotient;

	/**
		Returns the modulus of `a` divided by `b`.
	**/
	@:op(A % B)
	function opModulo(b:BigInt):BigInt {
		return divMod(this, b).remainder;
	}
	//@:op(A % B) static function opModuloInt(a:BigInt, b:Int):BigInt return divMod(a, b).remainder;
	@:op(A % B) static function opIntModulo(a:Int, b:BigInt):BigInt return divMod(a, b).remainder;


	// ------- division with remainder -----

	/**
		Performs signed integer divison of `dividend` by `divisor`.
		Returns `{ quotient: BigInt, remainder: BigInt }`.
	**/	
	static public inline function divMod(dividend:BigInt, divisor:BigInt):{quotient:BigInt, remainder:BigInt} {			
		if (divisor == null) throw ("Error '/', divisor can't be 0");
		if (dividend == null) return { quotient:null, remainder:null }; // handle null
		if (divisor == 1) return { quotient:dividend.copy(), remainder:null }; // handle dividing by 1
		if (dividend == divisor) return { quotient:1, remainder:null }; // handle equal
		
		// handle in depend of signs
		var ret:{quotient:BigInt, remainder:BigInt};
		if (dividend.isNegative) {
			if (divisor.isNegative) {
				ret = _divMod(dividend.negClone(), divisor.negClone());
				if (ret.remainder != null) ret.remainder.setNegative();
			}
			else {
				ret = _divMod(dividend.negClone(), divisor);
				if (ret.quotient != null) ret.quotient.setNegative();
				if (ret.remainder != null) ret.remainder.setNegative();
			}
		}
		else {
			if (divisor.isNegative) {
				ret = _divMod(dividend, divisor.negClone());
				if (ret.quotient != null) ret.quotient.setNegative();
			}
			else ret = _divMod(dividend, divisor);
		}		
		return ret;
	}
	
	static inline function _divMod(a:BigInt, b:BigInt):{quotient:BigInt, remainder:BigInt} {		
		if (b.length <= 2) {
			if (a.length <= 2) return {
				quotient: fromInt( Std.int(a.toInt() / b.toInt() )), // TODO: optimized toInt() without bitsize-check!
				remainder:fromInt( Std.int(a.toInt() % b.toInt() ))  // TODO: optimized toInt() without bitsize-check!
			}
			if (b.length == 1) {
				if (b.get(0) == 1) return { quotient:a, remainder:null };
				return divModLittle(a, b.toInt()); // TODO: optimized toInt() without bitsize-check!
			}
			return divModLong(a, b);
		}
		return divModLong(a, b);
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
		} while (i > 0);
		
		return { quotient:q, remainder:r };
	}
	
	
	// optimized div to faster fetch only quotient and do without sign-check
	static inline function divFast(a:BigInt, v:LittleInt):BigInt {		
		if (a == null) return null; // handle null
		if (a == v) return 1; // handle equal
		if (v == 1) return a.copy(); // handle dividing by 1
		if (a.length <= 2) return Std.int(a.toInt() / v ); // TODO: optimized toInt() without bitsize-check!
		return divModLittle(a, v).quotient;
	}
	
	static function divModLong(a:BigInt, b:BigInt):{quotient:BigInt, remainder:BigInt} {		
		var e = b.length - 1;
		var r:BigInt;
		var x:LittleInt = b.get(e);
		var q:BigInt = divFast(a.splitHigh(e), x);
		
		do {
			r = a - (q * b);
			if (r != null) {
				q.shiftOneBitLeft();
				q = q - divFast(r.splitHigh(e), x);
				q.shiftOneBitRight();
				r.setPositive();
			}
		} while (r >= b);
				
		if (r != null) {
			r = a - (q * b );
			if (r.isNegative) {
				subtractLittle(q, 1, 0);
				q.truncateZeroChunks(true);
				r = r + b;
			}
		}

		return { quotient:q, remainder:r };
	}
	
	/*
	// more near to this one: https://justinparrtech.com/JustinParr-Tech/an-algorithm-for-arbitrary-precision-integer-division/
	static function divModLong(a:BigInt, b:BigInt):{quotient:BigInt, remainder:BigInt} {		
		var e = b.length - 1;
		var r:BigInt;
		var x:LittleInt = b.get(e);
		var q:BigInt = divFast(a.splitHigh(e), x);
		var qn:BigInt;
		
		do {
			//trace(q);
			r = a - (q * b);//trace("check",q*b);
			if (r != null) {
				if (r.isPositive) {
					qn = q + divFast(r.splitHigh(e), x);
				}
				else {
					qn = q - divFast(r.splitHigh(e), x);
				}
				q = (qn + q) / 2;		
			}
		} while (r.abs() >= b && q >=0);
			
		if (r != null) {
			r = a - (q * b );
			if (r.isNegative) {
				subtractLittle(q, 1, 0); //q = q - 1;
				q.truncateZeroChunks(true);
				r = r + b;
			}
		}
		return { quotient:q, remainder:r };
	}
	*/
	
	
	// --------------------------------------------------------------------
	// ---------------------- pow and powMod ------------------------------
	// --------------------------------------------------------------------
	
	/**
		Returns the power of `a` with exponent `exponent`.
	**/
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
	
	/**
		Returns the power of `a` with `exponent` to a `modulus`.
	**/
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
	// -------------------- comparing -------------------------------------
	// --------------------------------------------------------------------

	/**
		Returns `true` if `a` is greater then `b`.
	**/
	@:op(A > B)
	function greater(b:BigInt):Bool {
		if (this == null) {
			if (b == null) return false;
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
		return false;
	}
	@:op(A > B) static inline function intGreater(a:Int, b:BigInt):Bool return b.lesser(a);
	
	/**
		Returns `true` if `a` is greater or equal to `b`.
	**/
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
	@:op(A >= B) static inline function intGreaterOrEqual(a:Int, b:BigInt):Bool return b.lesserOrEqual(a);
	
	/**
		Returns `true` if `a` is lesser then `b`.
	**/
	@:op(A < B)
	function lesser(b:BigInt):Bool {
		if (this == null) {
			if (b == null) return false;
			return (b.isNegative) ? false : true;
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
	@:op(A < B) static inline function intLesser(a:Int, b:BigInt):Bool return b.greater(a);
	
	/**
		Returns `true` if `a` is lesser or equal to `b`.
	**/
	@:op(A <= B)
	function lesserOrEqual(b:BigInt):Bool {
		if (this == null) {
			if (b == null) return true;
			return (b.isNegative) ? false : true;
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
	@:op(A <= B) static inline function intLesserOrEqual(a:Int, b:BigInt):Bool return b.greaterOrEqual(a);
	
	/**
		Returns `true` if `a` is equal to `b`.
	**/
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
	
	/**
		Returns `true` if `a` is not equal to `b`.
	**/
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
	
	
	
	
	// --------------------------------------------------------------------
	// -------------------- binary operations -----------------------------
	// --------------------------------------------------------------------
	
	/**
		Binary shift one bit right (works out of sign).
	**/
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
	
	/**
		Binary shift one bit left (works out of sign).
	**/
	public function shiftOneBitLeft() {
		if (this != null) {
			var v:LittleInt = 0;
			for (i in 0...length) {
				v = (get(i) << 1) | ((v & LittleIntChunks.UPPESTBIT > 0) ? 1 : 0);
				set(i, v & LittleIntChunks.BITMASK);
			}
			if (v & LittleIntChunks.UPPESTBIT > 0) push(1);
		}
	}
	
	/**
		Returns the bitwise NOT (two's complement).
	**/
	@:op(~B)
	function opNOT():BigInt {
		if (this == null) return BigInt.fromInt(-1);
		var ret:BigInt;
		if (isNegative) {
			if (length == 1 && get(0)==1) return null;
			ret = this.negCopy();
			subtractLittle(ret, 1, 0);
			ret.truncateZeroChunks(true);
			return ret;
		}
		ret = this.copy();
		addLittle(ret, 1, 0);
		return ret.setNegative();
	}
		
	/**
		Returns `a` right-shifted by `b` bits.
		To be compatible to `>>>` with integers this works only for non negative `a`.
	**/
	@:op(A >>> B)
	function opShiftRightUnsigned(b:Int):BigInt {
		if (this == null) return null;
		if (b == 0) return this.copy();
		if (isNegative) {
			//if (b > 0) throw("ERROR '>>>', can't shift a negative value a non-negative shifting direction"); 
			throw("ERROR '>>>', can't shift a negative value"); 
			// TODO: if (b < 0): find the equivalent to two's complement implementation
		}
		if (b < 0) return null;
		return _opShiftRight(b);
	}
	
	/**
		Returns `a` right-shifted by `b` bits.
	**/
	@:op(A >> B)
	function opShiftRight(b:Int):BigInt {
		if (this == null) return null;
		if (b == 0) return this.copy();
		//if (b < 0) return _opShiftLeft( -b);
		if (isNegative) {
			if (b < 0) return BigInt.fromInt( -1);
			if (length == 1 && get(0) == 1) return BigInt.fromInt( -1);
			return opNOT()._opShiftRight(b).opNOT();
		}
		if (b < 0) return null; 
		return _opShiftRight(b);
	}	
	inline function _opShiftRight(b:Int):BigInt {
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
		if (isNegative) result.setNegative();
		return result;
	}
	
	/**
		Returns `a` left-shifted by `b` bits.
		Works only for non negative shift-direction.
	**/
	@:op(A << B)
	function opShiftLeft(b:Int):BigInt {
		if (this == null) return null;
		if (b == 0) return this.copy();		
		if (b < 0) throw("ERROR '<<', can't negative-shift-left a negative value");
		return _opShiftLeft(b);
	}	
	inline function _opShiftLeft(b:Int):BigInt {
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
	
	/**
		Returns the bitwise AND of `a` and `b`.
		No support for handling negative params yet (like for two's complement behavior).
	**/
	@:op(A & B)
	function opAND(b:BigInt):BigInt {
		if (this == null || b == null) return null;
		if (isNegative || b.isNegative) {
			// TODO (have no idea now ;)
			throw("ERROR '&', emulation of two's complement behavior for '&' with negative numbers is not implemented yet");
		}
		return _opAND(b);
	}	
	inline function _opAND(b:BigInt):BigInt {
		var result:BigInt = null;
		var r:LittleInt;
		var i = (length < b.length) ? length : b.length;
		while (i-- > 0) {
			r = this.get(i) & b.get(i);
			if (result != null)
				result.unshift(r);
			else if (r != 0) {
				result = new BigInt(new LittleIntChunks());
				//if (this.isNegative && b.isNegative) result.setNegative();
				result.unshift(r);
			} 
		}
		return result;
	}
	//@:op(A & B) @:commutative inline function opANDInt(b:Int):BigInt return opAND(b);
	@:op(A & B) static inline function opANDInt(a:Int, b:BigInt):BigInt return b.opAND(a); // haxe 3.4.4 compatible!
	
	/**
		Returns the bitwise OR of `a` and `b`.
		No support for handling negative params yet (like for two's complement behavior).
	**/
	@:op(A | B)
	function opOR(b:BigInt):BigInt {
		if (this == null) return b;
		if (b == null) return this;
		if (isNegative || b.isNegative) {
			// TODO:
			throw("ERROR '|', emulation of two's complement behavior for '|' with negative numbers is not implemented yet");
		}
		return _opOR(b);
	}	
	inline function _opOR(b:BigInt):BigInt {
		var result:BigInt = new BigInt(new LittleIntChunks());
		var l = (length < b.length) ? length : b.length;
		for (i in 0...l) {
			result.push(this.get(i) | b.get(i));
		}
		if (length < b.length)
			for (i in l...b.length) result.push(b.get(i));
		else if (length > b.length)
			for (i in l...length) result.push(this.get(i));
		
		//if (this.isNegative || b.isNegative) result.setNegative();
		return result;
	}
	//@:op(A | B) @:commutative inline function opOrInt(b:Int):BigInt return opOR(b);
	@:op(A | B) static inline function opOrInt(a:Int, b:BigInt):BigInt return b.opOR(a); // haxe 3.4.4 compatible!
	
	/**
		Returns the bitwise XOR of `a` and `b`.
		No support for handling negative params yet (like for two's complement behavior).
	**/
	@:op(A ^ B)
	function opXOR(b:BigInt):BigInt {
		if (this == null) return b;
		if (b == null) return this;
		if (isNegative || b.isNegative) {
			// TODO:
			throw("ERROR '^', emulation of two's complement behavior for '^' with negative numbers is not implemented yet");
		}
		return _opXOR(b);
	}
	
	inline function _opXOR(b:BigInt):BigInt {
		var result:BigInt = new BigInt(new LittleIntChunks());
		var l = (length < b.length) ? length : b.length;
		for (i in 0...l) {
			result.push(this.get(i) ^ b.get(i));
		}
		if (length < b.length)
			for (i in l...b.length) result.push(b.get(i));
		else if (length > b.length)
			for (i in l...length) result.push(this.get(i));		

		result.truncateZeroChunks(true);
		return (result.length == 0) ? null : result;
	}
	//@:op(A ^ B) @:commutative inline function opXORInt(b:Int):BigInt return opXOR(b);
	@:op(A ^ B) static inline function opXORInt(a:Int, b:BigInt):BigInt return b.opXOR(a); // haxe 3.4.4 compatible!
	
	
}
