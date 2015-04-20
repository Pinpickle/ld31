import com.punkiversal.Engine;
import com.punkiversal.PV;
import com.punkiversal.utils.Input;
import com.punkiversal.utils.Key;
import flash.display.StageQuality;
import scenes.GameScene;
import com.punkiversal.utils.Data;

class Main extends Engine
{

	public static var gameScene:GameScene;

	override public function init()
	{
		trace('????');

		PV.stage.quality = StageQuality.BEST;
		PV.screen.smoothing = false;
#if debug
		PV.console.enable();
		PV.console.debug = true;
		PV.console.debugDraw = true;
#end
		
		PV.defaultFont = "font/emulogic.ttf";

		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("up", [Key.UP, Key.W, Key.SPACE]);
		Input.define("down", [Key.DOWN, Key.S]);

		PV.scene = gameScene = new scenes.GameScene();

		Data.load("save");
	}

	public static function main() { new Main(600, 600); }

}
