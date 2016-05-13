import pex.PexXmlLoader;

class Test {
	public static function main() {
		var em = pex.PexXmlLoader.loadCompileTime( "test/particle.pex" );
		em.start( 1 );
		em.update( 0.5 );
	}
}
