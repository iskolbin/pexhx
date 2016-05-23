import pex.PexIo;
import pex.PexEmitter;
import pex.backend.PexHtml5CanvasRenderer;
import js.Browser;
import js.html.ImageElement;
import js.html.CanvasElement;

class Test {
	static var particleEmitter: PexEmitter;
	static var particleRenderer: PexHtml5CanvasRenderer;
	static var particleImage: ImageElement;
	static var canvas: CanvasElement;

	public static function main() {
		particleEmitter = PexIo.loadFromXmlCompileTime( "test/particle.pex" );
		
		canvas = Browser.document.createCanvasElement();
		canvas.width = 640;
		canvas.height = 480;
		canvas.style.backgroundColor = "black";
			
		Browser.document.body.appendChild( canvas );
		
		particleRenderer = new PexHtml5CanvasRenderer( canvas );
		particleImage = cast Browser.document.getElementById("particleImage");
		particleEmitter.start( Math.POSITIVE_INFINITY );
		Browser.window.requestAnimationFrame( update );
	
		trace( PexIo.encodeXml( particleEmitter ));
	}

	static var start = 0.0;

	public static function update( timestamp: Float ) {
		if ( start == 0.0 ) {
			start = timestamp;
		} else {
			particleEmitter.update( 0.001*(timestamp - start));
			start = timestamp;
		}
		canvas.getContext2d().clearRect( 0, 0, canvas.width, canvas.height );
		particleRenderer.render( particleEmitter, particleImage );
		
		Browser.window.requestAnimationFrame( update );
	}
}
