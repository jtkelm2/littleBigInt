package;

class Main {

    public static function main() {

		var a:BigInt = 4;
		var b:BigInt = 5;
		
		var c:Int = a + b;
		trace(c);
		
/* 		var b:BigInt;
		var n:BigInt;
		
		a = BigInt.fromInt(2);
		b = BigInt.fromInt(8);
		
		//n = BigInt.fromString("ff", 16, "0123456789abcdef");

		n = a.modPow(b, BigInt.fromInt(256) );
	
		var n:BigInt;

  		n = BigInt.fromStringWithBase(
			"00c037c37588b4329887e61c2da332"+
			"4b1ba4b81a63f9748fed2d8a410c2f"+
			"c21b1232f0d3bfa024276cfd884481"+
			"97aae486a63bfca7b8bf7754dfb327"+
			"c7201f6fd17fd7fd74158bd31ce772"+
			"c9f5f8ab584548a99a759b5a2c0532"+
			"162b7b6218e8f142bce2c30d778468"+
			"9a483e095e701618437913a8c39c3d"+
			"d0d4ca3c500b885fe3",
			16);

		//n = BigInt.fromStringWithBase("0102",16);
		//n = n.modPow( BigInt.fromInt(23), BigInt.fromInt(0xffff) );
		//n = BigInt.fromInt(2).modPow( BigInt.fromStringWithBase("3cf286a6de3b0a166c3375ac2fb009a87d9fcc23",16), n );
		
		n = BigInt.fromInt(0x10000) * BigInt.fromInt(0x10000);
		n = n / BigInt.fromInt(0x1000);
		//trace(n.toString());
		trace(n.toStringWithBase(16));
		trace( ((9999999 : BigInt) + 1 == 10000000) );
		trace( ((10000000 : BigInt) - 1 == 9999999) );
 */ 		
        trace("---------------------------------------");
    }

}