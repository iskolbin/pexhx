import pex.PexXmlLoader;

class Test {
	public static function main() {
//		var em = pex.PexXmlLoader.load( Xml.parse(sys.io.File.getContent( "test/particle.pex" )));
	//	trace( em );
		var em = new pex.PexEmitter();
	}

	public static function expose() {
		//return pex.PexXmlLoader.load( Xml.parse(sys.io.File.getContent( "test/particle.pex" )));
	}
}
