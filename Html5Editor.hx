import pex.PexIo;
import pex.PexEmitter;
import pex.backend.PexHtml5CanvasRenderer;
import js.Browser;
import js.html.ImageElement;
import js.html.CanvasElement;

class Html5Editor {
	static var particleEmitter: PexEmitter;
	static var particleRenderer: PexHtml5CanvasRenderer;
	static var particleImage: ImageElement;
	static var canvas: CanvasElement;
	
	public static function main() {
		var body = Browser.document.getElementsByTagName( "body" )[0];
		var div = Browser.document.createElement( "div" );
	
		div.innerHTML = EditorUi.collectHtml( EditorUi.SPECS, EditorUi.PARTS );
		
		body.appendChild( div );

		particleEmitter = PexIo.loadFromXmlCompileTime( "html5editor/particle.pex" );
		
		
		canvas = cast Browser.document.getElementById( "canvas-editor" );//createCanvasElement();
		canvas.style.backgroundColor = "black";
			
		
		particleRenderer = new PexHtml5CanvasRenderer( canvas );
		particleImage = cast Browser.document.getElementById("particleImage");
		particleEmitter.start( Math.POSITIVE_INFINITY );
		Browser.window.requestAnimationFrame( update );
	}

	static var start = 0.0;

	public static function update( timestamp: Float ) {
		canvas.width = canvas.offsetWidth;
		canvas.height = canvas.offsetHeight;

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
