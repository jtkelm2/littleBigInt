@:access(BigInt)
class TestBigInt extends haxe.unit.TestCase
{
	public function testFromToInt() {
		assertEquals( (0 : BigInt).toInt(), 0 );
		assertEquals( (-1 : BigInt).toInt(), -1 );
		assertEquals( (0x7FFFFFFF : BigInt).toInt(), 0x7FFFFFFF );
		assertEquals( ("0x7FFFFFFF" : BigInt).toInt(), 0x7FFFFFFF );
		assertEquals( (-0x7FFFFFFF : BigInt).toInt(), -0x7FFFFFFF );
		assertEquals( ("-0x7FFFFFFF" : BigInt).toInt(), -0x7FFFFFFF );
		#if neko
		assertTrue( try { ("0x80000000" : BigInt).toInt(); false; } catch (e:Dynamic) true );
		#end
	}
	
	public function testFromString() {
		assertTrue( ("" : BigInt) == 0 );
		assertTrue( (" 0 " : BigInt) == 0 );
		assertTrue( (" -0 " : BigInt) == 0 );
		assertTrue( (" -0 000 " : BigInt) == 0 );
		assertTrue( (" -  5" : BigInt) == -5 );
		assertTrue( ("9 " : BigInt) == 9 );
		assertTrue( ("255" : BigInt) == 255 );
		assertTrue( ("1 000" : BigInt) == 1000 );
		assertTrue( ("2147483647" : BigInt) == 2147483647 );
		assertTrue( ("-2147483647" : BigInt) == -2147483647 );
		assertTrue( ("-127" : BigInt) == -127 );
		assertTrue( ("- 128" : BigInt) == -128 );
	}
	
	public function testFromBaseString() {
		assertTrue( BigInt.fromBaseString("") == 0 );
		assertTrue( BigInt.fromBaseString("", 3) == 0 );
		assertTrue( BigInt.fromBaseString("", 3, "012") == 0 );
		assertTrue( BigInt.fromBaseString("", "012") == 0 );
		assertTrue( BigInt.fromBaseString("10") == 10 );
		assertTrue( BigInt.fromBaseString("0", 10) == 0 );
		assertTrue( BigInt.fromBaseString(" - 0", 10) == 0 );
		assertTrue( BigInt.fromBaseString("-54321", 10) == -54321 );
		assertTrue( BigInt.fromBaseString(" 54 321 ", 10) == 54321 );
		assertTrue( BigInt.fromBaseString("12345", 10) == 12345 );
		assertTrue( BigInt.fromBaseString("25", 8) == 21 );
		assertTrue( BigInt.fromBaseString("-100", 8) == -64 );
		assertTrue( BigInt.fromBaseString("7FFFFFFF", 16) == 0x7FFFFFFF );
		assertTrue( BigInt.fromBaseString("12", 3) == 5 );
		assertTrue( BigInt.fromBaseString("OOOx OOOO OOOO", "Ox") == 256 );
		assertTrue( BigInt.fromBaseString("hello", 25, "0123456789abcdefghijklmno") == 6873049 );
		assertTrue( BigInt.fromBaseString("h e l l o", 5, "0helo1234567") == 969 );
		assertTrue( BigInt.fromBaseString("haxe", "abcdefgh123xyz") == 19366 );
		// errors
		assertTrue( try { BigInt.fromBaseString("0x ff", 16); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromBaseString("1", ""); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromBaseString("1", "1"); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromBaseString("1", "1"); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromBaseString("a", "123"); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromBaseString("10", 5, "0123"); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromBaseString("10", "0 123"); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromBaseString("10", "0 12 3"); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromBaseString("10", "0  12-3"); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromBaseString("10", "0 1--2-3"); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromBaseString("10", "-0123"); false; } catch (e:Dynamic) true );
	}
	
	public function testToBaseString() {
		assertEquals( (0 : BigInt).toBaseString(2), "0" );
		assertEquals( (-1 : BigInt).toBaseString(10), "-1" );
		assertEquals( (8 : BigInt).toBaseString(8), "10" );
		assertEquals( (255 : BigInt).toBaseString(16, 2), "ff" );
		assertEquals( (255 : BigInt).toBaseString(16), "ff" );
		assertEquals( (256 : BigInt).toBaseString(16, 4, true), "0100" );
		assertEquals( (256 : BigInt).toBaseString(16, 4, false), "100" );
		assertEquals( (256 : BigInt).toBaseString(16), "100" );
		assertEquals( (16777215 : BigInt).toBaseString(16), "ffffff" );
		assertEquals( (16777215 : BigInt).toBaseString(16, 4), "00ff ffff" );
		assertEquals( (16777215 : BigInt).toBaseString(16, 4, false), "ff ffff" );
		assertEquals( (-16777215 : BigInt).toBaseString(16, 8, true), "-00ffffff" );
		assertEquals( (6873049 : BigInt).toBaseString(25, "0123456789abcdefghijklmno"), "hello" );
		assertEquals( (6873049 : BigInt).toBaseString(25, "0123456789abcdefghijklmno", 2, false), "h el lo" );
		assertEquals( (6873049 : BigInt).toBaseString(25, "O123456789abcdefghijklmno", 2), "Oh el lo" );
		assertEquals( (256 : BigInt).toBaseString(2, "Ox", 4), "OOOx OOOO OOOO" );
		assertEquals( (256 : BigInt).toBaseString(2, "Ox", 4, false), "x OOOO OOOO" );
		assertEquals( (969 : BigInt).toBaseString(5, "0helo1234567"), "hello" );
		assertEquals( (19366 : BigInt).toBaseString(14, "abcdefgh123xyz"), "haxe" );
		assertEquals( (19366 : BigInt).toBaseString("abcdefgh123xyz", 2), "ha xe" );
		// errors
		assertTrue( try { (10 : BigInt).toBaseString(""); false; } catch (e:Dynamic) true );
		assertTrue( try { (10 : BigInt).toBaseString("a"); false; } catch (e:Dynamic) true );
		assertTrue( try { (10 : BigInt).toBaseString(0, "a"); false; } catch (e:Dynamic) true );
		assertTrue( try { (10 : BigInt).toBaseString(1, "a"); false; } catch (e:Dynamic) true );
		assertTrue( try { (10 : BigInt).toBaseString(4, "abc"); false; } catch (e:Dynamic) true );
		assertTrue( try { (10 : BigInt).toBaseString("-abc"); false; } catch (e:Dynamic) true );
		assertTrue( try { (10 : BigInt).toBaseString("-ab--c"); false; } catch (e:Dynamic) true );
		assertTrue( try { (10 : BigInt).toBaseString("a bc"); false; } catch (e:Dynamic) true );
		assertTrue( try { (10 : BigInt).toBaseString("a bc  "); false; } catch (e:Dynamic) true );
	}
	
	public function testFromOctalString() {
		assertTrue( (" 0o 0" : BigInt) == 0 );
		assertTrue( (" -0o0" : BigInt) == 0 );
		assertTrue( ("0o10" : BigInt) == 8 );
		assertTrue( ("0o 24" : BigInt) == 20 );
		assertTrue( BigInt.fromOctalString(" 0 ") == 0 );
		assertTrue( BigInt.fromOctalString("10 ") == 8 );
		assertTrue( BigInt.fromOctalString("-11 ") == -9 );
		assertTrue( BigInt.fromOctalString(" 2 4 ") == 20 );
		// errors
		assertTrue( try { BigInt.fromOctalString(" 0o 24 "); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromOctalString("-0o 24 "); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromOctalString("--24"); false; } catch (e:Dynamic) true );
	}
	
	public function testFromHexString() {
		assertTrue( (" 0x 0 " : BigInt) == 0 );
		assertTrue( (" -0x 0 " : BigInt) == 0 );
		assertTrue( (" -0 x 00 " : BigInt) == 0 );
		assertTrue( (" - 0x 5" : BigInt) == -5 );
		assertTrue( (" 0x9 " : BigInt) == 9 );
		assertTrue( ("0x ff" : BigInt) == 255 );
		assertTrue( ("0x 10 00" : BigInt) == 4096 );
		assertTrue( ("0x7f FF ffFf" : BigInt) == 2147483647 );
		assertTrue( ("-0x7f FF ffFf" : BigInt) == -2147483647 );
		assertTrue( ("-0x7f" : BigInt) == -127 );
		assertTrue( ("- 0x 80" : BigInt) == -128 );
		assertTrue( ("0x ABCDEF123456789" : BigInt) == "773738363261118345" );
		assertTrue( BigInt.fromHexString(" 0 ") == 0 );
		assertTrue( BigInt.fromHexString(" 00 ") == 0 );
		assertTrue( BigInt.fromHexString(" -0 ") == 0 );
		assertTrue( BigInt.fromHexString(" - 5 ") == -5 );
		assertTrue( BigInt.fromHexString("-5 ") == -5 );
		assertTrue( BigInt.fromHexString("- 5 ") == -5 );
		assertTrue( BigInt.fromHexString("ff") == 255 );
		assertTrue( BigInt.fromHexString("-f f") == -255 );
		// errors
		assertTrue( try { BigInt.fromHexString(" 0x0 "); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromHexString(" - 0x0 "); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromHexString(" 0x ff "); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromHexString("0xff "); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromHexString("-0xff "); false; } catch (e:Dynamic) true );
	}
	
	public function testToHexString() {
		assertEquals( (0 : BigInt).toHexString(), "0" );
		assertEquals( (-1 : BigInt).toHexString(), "-1" );
		assertEquals( (16 : BigInt).toHexString(), "10" );
		assertEquals( (255 : BigInt).toHexString(2), "FF" );
		assertEquals( (255 : BigInt).toHexString(), "FF" );
		assertEquals( (255 : BigInt).toHexString(3), "0FF" );
		assertEquals( (255 : BigInt).toHexString(3, false), "FF" );
		assertEquals( (256 : BigInt).toHexString(4), "0100" );
		assertEquals( (256 : BigInt).toHexString(4, false), "100" );
		assertEquals( (256 : BigInt).toHexString(false, 4, false), "100" );
		assertEquals( (256 : BigInt).toHexString(), "100" );
		assertEquals( (16777215 : BigInt).toHexString(), "FFFFFF" );
		assertEquals( (16777215 : BigInt).toHexString(6), "FFFFFF" );
		assertEquals( (16777215 : BigInt).toHexString(5), "0000F FFFFF" );
		assertEquals( (16777215 : BigInt).toHexString(5, false), "F FFFFF" );
		assertEquals( (16777215 : BigInt).toHexString(false, 5, false), "f fffff" );
		assertEquals( (16777215 : BigInt).toHexString(4), "00FF FFFF" );
		assertEquals( (16777215 : BigInt).toHexString(false, 4, true), "00ff ffff" );
		assertEquals( (16777215 : BigInt).toHexString(4, false), "FF FFFF" );
		assertEquals( ( -16777215 : BigInt).toHexString(8), "-00FFFFFF" );
		assertEquals( ( -16777215 : BigInt).toHexString(8, false), "-FFFFFF" );
		assertEquals( ("773738363261118345" : BigInt).toHexString(), "ABCDEF123456789" );
	}
	
	public function testFromBinaryString() {
		assertTrue( ("0b 0 " : BigInt) == 0 );
		assertTrue( ("-0b0" : BigInt) == 0 );
		assertTrue( ("  -0 b 00 00  " : BigInt) == 0 );
		assertTrue( ("- 0b 00101 " : BigInt) == -5 );
		assertTrue( ("  0b 1001" : BigInt) == 9 );
		assertTrue( ("0b 11111111" : BigInt) == 255 );
		assertTrue( ("0b 1 0000 0000 0000" : BigInt) == 4096 );
		assertTrue( ("0b1111111111111111111111111111111" : BigInt) == 2147483647 );
		assertTrue( ("-0b 01111111 11111111 11111111 11111111" : BigInt) == -2147483647 );
		assertTrue( ("-0b 111 1111" : BigInt) == -127 );
		assertTrue( ("- 0b 1000 0000" : BigInt) == -128 );
		assertTrue( BigInt.fromBinaryString(" 0 ") == 0 );
		assertTrue( BigInt.fromBinaryString("00") == 0 );
		assertTrue( BigInt.fromBinaryString("-00") == 0 );
		assertTrue( BigInt.fromBinaryString("11111111 ") == 255 );
		assertTrue( BigInt.fromBinaryString(" 1111 111  1") == 255 );
		assertTrue( BigInt.fromBinaryString("-1111 1111") == -255 );
		assertTrue( BigInt.fromBinaryString("- 0 00 1000 0000") == -128 );
		// errors
		assertTrue( try { BigInt.fromBinaryString("0b"); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromBinaryString("0b101"); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromBinaryString("-0b101"); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromBinaryString("-10-1"); false; } catch (e:Dynamic) true );
		assertTrue( try { BigInt.fromBinaryString("2"); false; } catch (e:Dynamic) true );
	}
	
	public function testToBinaryString() {
		assertEquals( (0 : BigInt).toBinaryString(), "0" );
		assertEquals( (-1 : BigInt).toBinaryString(), "-1" );
		assertEquals( (16 : BigInt).toBinaryString(8), "00010000" );
		assertEquals( (127 : BigInt).toBinaryString(4), "0111 1111" );
		assertEquals( (127 : BigInt).toBinaryString(), "1111111" );
		assertEquals( (128 : BigInt).toBinaryString(), "10000000" );
		assertEquals( (16777215 : BigInt).toBinaryString(), "111111111111111111111111" );
		assertEquals( (16777215 : BigInt).toBinaryString(8), "11111111 11111111 11111111" );
		assertEquals( (-16777215 : BigInt).toBinaryString(8), "-11111111 11111111 11111111" );
	}
	
	public function testFromToBytes() {
		assertTrue(BigInt.fromBytes( ("0" : BigInt).toBytes() ) == "0");
		assertTrue(BigInt.fromBytes( ("-0" : BigInt).toBytes() ) == "0");
		assertTrue(BigInt.fromBytes( ("1" : BigInt).toBytes() ) == "1");
		assertTrue(BigInt.fromBytes( ("-1" : BigInt).toBytes() ) == "-1");
		assertTrue(BigInt.fromBytes( ("255" : BigInt).toBytes() ) == "255");
		assertTrue(BigInt.fromBytes( ("-255" : BigInt).toBytes() ) == "-255");
		assertTrue(BigInt.fromBytes( ("435783453" : BigInt).toBytes() ) == "435783453");
		assertTrue(BigInt.fromBytes( ("-435783453" : BigInt).toBytes() ) == "-435783453");
		assertTrue(BigInt.fromBytes( ("23834435537834523436234" : BigInt).toBytes() ) == "23834435537834523436234");
		assertTrue(BigInt.fromBytes( ("-23834435537834523436234" : BigInt).toBytes() ) == "-23834435537834523436234");
	}  
	
	public function testComparing() {
		assertTrue( ("-0x 0" : BigInt) == ("0x 0" : BigInt) );
		assertTrue( ("0x 10" : BigInt) == ("0x 10" : BigInt) );
		assertTrue( ("0x ff ffff" : BigInt) == ("0x ff ffff" : BigInt) );
		assertTrue( ("-0x ff ffff" : BigInt) == ("-0x ff ffff" : BigInt) );
		assertTrue( ("0x ff ffff" : BigInt) <= ("0x ff ffff" : BigInt) );
		assertTrue( ("0x ff ffff" : BigInt) <= ("0x 100 0000" : BigInt) );
		assertTrue( ("0x ff ffff" : BigInt) < ("0x 100 0000" : BigInt) );
		assertTrue( ("-0x ff ffff" : BigInt) < ("0x 100 0000" : BigInt) );
		assertTrue( ("0x ff ffff" : BigInt) >= ("0x ff ffff" : BigInt) );
		assertTrue( ("0x ff ffff" : BigInt) >= ("0x ff ffff" : BigInt) );
		assertTrue( ("0x 100 0000" : BigInt) >= ("0x ff ffff" : BigInt) );
		assertTrue( ("-0x ff ffff" : BigInt) >= ("-0x ff ffff" : BigInt) );
		assertTrue( ("0x ff ffff" : BigInt) >= ("-0x 0" : BigInt) );
		assertTrue( ("-0x ff ffff" : BigInt) > ("-0x 100 0000" : BigInt) );
		assertTrue( ("0x ff ffff" : BigInt) > ("-0x 100 0000" : BigInt) );
		assertTrue( ("0x ff ffff" : BigInt) > ("-0x ff fffe" : BigInt) );
		assertTrue( ("-0x 100 0000" : BigInt) != ("0x 100 0000" : BigInt) );
		assertTrue( ("0x 100 0001" : BigInt) != ("0x 100 0000" : BigInt) );
		
		var a:BigInt = 1;
		var	b:BigInt = 2;
		assertTrue(a < b);
		assertTrue(a <= b);
		assertTrue(a <= a);		
		assertTrue(b > a);
		assertTrue(b >= a);
		assertTrue(b >= b);
		assertTrue(b <= b);
		
		a = "-333333333333333333333";
		b = "111111111111111111111111111111111111111";		
		assertTrue(a < b);
		assertTrue(a <= b);
		assertTrue(a <= a);		
		assertTrue(b > a);
		assertTrue(b >= a);
		assertTrue(b >= b);
		assertTrue(b <= b);
		
		a = "-37037037037037037036999999999999999999962962962962962962963";
		b = "-333333333333333333333";		
		assertTrue(a < b);
		assertTrue(a <= b);
		assertTrue(a <= a);		
		assertTrue(b > a);
		assertTrue(b >= a);
		assertTrue(b >= b);
		assertTrue(b <= b);
	}
	
	public function testComparingWithInt() {
		var a:Int = 0x7fffffff;
		var	b:BigInt = "828577929858229007001829672396723";
		assertTrue(a < b);
		assertFalse(b < a);
		assertTrue(a <= b);
		assertFalse(b <= a);
		assertTrue(b > a);
		assertFalse(a > b);
		assertTrue(b >= a);
		assertFalse(a >= b);
		assertTrue(a != b);
		assertTrue(b != a);
		assertFalse(a == b);
		assertFalse(b == a);
	}
	
	public function testNegation() {
		var a:BigInt = 0;
		assertTrue(-a == a);
		
		a = 1;
		assertTrue(-a == -1);
		assertTrue(-(-a) == a);
		
		a = -1234;
		assertTrue(-a == 1234);
		assertTrue(-(-a) == a);
		
		a = "-192395858359234934684359234";
		var b:BigInt = "192395858359234934684359234";
		assertTrue(-b == a);
		assertTrue( b == -a);
	}
	
   public function testAbs() {
		assertTrue((0 : BigInt).abs() == 0);
		assertTrue(("-0" : BigInt).abs() == 0);
		assertTrue((54 : BigInt).abs() == 54);
		assertTrue((-54 : BigInt).abs() == 54);
		assertTrue(("13412564654613034984065434" : BigInt).abs() == "13412564654613034984065434");
		assertTrue(("-13412564654613034984065434" : BigInt).abs() == "13412564654613034984065434");
   }
	
	public function testAddition() {
		assertTrue( (0 : BigInt) + (0 : BigInt) == (0 : BigInt) );
		assertTrue( (1 : BigInt) + (0 : BigInt) == (1 : BigInt) );
		assertTrue( (1 : BigInt) + (1 : BigInt) == (2 : BigInt) );
		assertTrue( (-1 : BigInt) + (0 : BigInt) == (-1 : BigInt) );
		assertTrue( (0 : BigInt) + (-1 : BigInt) == (-1 : BigInt) );
		assertTrue( (1 : BigInt) + (-1 : BigInt) == (0 : BigInt) );
		assertTrue( (2 : BigInt) + (-1 : BigInt) == (1 : BigInt) );
		assertTrue( (-1 : BigInt) + (-1 : BigInt) == (-2 : BigInt) );
		assertTrue( (-1 : BigInt) + (3 : BigInt) == (2 : BigInt) );
		assertTrue( (-2 : BigInt) + (-1 : BigInt) == (-3 : BigInt) );
		assertTrue( ("0x ffff ffff" : BigInt) + (1 : BigInt) == ("0x 1 0000 0000" : BigInt) );
		assertTrue( ("0x 1 0000 0000" : BigInt) + ("0x ffff ffff" : BigInt) == ("0x 1 ffff ffff" : BigInt) );
		assertTrue( ("0x 1 0000 0000 0000 0000" : BigInt) + ("0x ffff ffff ffff ffff" : BigInt) == ("0x 1 ffff ffff ffff ffff" : BigInt) );
	}
	
	public function testAdditionWithInt() {
		assertTrue( 0 + ("-0x abcdef0123456789" : BigInt) == ("-0x abcdef0123456789" : BigInt) );
		assertTrue( 123456789 + ("-123456789" : BigInt) == (0 : BigInt) );
		assertTrue( ("0x abcdef0123456789" : BigInt) + 0 == ("0x abcdef0123456789" : BigInt) );
		assertTrue( ("0x ffff fffe" : BigInt) + 2 == ("0x 1 0000 0000" : BigInt) );
		assertTrue( 2 + ("0x ffff fffe" : BigInt) == ("0x 1 0000 0000" : BigInt) );
	}
	
	public function testAdditionNotChangeParams() {
		var a:BigInt = "0x 1 0000 0000 0000 0000";
		var b:BigInt = "0x 2 0000 0000 0000 0000";
		var c = a + b;
		assertTrue( a == ("0x 1 0000 0000 0000 0000" : BigInt) );
		assertTrue( b == ("0x 2 0000 0000 0000 0000" : BigInt) );
		assertTrue( c == ("0x 3 0000 0000 0000 0000" : BigInt) );
		c = b + a;
		assertTrue( a == ("0x 1 0000 0000 0000 0000" : BigInt) );
		assertTrue( b == ("0x 2 0000 0000 0000 0000" : BigInt) );
		assertTrue( c == ("0x 3 0000 0000 0000 0000" : BigInt) );
	}
	
	public function testIncrement() {
		var a:BigInt;
		var b:BigInt;
		var c:BigInt;
		a = "0x 1 1234 5678 abcd efff";
		b = a++;
		assertTrue( b == ("0x 1 1234 5678 abcd efff" : BigInt) );
		assertTrue( a == ("0x 1 1234 5678 abcd f000" : BigInt) );
		c = ++a;
		assertTrue( (a == c) && (c == ("0x 1 1234 5678 abcd f001" : BigInt)) );
		a = 0; assertTrue(a++ == 0); assertTrue(a == 1);
		a =-1; assertTrue(a++ ==-1); assertTrue(a == 0);
		a = 0; assertTrue(++a == 1); assertTrue(a == 1);
		a =-1; assertTrue(++a == 0); assertTrue(a == 0);
		a = 0; assertTrue(a-- == 0); assertTrue(a ==-1);
		a = 1; assertTrue(a-- == 1); assertTrue(a == 0);
		a = 0; assertTrue(--a ==-1); assertTrue(a ==-1);
		a = 1; assertTrue(--a == 0); assertTrue(a == 0);
	}
	
	public function testSubtraction() {
		assertTrue( (0 : BigInt) - (0 : BigInt) == (0 : BigInt) );
		assertTrue( (1 : BigInt) - (0 : BigInt) == (1 : BigInt) );
		assertTrue( (1 : BigInt) - (1 : BigInt) == (0 : BigInt) );
		assertTrue( (-1 : BigInt) - (0 : BigInt) == (-1 : BigInt) );
		assertTrue( (1 : BigInt) - (-1 : BigInt) == (2 : BigInt) );
		assertTrue( (-1 : BigInt) - (-1 : BigInt) == (0 : BigInt) );
		assertTrue( (-2 : BigInt) - (-1 : BigInt) == (-1 : BigInt) );
		assertTrue( (-1 : BigInt) - (-3 : BigInt) == (2 : BigInt) );
		assertTrue( ("0x ffff ffff" : BigInt) - (1 : BigInt) == ("0x ffff fffe" : BigInt) );
		assertTrue( ("0x 1 0000 0000" : BigInt) - ("0x ffff ffff" : BigInt) == ( 1 : BigInt) );
		assertTrue( ("0x ffff ffff" : BigInt) - ("0x 1 0000 0000" : BigInt) == ( -1 : BigInt) );
		assertTrue( ("0x ffff ffff" : BigInt) - ("0x 2 0000 0000" : BigInt) == ( "-0x 1 0000 0001" : BigInt) );
		assertTrue( ("-0x 1 0000 0000" : BigInt) - ("0x ffff ffff" : BigInt) == ( "-0x 1 ffff ffff" : BigInt) );
		assertTrue( ("-0x 1 0000 0000" : BigInt) - ("0x 0" : BigInt) == ( "-0x 1 0000 0000" : BigInt) );
		assertTrue( ("0x 1 0000 0000 0000 0000" : BigInt) - ("0x ffff ffff ffff ffff" : BigInt) == 1 );
		assertTrue( ("0x ffff ffff ffff ffff" : BigInt) - ("0x 1 0000 0000 0000 0000" : BigInt) == -1 );
		assertTrue( ("0x ffff ffff ffff ffff" : BigInt) - ("0x 1 ffff ffff ffff ffff" : BigInt) == ("-0x 1 0000 0000 0000 0000" : BigInt) );
	}
	
	public function testSubtractionWithInt() {
		assertTrue( 0 - ("-0x abcdef0123456789" : BigInt) == ("0x abcdef0123456789" : BigInt) );
		assertTrue( 123456789 - ("123456789" : BigInt) == (0 : BigInt) );
		assertTrue( ("0x abcdef0123456789" : BigInt) - 0 == ("0x abcdef0123456789" : BigInt) );
		assertTrue( ("0x 1 0000 0000" : BigInt) - 2 == ("0x ffff fffe" : BigInt) );
		assertTrue( 2 - ("0x 1 0000 0000" : BigInt) == ("-0x ffff fffe" : BigInt) );
	}
	
	public function testSubtractionNotChangeParams() {
		var a:BigInt = "0x 3 0000 0000 0000 0000";
		var b:BigInt = "0x 2 0000 0000 0000 0000";
		var c = a - b;
		assertTrue( a == ("0x 3 0000 0000 0000 0000" : BigInt) );
		assertTrue( b == ("0x 2 0000 0000 0000 0000" : BigInt) );
		assertTrue( c == ("0x 1 0000 0000 0000 0000" : BigInt) );
		c = b - a;
		assertTrue( a == ("0x 3 0000 0000 0000 0000" : BigInt) );
		assertTrue( b == ("0x 2 0000 0000 0000 0000" : BigInt) );
		assertTrue( c == ("-0x 1 0000 0000 0000 0000" : BigInt) );
	}
	
	public function testDecrement() {
		var a:BigInt = "0x 1 1234 5678 abcd efff";
		var b:BigInt = a--;
		assertTrue( b == ("0x 1 1234 5678 abcd efff" : BigInt) );
		assertTrue( a == ("0x 1 1234 5678 abcd effe" : BigInt) );
		var c:BigInt = --a;
		assertTrue( (a == c) && (c == ("0x 1 1234 5678 abcd effd" : BigInt)) );
	}
	
	public function testMultiplication() {
		assertEquals( ( (0 : BigInt) * (0 : BigInt) ).toInt(), 0 );
		assertEquals( ( (1 : BigInt) * (0 : BigInt) ).toInt(), 0 );
		assertEquals( ( (0 : BigInt) * (1 : BigInt) ).toInt(), 0 );
		assertEquals( ( (1 : BigInt) * (1 : BigInt) ).toInt(), 1 );
		assertEquals( ( (2 : BigInt) * (2 : BigInt) ).toInt(), 4 );
		assertEquals( ( (6 : BigInt) * (7 : BigInt) ).toInt(), 42 );
		assertEquals( ( (12 : BigInt) * (-9 : BigInt) ).toInt(), -108 );
		assertEquals( ( (-8 : BigInt) * (111 : BigInt) ).toInt(), -888 );
		assertEquals( ( ( -14 : BigInt) * ( -23 : BigInt) ).toInt(), 322 );
		
		var a:BigInt;
		var b:BigInt;
		var c:BigInt;
		
		a = "0x1FFFFFF";
		b = "0x1FFFFFF";
		c = "0x3FFFFFC000001";		
		assertEquals( ( a * b ).toString(), c.toString() );
		
		a = "0x1FFFFFF";
		b = "0x1FFFFFF";
		c = "0x3FFFFFC000001";		
		assertEquals( ( a * b ).toString(), c.toString() );
		
		a = "2 000 000 000 000 000 000 000 000 000 000 000 000";
		b = "4 000 000 000 000 000 000 000 000 000 000 000 000";
		c = "8 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000";
		assertTrue( a * b == c );
		
		a = "0x123456789abcdef112233445566778899aabbccddeeff987654321fedcba987654321";
		b = "0x73b5c003fe76cc41a904bcd6f325e56cd974bb1a8e653e0ff76cf3b1936cde63110af";
		c = "0x83a6f80da5817994858b95127c284366b38bc087d0f522993e797cb39a6b7a70ec441e6fc8853782d1c4fe22ecf3f93fd26f0eaa57f9c785f5a44581cecd96d7861bbf38f";
		assertTrue( a * b == c );
		assertTrue( a * b == (a-1) * b + (b * 1) );
		assertTrue( a * b == (a-2) * b + (b * 2) );
		assertTrue( a * b == (a-3) * b + (b * 3) );
		var d:BigInt = 0;
		for (i in 0...40000) d += c;
		for (i in 40000...40003) {
			assertTrue( c * (i:BigInt) == d);
			d += c;
		}
		
		a = 12347; b = 0;
		assertTrue(a*b == b);
		assertTrue(b*a == b);
		
		a = -99999; b = 1;
		assertTrue(a*b == a);
		assertTrue(b*a == a);
        
        // Multiplication by -1 bug
		b = -1;
		assertTrue(b * a == -a);
		assertTrue(a * b == -a);
		assertTrue(a / b == -a);
		
		a = 1235; b = 44; c = 54340;
		assertTrue(a*b == c);
		assertTrue(b*a == c);
		
		a = -11; b = -9; c = 99;
		assertTrue(a*b == c);
		
		a = 55; b = 200395; c = 11021725;
		assertTrue(a*b == c);
		
		a = "111111111111111111111111111111111111111";
		b = "-333333333333333333333";
		c = "-37037037037037037036999999999999999999962962962962962962963";
		assertTrue(a * b == c);
		
		// check optimization bug
		a = "10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000195193276309135075023284912102116616768613765187463511927839869094134045055764247";
		b = "10000000000";
		c = "100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001951932763091350750232849121021166167686137651874635119278398690941340450557642470000000000";
		assertTrue(a * b == c);

		assertEquals( (("1761804960632708497166197429":BigInt) * ("170141183460469231731687303715884105709":BigInt)).toString(), "299755581028574428885627854637518938878751711898852594203800022161" );
	}
	
	public function testMultiplicationWithInt() {
		var i:Int = 0x7FFFFFFF;
		var b:BigInt = "1 000 000 000 000 000";
		var c:BigInt = "2147483647 000 000 000 000 000";
		
		assertTrue( i * b == c );
		assertTrue( b * i == c );
		assertTrue( -10 * b == ("-1 000 000 000 000 000 0":BigInt) );
		assertTrue( b * -10 == ("-1 000 000 000 000 000 0":BigInt) );
	}
	
	public function testMultiplicationNotChangeParams() {
		var a:BigInt = "111111111111111111111111111111111111111";
		var b:BigInt = "333333333333333333333";
		var c = a * b;
		assertTrue( a == ("111111111111111111111111111111111111111" : BigInt) );
		assertTrue( b == ("333333333333333333333" : BigInt) );
		assertTrue( c == ("37037037037037037036999999999999999999962962962962962962963" : BigInt) );
		c = b * a;
		assertTrue( a == ("111111111111111111111111111111111111111" : BigInt) );
		assertTrue( b == ("333333333333333333333" : BigInt) );
		assertTrue( c == ("37037037037037037036999999999999999999962962962962962962963" : BigInt) );
	}
	
	public function testModulo() {
		assertEquals( ( (0 : BigInt) % (10 : BigInt) ).toInt(), 0 );
		assertEquals( ( (0 : BigInt) % (-10 : BigInt) ).toInt(), 0 );
		
		assertEquals( ( (1 : BigInt) % ( 10 : BigInt) ).toInt(), 1 );
		assertEquals( ( (1 : BigInt) % (-10 : BigInt) ).toInt(), 1 );
		assertEquals( ( (-1 : BigInt) % ( 10 : BigInt) ).toInt(), -1 );
		assertEquals( ( (-1 : BigInt) % (-10 : BigInt) ).toInt(), -1 );
		
		assertEquals( ( (11 : BigInt) % ( 10 : BigInt) ).toInt(), 1 );
		assertEquals( ( (11 : BigInt) % (-10 : BigInt) ).toInt(), 1 );
		assertEquals( ( (-11 : BigInt) % ( 10 : BigInt) ).toInt(), -1 );
		assertEquals( ( (-11 : BigInt) % (-10 : BigInt) ).toInt(), -1 );
		
		assertEquals( ( ( "234566742345367567353452" : BigInt) % (1 : BigInt) ).toInt(), 0 );
		assertEquals( ( ( "2938289887273578834588723405828340070292347195862712329756482349" : BigInt) % (2 : BigInt) ).toInt(), 1 );
		assertEquals( ( ( "2938289887273578834588723405828340070292347195862712329756482349" : BigInt) % ( "2938289887273578834588723405828340070292347195862712329756482300" : BigInt) ).toInt(), 49 );
		assertEquals( ( ( "2938289887273578834588723405828340070292347195862712329756482349" : BigInt) % ("-2938289887273578834588723405828340070292347195862712329756482300" : BigInt) ).toInt(), 49 );
		assertEquals( ( ("-2938289887273578834588723405828340070292347195862712329756482349" : BigInt) % ( "2938289887273578834588723405828340070292347195862712329756482300" : BigInt) ).toInt(),-49 );
		assertEquals( ( ("-2938289887273578834588723405828340070292347195862712329756482349" : BigInt) % ("-2938289887273578834588723405828340070292347195862712329756482300" : BigInt) ).toInt(),-49 );
		
		assertEquals( (BigInt.fromHexString('D5D4921855F54CC4D0EC0E0CBEF8B582A11E959D54243145088DEF36C75886EEBAE84160B64E011F6B9AD301F1D3466E247FC2ACF7B5DF1798D72918C459CF0') % BigInt.fromHexString('7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFED')).toString(), "46827403850823179245072216630277197565144205554125654976674165829533817101731" );
	}
	
	public function testModuloWithInt() {
		var b:BigInt = "1 000 000 000 000 000 000 000 123";		
		var i:Int = 1000000;
		assertTrue( b % i == 123 );
		assertTrue( i % b == (1000000:BigInt) );
	}
	
	public function testDivision() {
		// zero divided by
		assertTrue((0 : BigInt) / 1 == 0);
		assertTrue((-0 : BigInt) / 1 == 0);
		assertTrue((-0 : BigInt) / "1234567890987654321" == 0);
		assertTrue((0 : BigInt) / "-1234567890987654321" == 0);
		assertEquals( ( (0 : BigInt) / (10 : BigInt) ).toInt(), 0 );
		
		// division by 1
		assertTrue((1 : BigInt) / 1 == 1);
		assertTrue((-1 : BigInt) / 1 == -1);
		assertTrue((1 : BigInt) / -1 == -1);
		assertTrue((153 : BigInt) / 1 == 153);
		assertTrue((-153 : BigInt) / 1 == -153);
		assertTrue(("9844190321790980841789" : BigInt) / 1 == "9844190321790980841789");
		assertTrue(("-9844190321790980841789" : BigInt) / 1 == "-9844190321790980841789");
		
		// division by itself
		assertTrue((5 : BigInt) / 5 == 1);
		assertTrue((-5 : BigInt) / -5 == 1);
		assertTrue(("20194965098495006574" : BigInt) / "20194965098495006574" == 1);
		assertTrue(("-20194965098495006574" : BigInt) / "-20194965098495006574" == 1);
		
		var result = BigInt.divMod( 9, 4 );
		assertEquals( result.quotient.toInt(), 2 );
		assertEquals( result.remainder.toInt(), 1 );
		
		result = BigInt.divMod( -9, 4 );
		assertEquals( result.quotient.toInt(), -2 );
		assertEquals( result.remainder.toInt(), -1 );
		
		result = BigInt.divMod( 9, -4 );
		assertEquals( result.quotient.toInt(), -2 );
		assertEquals( result.remainder.toInt(), 1 );
		
		result = BigInt.divMod( -9, -4 );
		assertEquals( result.quotient.toInt(), 2 );
		assertEquals( result.remainder.toInt(), -1 );
		
		// divModLittle
		
		result = BigInt.divMod( "0x ff ffff ffff", "0x 33" );
		assertEquals( result.quotient.toHexString(), "505050505");
		assertEquals( result.remainder.toInt(), 0 );
		
		result = BigInt.divMod( "0x 100 0000 0000", "0x 33" );
		assertEquals( result.quotient.toHexString(), "505050505");
		assertEquals( result.remainder.toInt(), 1 );
		
		// divModLong
		var divident:Array<BigInt>= [-9,-9, 9, 9, "-0xffffffffff", "-0xffffffffff", "0xffffffffff", "0xffffffffff" ];
		var divisor:Array<BigInt> = [-4, 4,-4, 4,          -0x34 ,           0x34 ,         -0x34 ,          0x34  ];
		
		divident = divident.concat( [-4, 4,-4, 4,          -0x34 ,           0x34 ,         -0x34 ,          0x34  ] );
		divisor  = divisor.concat ( [-9,-9, 9, 9, "-0xffffffffff", "-0xffffffffff", "0xffffffffff", "0xffffffffff" ] );
		
		divident = divident.concat( ["-0x 123456789", " 0x 123456789", "-0x 123456789", "0x 123456789" ] );
		divisor  = divisor.concat ( ["-0xffffffffff", "-0xffffffffff", " 0xffffffffff", "0xffffffffff" ] );
		
		divident = divident.concat( ["-0xffffffffff", "-0xffffffffff", " 0xffffffffff", "0xffffffffff" ] );
		divisor  = divisor.concat ( ["-0x 123456789", " 0x 123456789", "-0x 123456789", "0x 123456789" ] );
		
		divident = divident.concat( ["0x 15fe4f603a4dfabffcf78f709fbdcebf04", "0x a5f44f603a4abfcbf738f7089fbdcebf0" ] );
		divisor  = divisor.concat ( ["0x  12cf34ae567d85aaf803bc9e35db7aa08", "0x                     37f70cbbcf604" ] );
		
		divident = divident.concat( ["0x  12cf34ae567d85aaf803bc9e35db7aa08", "0x a5f44f603a4abfcbf738f7089fbdcebf0" ] );
		divisor  = divisor.concat ( ["0x 15fe4f603a4dfabffcf78f709fbdcebf04", "0x                            3f5fb4" ] );
		
		for (i in 0...divident.length) {
			var a = divident[i];
			var b = divisor[i];
			var result = BigInt.divMod(a, b);
			assertTrue( result.quotient * b + result.remainder == a );
		}		
	}
	
	public function testDivisionWithInt() {
		var b:BigInt = "2147483647 000 000 000 000 000";
		var i:Int = 0x7FFFFFFF;
		var c:BigInt = "1 000 000 000 000 000";
		assertTrue( b / i == c );
		assertTrue( i / b == (0:BigInt) );
		assertTrue( b / -i == -c );
		assertTrue( -b / i == -c );
		assertTrue( -b / -i == c );
		b = "837403102315389003148876";
		/*
		for (j in 0...3) {
			b += j;
			for (i in 1...0x8000) { var result = BigInt.divModLittle(b,i); assertTrue( result.quotient*i + result.remainder == b ); }
		}
		*/
	}
	
	public function testDivisionNotChangeParams() {
		var a:BigInt = "100000000000000000000000000000000000000000000";
		var b:BigInt = "300000000000000000000000000000000000000000";
		var c = a / b;
		assertTrue( a == ("100000000000000000000000000000000000000000000" : BigInt) );
		assertTrue( b == ("300000000000000000000000000000000000000000" : BigInt) );
		assertTrue( c == ("333" : BigInt) );
		c = b / a;
		assertTrue( a == ("100000000000000000000000000000000000000000000" : BigInt) );
		assertTrue( b == ("300000000000000000000000000000000000000000" : BigInt) );
		assertTrue( c == ("0" : BigInt) );		
		
		b = "-300000000000000000000000000000000000000000";
		c = a / b;
		assertTrue( a == ("100000000000000000000000000000000000000000000" : BigInt) );
		assertTrue( b == ("-300000000000000000000000000000000000000000" : BigInt) );
		assertTrue( c == ("-333" : BigInt) );
		
		a = "-100000000000000000000000000000000000000000000";
		c = a / b;
		assertTrue( a == ("-100000000000000000000000000000000000000000000" : BigInt) );
		assertTrue( b == ("-300000000000000000000000000000000000000000" : BigInt) );
		assertTrue( c == ("333" : BigInt) );
	}
	
	public function testPow() {
		assertEquals( ( (0 : BigInt).pow("9844190321790980841789") ).toInt(), 0 );
		assertEquals( ( (1 : BigInt).pow("9844190321790980841789") ).toInt(), 1 );
		assertTrue(("9844190321790980841789" : BigInt).pow(0) == 1);
		assertTrue(("9844190321790980841789" : BigInt).pow(1) == "9844190321790980841789");
		assertTrue((252 : BigInt).pow(124) == "5938367311357894783707160053746995174420310205828475852414076013938629891503128283948631773358868260990930862750953888472307867713712589898179153244476868510006056477315240397220674879224085413293137093058033640525738900314887652830363105200755814422450693335653967468344026614374568850656084361216");
		assertTrue((-252 : BigInt).pow(14) == "4164928698882469942515671324688384");
		assertTrue((-252 : BigInt).pow(13) == "-16527494836835198184585997320192");
	}
	
	public function testPowMod() {
		assertEquals( ( (0 : BigInt).powMod("9844190321790980841789","20194965098495006574") ).toInt(), 0 );
		assertEquals( ( (1 : BigInt).powMod("9844190321790980841789","20194965098495006574") ).toInt(), 1 );
		assertEquals( ( ( 4 : BigInt).powMod(13,  497) ).toInt(),  445 );
		assertEquals( ( ( 4 : BigInt).powMod(13, -497) ).toInt(),  445 );
		assertEquals( ( (-4 : BigInt).powMod(13,  497) ).toInt(), -445 );
		assertEquals( ( (-4 : BigInt).powMod(13, -497) ).toInt(), -445 );
		assertTrue(("9844190321790980841789" : BigInt).powMod(1,"20194965098495006574") == "9242318823912640251");
		assertTrue(("4139543763576876256978864589462346353452" : BigInt).powMod("1322448978334799562386783579042534564354","19096727818566719527493245743456") == "17450867125893875188144890320704");
		assertTrue(("-4139543763576876256978864589462346353452" : BigInt).powMod("1322448978334799562386783579042534564354","19096727818566719527493245743456") == "17450867125893875188144890320704");
		assertTrue(("163353452" : BigInt).powMod("37904",1) == 0);
		assertTrue(("163353452" : BigInt).powMod(0, 1) == 0);
		assertTrue(("163353452" : BigInt).powMod(0, 14) == 1);
	}
	
	public function testCanHandleLargeNumbers() {
		var tenFactorial:BigInt = "3628800";
		var hundredFactorial:BigInt = "93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000";
		var threeToTenThousand:BigInt = "1631350185342625874303256729181154716812132453582537993934820326191825730814319078748015563084784830967325204522323579543340558299917720385238147914536811250"
			+"14531923551662243910254236288435566865596596450120141774482755299903732744254464257512355373418673876078136199372256168728620165048055931740599095204616685006631189269115717734522558"
			+"50626968526251879139867085080472539640933730243410152186914328917354576854457274195562218013337745628502470673059426999114202540773175988199842487276183685299388927825296786440252999"
			+"44478569418367532352170443219578580627012338838293177019899084130086150699610894478206501516341034489494580933768915680768667346256303816479219066534012434413398076320559436475496345"
			+"15640723405026063777905851141238149190016371770344573850199390602329251944711142358929785653224156283441421848428920834662278757605012760098015307030375258391578938757411924977053004"
			+"69691062454369926795975456340236777734354667139072601574969834312769653557184396147587071260443947944862235744459711204473062937764153770030210332183635531818173456618022745975055313"
			+"21259851442958754554729653460959719483603654687049177192762521435295750345494840363582234572877488517580950015845183738941379809532971199309210141742840677432612645000546788873654625"
			+"49486586024844945359388886565427469774243683853354960831649213186019349770250957803701043079802763568573503492058660783718060655423935361016734020179809515989469806643303915058458036"
			+"74248348878071010412918667335823849899623486215050304052577789848512410263834811719236949311423411823585316405085306164936671137456985394285677324771775046050970865520893596151687017"
			+"15385575519734819965907019295477130834762711105247113447632598636283858595955220964538208905518287185486674463373753321752488011840178759509406085571701014408713649553241854424148943"
			+"70800747161584048959141364518020324467079610587576333456916967432938696237454108700518515906728593470612125734465720450884654606168260825797316860045852182843334523961577300363063794"
			+"21822435818001505905203918209206969662326706952623512427380240468784114535101496733983401240219840048956733689309620321613793757156727562461651933397540266795963865921590913322060572"
			+"67334984925330339787424238196077533718273003778369870874878173841974769888032160118631050633286970493130307683944479096833930630127337101408724806094685179369797311443270675928854607"
			+"76228310025268005548496968677102809459466036695937973546421366222311926950273212295119129529403208797631231517605559594969611631414556882788429495872883991002736918800187741475688926"
			+"50186152065335219113072582417699616901995530249937735219099786758954892534365835235843156112799728164123461219817343904782402517111603206575330527850752564642995318064985900815557979"
			+"94588593112435130325281125525429579708228194665879870597907749246984964418316658595084495316472689614616829780817839847045156132052618054231084074484310746936895970772683660847181706"
			+"05987717301707554464734407740313712274376510484216062247575270859585159472731510274006629481611112847778281035314994889136728007831678880511771554272851038617366580694047976959007588"
			+"20465238673970882660162285107599221418743657006872537842677883708807515850397691812433880561772652364847297019508025848964833883225165668986935081274596293983121864046277268590401580"
			+"20905998850051126247016715049526190813668869386132408155904633628896303709031203352240072236088249492818280907540691431995704492750442079727811783767743144697908575643299075358258810"
			+"24402406110390845164010899488684333537484441046397340745191650676329414193479856244355673420728159107544841238129174873129382806704032281888130039783840813322424846465714175744048529"
			+"62675165616101527367425654869508712001788393846171780457455963045764943565964887518396481296159902471996735508854292964536796779404377230965723361625182030798297734785854606060323419"
			+"09164671113867849092884010744992345683476376311422600077031693124366669942569482818115504884316138083206784548056975845775109064099600724201825540062727690818808260179552016705470132"
			+"78023669897470828354811055438784468898962306960918816435474761549985740159073960594786849785741804867989184386431646185413516892583790423264876694797333847129967542517038080378286365"
			+"99654447727795924596382283226723503386540591321268603222892807562509801015765174359627788357881606366119032951829868274617539946921221330284257027058653162292482686679275266764009881"
			+"98559064853454493922429668979119535578320596849242263627765673533848829910423806028920939065446731629159121971286605266134702685526128938123688106306821924906476708649518417681662907"
			+"71036671315050649641909104501965021789724773618813006086885937825097937814571703968974969088618930346348957151171146015146543813471390923458334722264936569309960450163558081629849652"
			+"03661519182202145414866559662218796964329217241498105206552200001";
		
		function factorial(n:BigInt):BigInt {
			if (n == 0 || n == 1) {
				return 1;
			}
			return factorial(n-1) * n;
		}
		
		assertTrue(factorial(10) == tenFactorial);
		assertTrue(factorial(100) == hundredFactorial);
		
		var a:BigInt = 1;
		for (i in 0...10000) a = a * 3;
		assertTrue(a == threeToTenThousand);
	}
	
	public function testCarriesOverCorrectly() {
		assertTrue(("9007199254740991" : BigInt) + 1 == "9007199254740992");
		assertTrue(("-9007199254740983" : BigInt) + "-9999999999999998" == "-19007199254740981");
		assertTrue(("100000000000000000000000000000000000" : BigInt) - "999999999999999999" == "99999999999999999000000000000000001");
		assertTrue(("50000005000000" : BigInt) * "10000001" == "500000100000005000000");
	}
	
	public function testMisc() {
		var i = 5;
		assertTrue(("10" : BigInt) * i + 3 == "53");
		assertTrue(("10" : BigInt) + i * 3 == "25");
		assertTrue( i * 3 + ("10" : BigInt) == "25");
		assertTrue( 3 * ("10" : BigInt) + i == "35");
		assertTrue( 5 + 3 * ("10" : BigInt) + i == "40");
		assertTrue( 3 * ("10" : BigInt) + i * 2 == "40");
		assertTrue( 3 * ("10" : BigInt) + (i : BigInt) * 5 == "55");
		assertEquals( ((2 + 2 * ("30000000000000000000000000000000000003" : BigInt) + 1)/3).toString(), "20000000000000000000000000000000000003");
		
		assertTrue(("-10000000000000000" : BigInt) + "0" == "-10000000000000000");
		assertTrue(("0" : BigInt) + "10000000000000000" == "10000000000000000");
		assertTrue((9999999 : BigInt) + 1 == 10000000);
		assertTrue((10000000 : BigInt) - 1 == 9999999);
		assertTrue(("-1000000000000000000000000000000000001" : BigInt) + "1000000000000000000000000000000000000" == -1);
		assertTrue(("100000000000000000002222222222222222222" : BigInt) - "100000000000000000001111111111111111111" == "1111111111111111111");
		assertTrue(("1" : BigInt) + "0" == "1");
		assertTrue(("10" : BigInt) + "10000000000000000" == "10000000000000010");
		assertTrue(("10000000000000000" : BigInt) + "10" == "10000000000000010");
		assertTrue(("10000000000000000" : BigInt) + "10000000000000000" == "20000000000000000");
		
		var a:BigInt = "154476802108746166441951315019919837485664325669565431700026634898253202035277999";
		var b:BigInt = "36875131794129999827197811565225474825492979968971970996283137471637224634055579";
		var c:BigInt = "4373612677928697257861252602371390152816537558161613618621437993378423467772036";
    
		//      a/(b+c) + b/(a+c) + c/(a+b) == 4
		// what is same as:
		assertTrue( (a*(a+c)*(a+b) + b*(b+c)*(a+b) + c*(b+c)*(a+c) ) / ( (b+c)*(a+c)*(a+b) ) == 4  ); // \o/
	
	}
	
	public function testShiftingLeftAndRight() {
		assertTrue((1024 : BigInt) << 100 == "1298074214633706907132624082305024");
		assertTrue(("2596148429267413814265248164610049" : BigInt) >> 100 == 2048);
		assertTrue(("8589934592" : BigInt) << 50 == "9671406556917033397649408");
		assertTrue(("38685626227668133590597632" : BigInt) >> 50 == "34359738368");
	}
	
	public function testShiftingCompatibilityToInt() {
		// i <= -4097 and >= 4096 gives error here with -20 shift (will be neg-signed for 32bitInt)! 
		for (i in -4096...4096) {
			for (j in -20...21) {
				// trace('$i, $j');
				assertEquals(((i:BigInt) >> j).toString() , '${i >> j}');
			}
		}
		
		// i = -2049 and 2048 gives error here with 20 shift (will be neg-signed for 32bitInt)! 
		for (i in -2048...2048) {
			// for left shifting its is undefined behavior for negative shifting and will throw error into that case
			for (j in 0...21) {
				assertEquals(((i:BigInt) << j).toString() , '${i << j}');
			}
		}
		
		// for right signles-shifting its is undefined behavior for negative values and will throw error into that case
		// i = 4096 gives error here with -20 shift (not work with two-complementary !)!
		for (i in 0...4096) {
			for (j in -20...21) {
				assertEquals(((i:BigInt) >>> j).toString() , '${i >>> j}');
			}
		}
	}
	
	public function testBitwiseOperations() {
		for (i in -256...257) assertEquals((~(i:BigInt)).toString() , '${~i}');
		for (i in -0x7ffffffe...-0x7fffff00) assertEquals((~(i:BigInt)).toString() , '${~i}');
		for (i in 0x7fffff00...0x7fffffff) assertEquals((~(i:BigInt)).toString() , '${~i}');
		
		assertTrue(("0b 00000000" : BigInt) & ("0b 00000000" : BigInt) == 0);
		assertTrue(("0b 00000000" : BigInt) & ("0b 01010111" : BigInt) == 0);
		assertTrue(("0b 11010110" : BigInt) & ("0b 00000000" : BigInt) == 0);
		assertTrue(("0b 11100101101111100010010100011001110010110100111001001111011100011100011101001" : BigInt) & ("0b 1101" : BigInt) == ("0b 1001" : BigInt));
		assertTrue(("0b 1101" : BigInt) & ("0b 11100101101111100010010100011001110010110100111001001111011100011100011101001" : BigInt) == ("0b 1001" : BigInt));
		assertTrue((("0b 1101" : BigInt) & ("0b 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111100 11100101 11001110 10111001 11010010" : BigInt)).isZero);		
		
		assertTrue(("0b 00000000" : BigInt) | ("0b 00000000" : BigInt) == ("0b 00000000" : BigInt));
		assertTrue(("0b 00000000" : BigInt) | ("0b 01010111" : BigInt) == ("0b 01010111" : BigInt));
		assertTrue(("0b 11010110" : BigInt) | ("0b 00000000" : BigInt) == ("0b 11010110" : BigInt));
		assertTrue(("0b 11100101101111100010010100011001110010110100111001001111011100011100011101001" : BigInt) | ("0b 1101" : BigInt) == ("0b 11100101101111100010010100011001110010110100111001001111011100011100011101101" : BigInt));
		assertTrue(("0b 1101" : BigInt) | ("0b 11100101101111100010010100011001110010110100111001001111011100011100011101001" : BigInt) == ("0b 11100101101111100010010100011001110010110100111001001111011100011100011101101" : BigInt));
		
		assertTrue(("0b 00000000" : BigInt) ^ ("0b 00000000" : BigInt) == ("0b 00000000" : BigInt));
		assertTrue(("0b 00000000" : BigInt) ^ ("0b 11010110" : BigInt) == ("0b 11010110" : BigInt));
		assertTrue(("0b 01010110" : BigInt) ^ ("0b 00000000" : BigInt) == ("0b 01010110" : BigInt));
		assertTrue(("0b 11010110" : BigInt) ^ ("0b 01010101" : BigInt) == ("0b 10000011" : BigInt));
		assertTrue(("0b 111111110011100101110011101011100111010111" : BigInt) ^ ("0b 101" : BigInt) == ("0b 111111110011100101110011101011100111010010" : BigInt));
		assertTrue(("0b 1001" : BigInt) ^ ("0b 11001011100011110110101110101000100111001110011111101111101111" : BigInt) == ("0b 11001011100011110110101110101000100111001110011111101111100110" : BigInt));
		assertTrue((("0b 11001011100011110110101110101000100111001110011111101111101111" : BigInt) ^ ("0b 11001011100011110110101110101000100111001110011111101111101111" : BigInt)).isZero);
		assertTrue((("0b 11001011100011110110101110101000100111001110011111101111101110" : BigInt) ^ ("0b 11001011100011110110101110101000100111001110011111101111101111" : BigInt)).chunksLength == 1);
	}
   
	public function testBitwiseWithInts() {
		var i:Int = 902345074;
		assertTrue(("435783453" : BigInt) & i == ("298352912": BigInt));
		assertTrue(i & ("435783453" : BigInt) == ("298352912": BigInt));
		assertTrue(("435783453" : BigInt) | i == ("1039775615": BigInt));
		assertTrue(i | ("435783453" : BigInt) == ("1039775615": BigInt));
		assertTrue(("435783453" : BigInt) ^ i == ("741422703": BigInt));
		assertTrue(i ^ ("435783453" : BigInt) == ("741422703": BigInt));
	}
   
}
